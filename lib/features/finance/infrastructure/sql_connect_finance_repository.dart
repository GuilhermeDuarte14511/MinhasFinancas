import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

import '../../../core/money/money.dart';
import '../../billing/domain/card_invoice_cycle.dart';
import '../../billing/domain/installment_schedule.dart';
import '../../billing/domain/recurrence_schedule.dart' as schedule;
import '../application/finance_repository.dart';
import '../domain/cash_flow.dart' as cash;
import '../domain/finance_models.dart' as domain;
import '../domain/financial_planning.dart' as planning;
import 'sql_connect_generated/client.dart' as sql;

final class SqlConnectFinanceRepository implements FinanceRepository {
  const SqlConnectFinanceRepository({this._connector});

  final sql.ClientConnector? _connector;

  sql.ClientConnector get _client => _connector ?? sql.ClientConnector.instance;

  @override
  Future<List<WorkspaceSummary>> listMySpaces() async {
    final result = await _client.listMySpaces().execute(
      fetchPolicy: QueryFetchPolicy.serverOnly,
    );
    return [
      for (final membership in result.data.spaceMembers)
        WorkspaceSummary(
          id: membership.financialSpace.id,
          name: membership.financialSpace.name,
          colorValue: _colorValue(membership.financialSpace.colorHex),
          role: _membershipRole(membership.role),
        ),
    ];
  }

  @override
  Future<WorkspaceSnapshot> loadWorkspace(String spaceId) async {
    final result = await _client
        .getWorkspaceSnapshot(spaceId: spaceId)
        .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    final data = result.data;
    final space = data.financialSpace;
    if (space == null) throw StateError('Espaço financeiro não encontrado.');
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final canMaterializeRecurrences = data.spaceMembers.any(
      (member) =>
          member.memberFirebaseUid == currentUid &&
          member.role.stringValue != 'VIEWER',
    );
    if (canMaterializeRecurrences) {
      try {
        final changed = await _materializeOpenEndedRecurrences(spaceId, data);
        if (changed) return loadWorkspace(spaceId);
      } catch (_) {
        // A leitura atual permanece disponível; a próxima atualização tenta
        // completar novamente a janela futura com as mesmas chaves idempotentes.
      }
    }
    var pendingInvitations = const <domain.InvitationRecord>[];
    try {
      final invitations = await _client
          .listSpaceInvitations(spaceId: spaceId)
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      pendingInvitations = [
        for (final invitation in invitations.data.spaceInvitations)
          domain.InvitationRecord(
            id: invitation.id,
            email: invitation.email,
            role: _membershipRole(invitation.role),
            expiresAt: invitation.expiresAt.toDateTime(),
          ),
      ];
    } catch (_) {
      // Viewers can load the workspace but cannot inspect invitation e-mails.
    }

    final invoiceCardIds = {
      for (final invoice in data.creditCardInvoices)
        invoice.id: invoice.creditCard.id,
    };
    final paidByCard = <String, int>{};
    for (final payment in data.invoicePayments) {
      final cardId = invoiceCardIds[payment.invoice.id];
      if (cardId != null) {
        paidByCard.update(
          cardId,
          (value) => value + payment.amountCents.toInt(),
          ifAbsent: () => payment.amountCents.toInt(),
        );
      }
    }
    final purchasesByCard = <String, int>{};
    for (final purchase in data.purchases) {
      purchasesByCard.update(
        purchase.creditCard.id,
        (value) => value + purchase.totalAmountCents.toInt(),
        ifAbsent: () => purchase.totalAmountCents.toInt(),
      );
    }

    final cards = [
      for (final card in data.creditCards)
        domain.CreditCardAccount(
          id: card.id,
          nickname: card.nickname,
          lastFourDigits: card.lastFourDigits,
          cardholder: card.cardholderMember.user.displayName,
          limit: Money.fromCents(card.creditLimitCents.toInt()),
          committed: Money.fromCents(
            ((purchasesByCard[card.id] ?? 0) - (paidByCard[card.id] ?? 0))
                .clamp(0, card.creditLimitCents.toInt()),
          ),
          closingDay: card.closingDay,
          dueDay: card.dueDay,
          colorValue: _colorValue(card.colorHex),
        ),
    ];

    final installmentsByLoan =
        <String, List<sql.GetWorkspaceSnapshotLoanInstallments>>{};
    for (final installment in data.loanInstallments) {
      installmentsByLoan
          .putIfAbsent(installment.loan.id, () => [])
          .add(installment);
    }
    final spaceMembers = [...data.spaceMembers]
      ..sort((a, b) {
        if (a.role.stringValue == 'OWNER') return -1;
        if (b.role.stringValue == 'OWNER') return 1;
        return a.user.displayName.compareTo(b.user.displayName);
      });
    final currentMember = spaceMembers.firstWhere(
      (member) => member.memberFirebaseUid == currentUid,
      orElse: () => spaceMembers.first,
    );
    final rulesByType = {
      for (final rule in data.notificationRules)
        rule.eventType.stringValue: rule,
    };
    final preference = data.notificationPreferences.firstOrNull;
    final purchases = [
      for (final purchase in data.purchases)
        domain.PurchaseRecord(
          id: purchase.id,
          description: purchase.description,
          category: purchase.category.name,
          cardId: purchase.creditCard.id,
          total: Money.fromCents(purchase.totalAmountCents.toInt()),
          installmentCount: purchase.installmentCount,
          purchaseDate: purchase.purchaseDate,
          createdBy: purchase.createdByUser.displayName,
        ),
    ];
    final cashFlowEntries = [
      for (final entry in data.cashFlowEntries) _mapCashFlowEntry(entry),
    ];
    final now = DateTime.now();
    var cashFlowOverview = cash.CashFlowOverview.fromEntries(
      entries: cashFlowEntries,
      referenceDate: now,
    );
    try {
      final summary = await _client
          .getCashFlowSummary(
            spaceId: spaceId,
            monthStart: DateTime(now.year, now.month),
            yearStart: DateTime(now.year),
            nextYearStart: DateTime(now.year + 1),
            monthStartedAt: _timestamp(DateTime(now.year, now.month)),
            nextMonthStartedAt: _timestamp(DateTime(now.year, now.month + 1)),
            yearStartedAt: _timestamp(DateTime(now.year)),
            nextYearStartedAt: _timestamp(DateTime(now.year + 1)),
          )
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      cashFlowOverview = _mapCashFlowOverview(summary.data, now);
    } catch (_) {
      // The entry projection remains available during a rolling backend update.
    }
    return WorkspaceSnapshot(
      id: space.id,
      name: space.name,
      colorValue: _colorValue(space.colorHex),
      cards: cards,
      purchases: purchases,
      cashFlowEntries: cashFlowEntries,
      cashFlowOverview: cashFlowOverview,
      purchaseInstallments: [
        for (final installment in data.purchaseInstallments)
          domain.PurchaseInstallmentRecord(
            id: installment.id,
            purchaseId: installment.purchase.id,
            invoiceId: installment.invoice.id,
            number: installment.installmentNumber,
            count: installment.installmentCount,
            amount: Money.fromCents(installment.amountCents.toInt()),
            dueDate: installment.dueDate,
            status: _installmentStatus(installment.status),
          ),
      ],
      invoices: [
        for (final invoice in data.creditCardInvoices)
          domain.InvoiceSummary(
            id: invoice.id,
            cardId: invoice.creditCard.id,
            cardName: invoice.creditCard.nickname,
            referenceMonth: invoice.referenceMonth,
            dueDate: invoice.dueDate,
            total: Money.fromCents(invoice.totalAmountCents.toInt()),
            paid: Money.fromCents(invoice.paidAmountCents.toInt()),
            status: _invoiceStatus(invoice.status),
          ),
      ],
      loans: [
        for (final loan in data.loans)
          _mapLoan(loan, installmentsByLoan[loan.id] ?? const []),
      ],
      loanInstallments: [
        for (final installment in data.loanInstallments)
          domain.LoanInstallmentRecord(
            id: installment.id,
            loanId: installment.loan.id,
            number: installment.installmentNumber,
            dueDate: installment.dueDate,
            total: Money.fromCents(installment.totalAmountCents.toInt()),
            paid: Money.fromCents(installment.paidAmountCents.toInt()),
            status: _loanInstallmentStatus(installment.status),
          ),
      ],
      activities: [
        for (final event in data.auditEvents)
          domain.ActivityEntry(
            person: event.actorUser.displayName,
            description: event.summary,
            whenLabel: _relativeTime(event.occurredAt.toDateTime()),
          ),
      ],
      categories: [for (final category in data.categories) category.name],
      categoryIdsByName: {
        for (final category in data.categories) category.name: category.id,
      },
      members: [
        for (final member in spaceMembers)
          domain.MemberRecord(
            id: member.id,
            name: member.user.displayName,
            email: member.user.email,
            role: _membershipRole(member.role),
            status: _membershipStatus(member.status),
            isCurrentUser: member.memberFirebaseUid == currentUid,
          ),
      ],
      invitations: pendingInvitations,
      currentRole: _membershipRole(currentMember.role),
      notificationSettings: domain.NotificationSettings(
        enabled: preference?.enabled ?? true,
        pushEnabled: preference?.pushEnabled ?? false,
        inAppEnabled: preference?.inAppEnabled ?? true,
        preferredTime: preference?.preferredTime ?? '09:00',
        invoiceClosing: rulesByType['INVOICE_CLOSING']?.enabled ?? true,
        invoiceDue: rulesByType['INVOICE_DUE']?.enabled ?? true,
        loanDue: rulesByType['LOAN_INSTALLMENT_DUE']?.enabled ?? true,
        daysBefore: rulesByType['INVOICE_DUE']?.daysBefore ?? 3,
      ),
      accounts: [
        for (final account in data.financialAccounts)
          planning.FinancialAccount(
            id: account.id,
            name: account.name,
            institutionName: account.institutionName,
            type: _financialAccountType(account.type),
            openingBalance: Money.fromCents(
              account.openingBalanceCents.toInt(),
            ),
            openingBalanceAt: account.openingBalanceAt.toDateTime(),
            colorValue: _colorValue(account.colorHex),
            includeInTotal: account.includeInTotal,
          ),
      ],
      accountTransfers: [
        for (final transfer in data.accountTransfers)
          planning.AccountTransfer(
            id: transfer.id,
            fromAccountId: transfer.fromAccount.id,
            toAccountId: transfer.toAccount.id,
            amount: Money.fromCents(transfer.amountCents.toInt()),
            transferredAt: transfer.transferredAt.toDateTime(),
            notes: transfer.notes,
          ),
      ],
      monthlyBudgets: [
        for (final budget in data.monthlyBudgets)
          planning.MonthlyBudget(
            id: budget.id,
            categoryId: budget.category.id,
            categoryName: budget.category.name,
            referenceMonth: budget.referenceMonth,
            limit: Money.fromCents(budget.limitAmountCents.toInt()),
          ),
      ],
      accountSettlements: [
        for (final payment in data.invoicePayments)
          if (payment.financialAccount case final account?)
            planning.AccountSettlement(
              id: payment.id,
              accountId: account.id,
              amount: Money.fromCents(payment.amountCents.toInt()),
              paidAt: payment.paidAt.toDateTime(),
            ),
        for (final payment in data.loanPayments)
          if (payment.financialAccount case final account?)
            planning.AccountSettlement(
              id: payment.id,
              accountId: account.id,
              amount: Money.fromCents(payment.amountCents.toInt()),
              paidAt: payment.paidAt.toDateTime(),
            ),
      ],
    );
  }

  @override
  Future<String> createSpace({
    required String name,
    required int colorValue,
  }) async {
    final result = await _client
        .createFinancialSpace(name: name, colorHex: _colorHex(colorValue))
        .execute();
    return result.data.space.id;
  }

  @override
  Future<void> updateSpace({
    required String spaceId,
    required String name,
    required int colorValue,
  }) async {
    await _client
        .updateFinancialSpace(
          spaceId: spaceId,
          name: name.trim(),
          colorHex: _colorHex(colorValue),
        )
        .execute();
  }

  @override
  Future<void> archiveSpace({required String spaceId}) async {
    await _client.archiveFinancialSpace(spaceId: spaceId).execute();
  }

  @override
  Future<String> createInvitation({
    required String spaceId,
    required String email,
    required domain.MembershipRole role,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    final token = _secureToken();
    await _client
        .createSpaceInvitation(
          spaceId: spaceId,
          email: normalizedEmail,
          normalizedEmail: normalizedEmail,
          role: switch (role) {
            domain.MembershipRole.owner => sql.MembershipRole.OWNER,
            domain.MembershipRole.editor => sql.MembershipRole.EDITOR,
            domain.MembershipRole.viewer => sql.MembershipRole.VIEWER,
          },
          tokenHash: _hashToken(token),
          expiresAt: _timestamp(
            DateTime.now().toUtc().add(const Duration(days: 7)),
          ),
        )
        .execute();
    return 'https://minhasfinancasofc.web.app/join-space?invite=$token';
  }

  @override
  Future<String> acceptInvitation(String tokenOrLink) async {
    final token = _extractToken(tokenOrLink);
    final result = await _client
        .acceptSpaceInvitation(tokenHash: _hashToken(token))
        .execute();
    return result.data.member.id;
  }

  @override
  Future<void> revokeInvitation({
    required String spaceId,
    required String invitationId,
  }) async {
    await _client
        .revokeSpaceInvitation(spaceId: spaceId, invitationId: invitationId)
        .execute();
  }

  @override
  Future<void> updateMemberRole({
    required String spaceId,
    required String memberId,
    required domain.MembershipRole role,
  }) async {
    await _client
        .updateMemberRole(
          spaceId: spaceId,
          memberId: memberId,
          role: _sqlMembershipRole(role),
        )
        .execute();
  }

  @override
  Future<void> removeMember({
    required String spaceId,
    required String memberId,
  }) async {
    await _client
        .removeSpaceMember(spaceId: spaceId, memberId: memberId)
        .execute();
  }

  @override
  Future<void> createCategory({
    required String spaceId,
    required String name,
  }) async {
    await _client
        .createCategory(
          spaceId: spaceId,
          name: name.trim(),
          normalizedName: name.trim().toLowerCase(),
          icon: 'category',
          colorHex: '#777587',
        )
        .execute();
  }

  @override
  Future<void> updateCategory({
    required String spaceId,
    required String categoryId,
    required String name,
  }) async {
    await _client
        .updateCategory(
          spaceId: spaceId,
          categoryId: categoryId,
          name: name.trim(),
          normalizedName: name.trim().toLowerCase(),
        )
        .execute();
  }

  @override
  Future<void> archiveCategory({
    required String spaceId,
    required String categoryId,
  }) async {
    await _client
        .archiveCategory(spaceId: spaceId, categoryId: categoryId)
        .execute();
  }

  @override
  Future<void> createCashFlowEntry({
    required String spaceId,
    required cash.CashFlowDirection direction,
    required cash.CashFlowKind kind,
    required cash.CashFlowPaymentMethod paymentMethod,
    required String description,
    required Money amount,
    required DateTime occurredAt,
    required cash.CashFlowStatus status,
    cash.RecurrenceRule? recurrence,
    String? categoryId,
    String? accountId,
    String? notes,
  }) async {
    if (status == cash.CashFlowStatus.cancelled) {
      throw StateError('Um novo lançamento não pode nascer cancelado.');
    }
    if (recurrence?.isRecurring == true) {
      await _createRecurringCashFlowEntries(
        spaceId: spaceId,
        direction: direction,
        kind: kind,
        paymentMethod: paymentMethod,
        description: description,
        amount: amount,
        occurredAt: occurredAt,
        status: status,
        recurrence: recurrence!,
        categoryId: categoryId,
        accountId: accountId,
        notes: notes,
      );
      return;
    }
    final competenceMonth = DateTime(occurredAt.year, occurredAt.month);
    final idempotencyKey = _secureToken();
    if (direction == cash.CashFlowDirection.income) {
      if (status == cash.CashFlowStatus.scheduled) {
        await (_client.createScheduledIncomeEntry(
                spaceId: spaceId,
                description: description.trim(),
                kind: _sqlCashFlowKind(kind),
                paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
                amountCents: BigInt.from(amount.cents),
                occurredAt: _timestamp(occurredAt),
                competenceMonth: competenceMonth,
                idempotencyKey: idempotencyKey,
              )
              ..categoryId(categoryId)
              ..accountId(accountId)
              ..notes(_optionalText(notes)))
            .execute();
        return;
      }
      await (_client.createIncomeEntry(
              spaceId: spaceId,
              description: description.trim(),
              kind: _sqlCashFlowKind(kind),
              paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
              amountCents: BigInt.from(amount.cents),
              occurredAt: _timestamp(occurredAt),
              competenceMonth: competenceMonth,
              idempotencyKey: idempotencyKey,
            )
            ..categoryId(categoryId)
            ..accountId(accountId)
            ..notes(_optionalText(notes)))
          .execute();
      return;
    }
    if (categoryId == null) {
      throw StateError('Categoria obrigatória para uma saída.');
    }
    if (status == cash.CashFlowStatus.scheduled) {
      await (_client.createPlannedExpenseEntry(
              spaceId: spaceId,
              categoryId: categoryId,
              description: description.trim(),
              kind: _sqlCashFlowKind(kind),
              paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
              amountCents: BigInt.from(amount.cents),
              occurredAt: _timestamp(occurredAt),
              competenceMonth: competenceMonth,
              idempotencyKey: idempotencyKey,
            )
            ..accountId(accountId)
            ..notes(_optionalText(notes)))
          .execute();
      return;
    }
    await (_client.createExpenseEntry(
            spaceId: spaceId,
            categoryId: categoryId,
            description: description.trim(),
            kind: _sqlCashFlowKind(kind),
            paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
            amountCents: BigInt.from(amount.cents),
            occurredAt: _timestamp(occurredAt),
            competenceMonth: competenceMonth,
            idempotencyKey: idempotencyKey,
          )
          ..accountId(accountId)
          ..notes(_optionalText(notes)))
        .execute();
  }

  @override
  Future<void> updateCashFlowEntry({
    required String spaceId,
    required String entryId,
    required cash.CashFlowDirection direction,
    required String? recurrenceSeriesId,
    required DateTime originalOccurredAt,
    required cash.CashFlowKind kind,
    required cash.CashFlowPaymentMethod paymentMethod,
    required String description,
    required Money amount,
    required DateTime occurredAt,
    required cash.CashFlowStatus status,
    required cash.RecurrenceScope scope,
    String? categoryId,
    String? accountId,
    String? notes,
  }) async {
    final sqlStatus = _sqlCashFlowStatus(status, direction);
    final realizedAt = status == cash.CashFlowStatus.confirmed
        ? _timestamp(DateTime.now())
        : null;
    if (scope == cash.RecurrenceScope.single) {
      await (_client.updateCashFlowOccurrence(
              spaceId: spaceId,
              entryId: entryId,
              scope: sql.CashFlowMutationScope.ONLY_THIS,
              description: description.trim(),
              kind: _sqlCashFlowKind(kind),
              paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
              amountCents: BigInt.from(amount.cents),
              occurredAt: _timestamp(occurredAt),
              competenceMonth: DateTime(occurredAt.year, occurredAt.month),
              status: sqlStatus,
            )
            ..categoryId(categoryId)
            ..accountId(accountId)
            ..notes(_optionalText(notes))
            ..receivedAt(
              direction == cash.CashFlowDirection.income ? realizedAt : null,
            )
            ..paidAt(
              direction == cash.CashFlowDirection.expense ? realizedAt : null,
            ))
          .execute();
      return;
    }
    if (recurrenceSeriesId == null) {
      throw StateError(
        'A série recorrente deste lançamento não foi encontrada.',
      );
    }
    if (scope == cash.RecurrenceScope.thisAndFuture) {
      await (_client.updateCashFlowSeriesFrom(
              spaceId: spaceId,
              seriesId: recurrenceSeriesId,
              scope: sql.CashFlowMutationScope.THIS_AND_FUTURE,
              cutoffAt: _timestamp(originalOccurredAt),
              description: description.trim(),
              kind: _sqlCashFlowKind(kind),
              paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
              amountCents: BigInt.from(amount.cents),
              entryStatus: sqlStatus,
            )
            ..categoryId(categoryId)
            ..accountId(accountId)
            ..notes(_optionalText(notes))
            ..receivedAt(
              direction == cash.CashFlowDirection.income ? realizedAt : null,
            )
            ..paidAt(
              direction == cash.CashFlowDirection.expense ? realizedAt : null,
            ))
          .execute();
      return;
    }
    await (_client.updateEntireCashFlowSeries(
            spaceId: spaceId,
            seriesId: recurrenceSeriesId,
            scope: sql.CashFlowMutationScope.ENTIRE_SERIES,
            description: description.trim(),
            kind: _sqlCashFlowKind(kind),
            paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
            amountCents: BigInt.from(amount.cents),
            entryStatus: sqlStatus,
          )
          ..categoryId(categoryId)
          ..accountId(accountId)
          ..notes(_optionalText(notes))
          ..receivedAt(
            direction == cash.CashFlowDirection.income ? realizedAt : null,
          )
          ..paidAt(
            direction == cash.CashFlowDirection.expense ? realizedAt : null,
          ))
        .execute();
  }

  @override
  Future<void> updateCashFlowStatus({
    required String spaceId,
    required String entryId,
    required cash.CashFlowDirection direction,
    required cash.CashFlowStatus status,
  }) async {
    if (status != cash.CashFlowStatus.confirmed) {
      throw StateError('Use a edição ou exclusão para alterar este status.');
    }
    final now = _timestamp(DateTime.now());
    if (direction == cash.CashFlowDirection.income) {
      await _client
          .markIncomeEntryReceived(
            spaceId: spaceId,
            entryId: entryId,
            receivedAt: now,
          )
          .execute();
      return;
    }
    await _client
        .markExpenseEntryPaid(spaceId: spaceId, entryId: entryId, paidAt: now)
        .execute();
  }

  @override
  Future<void> deleteCashFlowEntry({
    required String spaceId,
    required String entryId,
    required String? recurrenceSeriesId,
    required DateTime occurredAt,
    required cash.RecurrenceScope scope,
  }) async {
    if (recurrenceSeriesId == null) {
      await _client
          .deleteStandaloneCashFlowEntry(
            spaceId: spaceId,
            entryId: entryId,
            scope: sql.CashFlowMutationScope.ONLY_THIS,
          )
          .execute();
      return;
    }
    if (scope == cash.RecurrenceScope.single) {
      await _client
          .deleteCashFlowOccurrence(
            spaceId: spaceId,
            entryId: entryId,
            scope: sql.CashFlowMutationScope.ONLY_THIS,
            reason: 'Excluída pelo usuário',
          )
          .execute();
      return;
    }
    if (scope == cash.RecurrenceScope.thisAndFuture) {
      final lastKeptDate = DateTime(
        occurredAt.year,
        occurredAt.month,
        occurredAt.day,
      ).subtract(const Duration(days: 1));
      await (_client.deleteCashFlowSeriesFrom(
        spaceId: spaceId,
        seriesId: recurrenceSeriesId,
        scope: sql.CashFlowMutationScope.THIS_AND_FUTURE,
        cutoffAt: _timestamp(occurredAt),
        reason: 'Esta ocorrência e as próximas foram excluídas.',
      )..lastKeptDate(lastKeptDate)).execute();
      return;
    }
    await _client
        .deleteEntireCashFlowSeries(
          spaceId: spaceId,
          seriesId: recurrenceSeriesId,
          scope: sql.CashFlowMutationScope.ENTIRE_SERIES,
          reason: 'Série excluída pelo usuário',
        )
        .execute();
  }

  @override
  Future<void> createAccount({
    required String spaceId,
    required String name,
    required planning.FinancialAccountType type,
    required Money openingBalance,
    required DateTime openingBalanceAt,
    required int colorValue,
    required bool includeInTotal,
    String? institutionName,
  }) async {
    await (_client.createFinancialAccount(
      spaceId: spaceId,
      name: name.trim(),
      normalizedName: name.trim().toLowerCase(),
      type: _sqlFinancialAccountType(type),
      openingBalanceCents: BigInt.from(openingBalance.cents),
      openingBalanceAt: _timestamp(openingBalanceAt),
      colorHex: _colorHex(colorValue),
      includeInTotal: includeInTotal,
    )..institutionName(_optionalText(institutionName))).execute();
  }

  @override
  Future<void> updateAccount({
    required String spaceId,
    required String accountId,
    required String name,
    required planning.FinancialAccountType type,
    required int colorValue,
    required bool includeInTotal,
    String? institutionName,
  }) async {
    await (_client.updateFinancialAccount(
      spaceId: spaceId,
      accountId: accountId,
      name: name.trim(),
      normalizedName: name.trim().toLowerCase(),
      type: _sqlFinancialAccountType(type),
      colorHex: _colorHex(colorValue),
      includeInTotal: includeInTotal,
    )..institutionName(_optionalText(institutionName))).execute();
  }

  @override
  Future<void> archiveAccount({
    required String spaceId,
    required String accountId,
  }) async {
    await _client
        .archiveFinancialAccount(spaceId: spaceId, accountId: accountId)
        .execute();
  }

  @override
  Future<void> createAccountTransfer({
    required String spaceId,
    required String fromAccountId,
    required String toAccountId,
    required Money amount,
    required DateTime transferredAt,
    String? notes,
  }) async {
    await (_client.createAccountTransfer(
      spaceId: spaceId,
      fromAccountId: fromAccountId,
      toAccountId: toAccountId,
      amountCents: BigInt.from(amount.cents),
      transferredAt: _timestamp(transferredAt),
      idempotencyKey: _secureToken(),
    )..notes(_optionalText(notes))).execute();
  }

  @override
  Future<void> cancelAccountTransfer({
    required String spaceId,
    required String transferId,
  }) async {
    await _client
        .cancelAccountTransfer(spaceId: spaceId, transferId: transferId)
        .execute();
  }

  @override
  Future<void> setMonthlyBudget({
    required String spaceId,
    required String categoryId,
    required DateTime referenceMonth,
    required Money limit,
  }) async {
    final month = DateTime(referenceMonth.year, referenceMonth.month);
    final key = sha256.convert(
      utf8.encode('$spaceId:$categoryId:${month.toIso8601String()}'),
    );
    await _client
        .setMonthlyBudget(
          id: _uuidFromHash(key.toString()),
          spaceId: spaceId,
          categoryId: categoryId,
          referenceMonth: month,
          limitAmountCents: BigInt.from(limit.cents),
        )
        .execute();
  }

  @override
  Future<void> deleteMonthlyBudget({
    required String spaceId,
    required String budgetId,
  }) async {
    await _client
        .deleteMonthlyBudget(spaceId: spaceId, budgetId: budgetId)
        .execute();
  }

  @override
  Future<void> createCard({
    required String spaceId,
    required String nickname,
    required String lastFourDigits,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {
    await _client
        .createCreditCard(
          spaceId: spaceId,
          nickname: nickname,
          lastFourDigits: lastFourDigits,
          creditLimitCents: BigInt.from(limit.cents),
          closingDay: closingDay,
          dueDay: dueDay,
          colorHex: _colorHex(colorValue),
        )
        .execute();
  }

  @override
  Future<void> updateCard({
    required String spaceId,
    required String cardId,
    required String nickname,
    required Money limit,
    required int closingDay,
    required int dueDay,
    required int colorValue,
  }) async {
    await _client
        .updateCreditCard(
          spaceId: spaceId,
          cardId: cardId,
          nickname: nickname.trim(),
          creditLimitCents: BigInt.from(limit.cents),
          closingDay: closingDay,
          dueDay: dueDay,
          colorHex: _colorHex(colorValue),
        )
        .execute();
  }

  @override
  Future<void> archiveCard({
    required String spaceId,
    required String cardId,
  }) async {
    await _client.archiveCreditCard(spaceId: spaceId, cardId: cardId).execute();
  }

  @override
  Future<void> deleteCard({
    required String spaceId,
    required String cardId,
  }) async {
    await _client
        .deleteCreditCardCascade(spaceId: spaceId, cardId: cardId)
        .execute();
  }

  @override
  Future<void> createPurchase({
    required String spaceId,
    required String description,
    required String categoryId,
    required String cardId,
    required Money total,
    required int installmentCount,
    required DateTime purchaseDate,
    required int cardClosingDay,
    required int cardDueDay,
  }) async {
    final firstCycle = const CardInvoiceCycleCalculator().calculate(
      purchaseDate: purchaseDate,
      closingDay: cardClosingDay,
      dueDay: cardDueDay,
    );
    final firstReference = firstCycle.referenceMonth;
    final purchaseResult = await _client
        .createPurchase(
          spaceId: spaceId,
          cardId: cardId,
          categoryId: categoryId,
          description: description,
          totalAmountCents: BigInt.from(total.cents),
          purchaseDate: purchaseDate,
          installmentCount: installmentCount,
          firstInvoiceReference: firstReference,
        )
        .execute();
    final purchaseId = purchaseResult.data.purchase.id;
    final schedule = const InstallmentScheduleGenerator().generate(
      total: total,
      count: installmentCount,
      firstReferenceMonth: firstReference,
    );

    try {
      for (final installment in schedule) {
        final reference = DateTime(
          installment.referenceMonth.year,
          installment.referenceMonth.month,
          1,
        );
        final invoiceId = await _ensureInvoice(
          spaceId: spaceId,
          cardId: cardId,
          referenceMonth: reference,
          closingDay: cardClosingDay,
          dueDay: cardDueDay,
        );
        await _client
            .addPurchaseInstallment(
              spaceId: spaceId,
              purchaseId: purchaseId,
              invoiceId: invoiceId,
              installmentNumber: installment.number,
              installmentCount: installmentCount,
              amountCents: BigInt.from(installment.amount.cents),
              dueDate: _invoiceDueDate(reference, cardDueDay),
            )
            .execute();
      }
    } catch (_) {
      await cancelPurchase(spaceId: spaceId, purchaseId: purchaseId);
      rethrow;
    }
  }

  @override
  Future<void> updatePurchase({
    required String spaceId,
    required String purchaseId,
    required String description,
    required String categoryId,
  }) async {
    await _client
        .updatePurchaseDetails(
          spaceId: spaceId,
          purchaseId: purchaseId,
          description: description,
          categoryId: categoryId,
        )
        .execute();
  }

  @override
  Future<void> cancelPurchase({
    required String spaceId,
    required String purchaseId,
  }) async {
    final installments = await _client
        .getPurchaseInstallmentsForCancellation(
          spaceId: spaceId,
          purchaseId: purchaseId,
        )
        .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
    for (final installment in installments.data.purchaseInstallments) {
      await _client
          .cancelPurchaseInstallment(
            spaceId: spaceId,
            installmentId: installment.id,
            invoiceId: installment.invoice.id,
            amountCents: installment.amountCents,
          )
          .execute();
    }
    await _client
        .cancelPurchase(
          spaceId: spaceId,
          purchaseId: purchaseId,
          reason: 'Excluída pelo usuário',
        )
        .execute();
  }

  @override
  Future<void> registerInvoicePayment({
    required String spaceId,
    required String invoiceId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
    String? accountId,
  }) async {
    if (amount.cents >= pendingBeforePayment.cents) {
      await (_client.registerFullInvoicePayment(
        spaceId: spaceId,
        invoiceId: invoiceId,
        amountCents: BigInt.from(amount.cents),
        paidAt: _timestamp(paidAt),
        idempotencyKey: _secureToken(),
      )..accountId(accountId)).execute();
      return;
    }
    await (_client.registerInvoicePayment(
      spaceId: spaceId,
      invoiceId: invoiceId,
      amountCents: BigInt.from(amount.cents),
      paidAt: _timestamp(paidAt),
      idempotencyKey: _secureToken(),
      resultingStatus: sql.InvoiceStatus.PARTIALLY_PAID,
    )..accountId(accountId)).execute();
  }

  @override
  Future<void> createLoan({
    required String spaceId,
    required String lender,
    required String description,
    required Money amount,
    required Money installmentAmount,
    required int installmentCount,
    required int dueDay,
  }) async {
    final firstDueDate = _safeDate(
      DateTime.now().year,
      DateTime.now().month + 1,
      dueDay,
    );
    final builder =
        _client.createLoan(
            spaceId: spaceId,
            name: description,
            principalAmountCents: BigInt.from(amount.cents),
            monthlyInterestRateMicros: BigInt.zero,
            amortizationMethod: sql.LoanAmortizationMethod.MANUAL,
            installmentCount: installmentCount,
            firstDueDate: firstDueDate,
          )
          ..lender(lender)
          ..contractedAt(DateTime.now())
          ..expectedInstallmentAmountCents(
            BigInt.from(installmentAmount.cents),
          );
    final result = await builder.execute();
    final loanId = result.data.loan.id;
    final basePrincipal = amount.cents ~/ installmentCount;
    final remainder = amount.cents % installmentCount;
    var opening = amount.cents;
    try {
      for (var index = 0; index < installmentCount; index++) {
        final principal = basePrincipal + (index < remainder ? 1 : 0);
        final interest = max(0, installmentAmount.cents - principal);
        await _client
            .addLoanInstallment(
              spaceId: spaceId,
              loanId: loanId,
              installmentNumber: index + 1,
              dueDate: _safeDate(
                firstDueDate.year,
                firstDueDate.month + index,
                dueDay,
              ),
              openingBalanceCents: BigInt.from(opening),
              principalAmountCents: BigInt.from(principal),
              interestAmountCents: BigInt.from(interest),
              totalAmountCents: BigInt.from(principal + interest),
            )
            .execute();
        opening -= principal;
      }
    } catch (_) {
      await _client.cancelLoan(spaceId: spaceId, loanId: loanId).execute();
      rethrow;
    }
  }

  @override
  Future<void> registerLoanPayment({
    required String spaceId,
    required String loanId,
    required String installmentId,
    required Money amount,
    required Money pendingBeforePayment,
    required DateTime paidAt,
    String? accountId,
  }) async {
    await (_client.registerLoanPayment(
      spaceId: spaceId,
      loanId: loanId,
      loanInstallmentId: installmentId,
      amountCents: BigInt.from(amount.cents),
      paidAt: _timestamp(paidAt),
      idempotencyKey: _secureToken(),
      resultingStatus: amount.cents >= pendingBeforePayment.cents
          ? sql.LoanInstallmentStatus.PAID
          : sql.LoanInstallmentStatus.PARTIALLY_PAID,
    )..accountId(accountId)).execute();
  }

  @override
  Future<void> updateNotificationPreference({
    required String spaceId,
    required domain.NotificationSettings settings,
  }) async {
    await _client
        .updateNotificationPreference(
          spaceId: spaceId,
          enabled: settings.enabled,
          pushEnabled: settings.pushEnabled,
          inAppEnabled: settings.inAppEnabled,
          preferredTime: settings.preferredTime,
        )
        .execute();
    await _client
        .updateNotificationRules(
          spaceId: spaceId,
          invoiceClosing: settings.invoiceClosing,
          invoiceDue: settings.invoiceDue,
          loanDue: settings.loanDue,
          daysBefore: settings.daysBefore,
        )
        .execute();
  }

  @override
  Future<void> registerNotificationDevice({
    required String token,
    required bool isWeb,
    required String deviceName,
  }) async {
    final hash = _hashToken(token);
    final builder = _client.registerDeviceSubscription(
      id: _uuidFromHash(hash),
      platform: isWeb
          ? sql.NotificationPlatform.WEB
          : sql.NotificationPlatform.ANDROID,
      tokenOrEndpoint: token,
      tokenHash: hash,
    )..deviceName(deviceName);
    await builder.execute();
  }

  Future<void> _createRecurringCashFlowEntries({
    required String spaceId,
    required cash.CashFlowDirection direction,
    required cash.CashFlowKind kind,
    required cash.CashFlowPaymentMethod paymentMethod,
    required String description,
    required Money amount,
    required DateTime occurredAt,
    required cash.CashFlowStatus status,
    required cash.RecurrenceRule recurrence,
    required String? categoryId,
    required String? accountId,
    required String? notes,
  }) async {
    if (direction == cash.CashFlowDirection.expense && categoryId == null) {
      throw StateError('Categoria obrigatória para uma saída recorrente.');
    }
    final startDate = DateTime(
      occurredAt.year,
      occurredAt.month,
      occurredAt.day,
    );
    final seriesBuilder =
        _client.createCashFlowRecurrenceSeries(
            spaceId: spaceId,
            direction: _sqlCashFlowDirection(direction),
            kind: _sqlCashFlowKind(kind),
            paymentMethod: _sqlCashFlowPaymentMethod(paymentMethod),
            description: description.trim(),
            amountCents: BigInt.from(amount.cents),
            frequency: _sqlRecurrenceFrequency(recurrence.frequency),
            startDate: startDate,
            idempotencyKey: _secureToken(),
          )
          ..categoryId(categoryId)
          ..accountId(accountId)
          ..notes(_optionalText(notes))
          ..endDate(recurrence.endDate)
          ..occurrenceLimit(recurrence.occurrenceCount)
          ..preferredDay(recurrence.preferredDay)
          ..nextOccurrenceDate(startDate);
    final seriesResult = await seriesBuilder.execute();
    final seriesId = seriesResult.data.series.id;
    final materializedCount =
        recurrence.occurrenceCount ??
        (recurrence.endDate == null
            ? _defaultRecurrenceHorizon(recurrence.frequency)
            : null);
    final occurrences = const schedule.RecurrenceScheduleGenerator().generate(
      seriesId: seriesId,
      startsOn: startDate,
      frequency: _scheduleFrequency(recurrence.frequency),
      endsOn: recurrence.endDate,
      occurrenceCount: materializedCount,
      preferredDay: recurrence.preferredDay,
    );
    if (occurrences.isEmpty) {
      await _client
          .deleteEntireCashFlowSeries(
            spaceId: spaceId,
            seriesId: seriesId,
            scope: sql.CashFlowMutationScope.ENTIRE_SERIES,
            reason: 'Série sem ocorrências válidas',
          )
          .execute();
      throw StateError('A recorrência não gerou nenhuma data válida.');
    }
    try {
      for (var index = 0; index < occurrences.length; index++) {
        final occurrence = occurrences[index];
        final occurrenceStatus = _occurrenceStatus(
          requested: status,
          scheduledDate: occurrence.scheduledDate,
        );
        final realizedAt = occurrenceStatus == cash.CashFlowStatus.confirmed
            ? _timestamp(occurrence.scheduledDate)
            : null;
        final nextDate = index + 1 < occurrences.length
            ? occurrences[index + 1].scheduledDate
            : recurrence.withoutEnd
            ? _nextRecurrenceDate(recurrence, occurrence.scheduledDate)
            : null;
        await (_client.createRecurringCashFlowOccurrence(
                spaceId: spaceId,
                seriesId: seriesId,
                occurrenceIndex: occurrence.sequence,
                occurredAt: _timestamp(occurrence.scheduledDate),
                competenceMonth: DateTime(
                  occurrence.scheduledDate.year,
                  occurrence.scheduledDate.month,
                ),
                status: _sqlCashFlowStatus(occurrenceStatus, direction),
                idempotencyKey:
                    '$seriesId:${occurrence.sequence}:${occurrence.key.value}',
              )
              ..receivedAt(
                direction == cash.CashFlowDirection.income ? realizedAt : null,
              )
              ..paidAt(
                direction == cash.CashFlowDirection.expense ? realizedAt : null,
              )
              ..nextOccurrenceDate(nextDate))
            .execute();
      }
    } catch (_) {
      await _client
          .deleteEntireCashFlowSeries(
            spaceId: spaceId,
            seriesId: seriesId,
            scope: sql.CashFlowMutationScope.ENTIRE_SERIES,
            reason: 'Falha ao materializar as ocorrências',
          )
          .execute();
      rethrow;
    }
  }

  Future<bool> _materializeOpenEndedRecurrences(
    String spaceId,
    sql.GetWorkspaceSnapshotData data,
  ) async {
    final now = DateTime.now();
    final refillThreshold = DateTime(now.year, now.month + 12, now.day);
    var changed = false;
    for (final series in data.recurrenceSeries) {
      final nextDate = series.nextOccurrenceDate;
      final isOpenEnded =
          series.status.stringValue == 'ACTIVE' &&
          series.endDate == null &&
          series.occurrenceLimit == null;
      if (!isOpenEnded ||
          nextDate == null ||
          nextDate.isAfter(refillThreshold)) {
        continue;
      }
      final frequency = _cashRecurrenceFrequency(series.frequency.stringValue);
      final rule = cash.RecurrenceRule(
        frequency: frequency,
        preferredDay: series.preferredDay,
        withoutEnd: true,
      );
      final occurrences = const schedule.RecurrenceScheduleGenerator().generate(
        seriesId: series.id,
        startsOn: nextDate,
        frequency: _scheduleFrequency(frequency),
        occurrenceCount: _defaultRecurrenceHorizon(frequency),
        preferredDay: series.preferredDay,
      );
      final firstIndex = _recurrenceIndexFor(
        startDate: series.startDate,
        occurrenceDate: nextDate,
        frequency: frequency,
      );
      for (var index = 0; index < occurrences.length; index++) {
        final occurrence = occurrences[index];
        final occurrenceIndex = firstIndex + index;
        final following = index + 1 < occurrences.length
            ? occurrences[index + 1].scheduledDate
            : _nextRecurrenceDate(rule, occurrence.scheduledDate);
        await (_client.createRecurringCashFlowOccurrence(
          spaceId: spaceId,
          seriesId: series.id,
          occurrenceIndex: occurrenceIndex,
          occurredAt: _timestamp(occurrence.scheduledDate),
          competenceMonth: DateTime(
            occurrence.scheduledDate.year,
            occurrence.scheduledDate.month,
          ),
          status: sql.CashFlowStatus.PLANNED,
          idempotencyKey:
              '${series.id}:rolling:$occurrenceIndex:${occurrence.key.value}',
        )..nextOccurrenceDate(following)).execute();
        changed = true;
      }
    }
    return changed;
  }

  Future<String> _ensureInvoice({
    required String spaceId,
    required String cardId,
    required DateTime referenceMonth,
    required int closingDay,
    required int dueDay,
  }) async {
    Future<String?> find() async {
      final result = await _client
          .findCreditCardInvoice(
            spaceId: spaceId,
            cardId: cardId,
            referenceMonth: referenceMonth,
          )
          .execute(fetchPolicy: QueryFetchPolicy.serverOnly);
      return result.data.creditCardInvoices.firstOrNull?.id;
    }

    final existing = await find();
    if (existing != null) return existing;
    try {
      final created = await _client
          .createCreditCardInvoice(
            spaceId: spaceId,
            cardId: cardId,
            referenceMonth: referenceMonth,
            closingDate: _safeDate(
              referenceMonth.year,
              referenceMonth.month,
              closingDay,
            ),
            dueDate: _invoiceDueDate(referenceMonth, dueDay),
          )
          .execute();
      return created.data.invoice.id;
    } catch (_) {
      final raced = await find();
      if (raced != null) return raced;
      rethrow;
    }
  }

  static cash.CashFlowEntry _mapCashFlowEntry(
    sql.GetWorkspaceSnapshotCashFlowEntries entry,
  ) => cash.CashFlowEntry(
    id: entry.id,
    direction: _cashFlowDirection(entry.direction.stringValue),
    kind: _cashFlowKind(entry.kind.stringValue),
    paymentMethod: _cashFlowPaymentMethod(entry.paymentMethod.stringValue),
    description: entry.description,
    amount: Money.fromCents(entry.amountCents.toInt()),
    occurredAt: entry.occurredAt.toDateTime().toLocal(),
    competenceMonth: entry.competenceMonth,
    status: _cashFlowStatus(entry.status.stringValue),
    createdBy: entry.createdByUser.displayName,
    categoryId: entry.category?.id,
    categoryName: entry.category?.name,
    notes: entry.notes,
    sourceType: entry.sourceType,
    sourceEntityId: entry.sourceEntityId,
    accountId: entry.financialAccount?.id,
    recurrenceSeriesId: entry.recurrenceSeries?.id,
    occurrenceIndex: entry.occurrenceIndex,
    isRecurrenceException: entry.isRecurrenceException,
    receivedAt: entry.receivedAt?.toDateTime().toLocal(),
    paidAt: entry.paidAt?.toDateTime().toLocal(),
  );

  static cash.CashFlowOverview _mapCashFlowOverview(
    sql.GetCashFlowSummaryData data,
    DateTime referenceDate,
  ) {
    var month = _periodTotals([
      for (final group in data.month)
        (
          direction: group.direction.stringValue,
          cents: group.amountCents_sum?.toInt() ?? 0,
        ),
    ]);
    month = month.addExpense(
      Money.fromCents(
        _sumCents([
          for (final group in data.cardMonth) group.totalAmountCents_sum,
          for (final group in data.loanMonth) group.amountCents_sum,
        ]),
      ),
    );
    var year = _periodTotals([
      for (final group in data.year)
        (
          direction: group.direction.stringValue,
          cents: group.amountCents_sum?.toInt() ?? 0,
        ),
    ]);
    year = year.addExpense(
      Money.fromCents(
        _sumCents([
          for (final group in data.cardYear) group.totalAmountCents_sum,
          for (final group in data.loanYear) group.amountCents_sum,
        ]),
      ),
    );
    var lifetime = _periodTotals([
      for (final group in data.lifetime)
        (
          direction: group.direction.stringValue,
          cents: group.amountCents_sum?.toInt() ?? 0,
        ),
    ]);
    lifetime = lifetime.addExpense(
      Money.fromCents(
        _sumCents([
          for (final group in data.cardLifetime) group.totalAmountCents_sum,
          for (final group in data.loanLifetime) group.amountCents_sum,
        ]),
      ),
    );
    final plannedMonth = _periodTotals([
      for (final group in data.monthPlanned)
        (
          direction: group.direction.stringValue,
          cents: group.amountCents_sum?.toInt() ?? 0,
        ),
    ]);
    final plannedYear = _periodTotals([
      for (final group in data.yearPlanned)
        (
          direction: group.direction.stringValue,
          cents: group.amountCents_sum?.toInt() ?? 0,
        ),
    ]);
    final series = [
      for (var month = 1; month <= 12; month++)
        cash.MonthlyCashFlow(
          month: DateTime(referenceDate.year, month),
          totals: const cash.PeriodTotals.zero(),
        ),
    ];
    for (final group in data.yearSeries) {
      final index = group.competenceMonth.month - 1;
      final current = series[index];
      series[index] = cash.MonthlyCashFlow(
        month: current.month,
        totals: current.totals.add(
          _cashFlowDirection(group.direction.stringValue),
          Money.fromCents(group.amountCents_sum?.toInt() ?? 0),
        ),
      );
    }
    for (final group in data.cardYearSeries) {
      final index = group.referenceMonth.month - 1;
      series[index] = series[index].addExpense(
        Money.fromCents(group.totalAmountCents_sum?.toInt() ?? 0),
      );
    }
    for (final group in data.loanYearSeries) {
      final paidAt = group.paidAt.toDateTime().toLocal();
      final index = paidAt.month - 1;
      series[index] = series[index].addExpense(
        Money.fromCents(group.amountCents_sum?.toInt() ?? 0),
      );
    }
    DateTime? firstRecord;
    DateTime? lastRecord;

    void includeRange(DateTime? first, DateTime? last) {
      if (first != null &&
          (firstRecord == null || first.isBefore(firstRecord!))) {
        firstRecord = DateTime(first.year, first.month);
      }
      if (last != null && (lastRecord == null || last.isAfter(lastRecord!))) {
        lastRecord = DateTime(last.year, last.month);
      }
    }

    for (final group in data.lifetime) {
      includeRange(group.competenceMonth_min, group.competenceMonth_max);
    }
    for (final group in data.lifetimePlanned) {
      includeRange(group.competenceMonth_min, group.competenceMonth_max);
    }
    for (final group in data.cardLifetime) {
      includeRange(group.referenceMonth_min, group.referenceMonth_max);
    }
    for (final group in data.loanLifetime) {
      includeRange(
        group.paidAt_min?.toDateTime().toLocal(),
        group.paidAt_max?.toDateTime().toLocal(),
      );
    }
    return cash.CashFlowOverview(
      referenceMonth: DateTime(referenceDate.year, referenceDate.month),
      currentMonth: month,
      currentYear: year,
      lifetime: lifetime,
      yearSeries: series,
      currentMonthPlanned: plannedMonth,
      currentYearPlanned: plannedYear,
      firstRecordMonth: firstRecord,
      lastRecordMonth: lastRecord,
    );
  }

  static int _sumCents(Iterable<BigInt?> values) =>
      values.fold<int>(0, (sum, value) => sum + (value?.toInt() ?? 0));

  static cash.PeriodTotals _periodTotals(
    Iterable<({String direction, int cents})> groups,
  ) {
    var totals = const cash.PeriodTotals.zero();
    for (final group in groups) {
      totals = totals.add(
        _cashFlowDirection(group.direction),
        Money.fromCents(group.cents),
      );
    }
    return totals;
  }

  static domain.LoanContract _mapLoan(
    sql.GetWorkspaceSnapshotLoans loan,
    List<sql.GetWorkspaceSnapshotLoanInstallments> installments,
  ) {
    installments.sort(
      (a, b) => a.installmentNumber.compareTo(b.installmentNumber),
    );
    final paid = installments
        .where((item) => item.status.stringValue == 'PAID')
        .length;
    final totalPaid = installments.fold<int>(
      0,
      (sum, item) => sum + item.paidAmountCents.toInt(),
    );
    final expected =
        loan.expectedInstallmentAmountCents?.toInt() ??
        installments.firstOrNull?.totalAmountCents.toInt() ??
        0;
    return domain.LoanContract(
      id: loan.id,
      lender: loan.lender ?? 'Não informado',
      description: loan.name,
      originalAmount: Money.fromCents(loan.principalAmountCents.toInt()),
      outstandingBalance: Money.fromCents(
        max(0, loan.principalAmountCents.toInt() - totalPaid),
      ),
      installmentAmount: Money.fromCents(expected),
      paidInstallments: paid,
      installmentCount: loan.installmentCount,
      dueDay: loan.firstDueDate.day,
    );
  }

  static domain.InvoiceStatus _invoiceStatus(
    sql.EnumValue<sql.InvoiceStatus> status,
  ) => switch (status.stringValue) {
    'OPEN' => domain.InvoiceStatus.open,
    'CLOSED' => domain.InvoiceStatus.closed,
    'PARTIALLY_PAID' => domain.InvoiceStatus.partiallyPaid,
    'PAID' => domain.InvoiceStatus.paid,
    'OVERDUE' => domain.InvoiceStatus.overdue,
    'CANCELLED' => domain.InvoiceStatus.cancelled,
    _ => domain.InvoiceStatus.open,
  };

  static domain.MembershipRole _membershipRole(
    sql.EnumValue<sql.MembershipRole> role,
  ) => switch (role.stringValue) {
    'OWNER' => domain.MembershipRole.owner,
    'VIEWER' => domain.MembershipRole.viewer,
    _ => domain.MembershipRole.editor,
  };

  static sql.MembershipRole _sqlMembershipRole(domain.MembershipRole role) =>
      switch (role) {
        domain.MembershipRole.owner => sql.MembershipRole.OWNER,
        domain.MembershipRole.editor => sql.MembershipRole.EDITOR,
        domain.MembershipRole.viewer => sql.MembershipRole.VIEWER,
      };

  static domain.MembershipStatus _membershipStatus(
    sql.EnumValue<sql.MembershipStatus> status,
  ) => switch (status.stringValue) {
    'INVITED' => domain.MembershipStatus.invited,
    'SUSPENDED' => domain.MembershipStatus.suspended,
    'REMOVED' => domain.MembershipStatus.removed,
    _ => domain.MembershipStatus.active,
  };

  static planning.FinancialAccountType _financialAccountType(
    sql.EnumValue<sql.FinancialAccountType> type,
  ) => switch (type.stringValue) {
    'CHECKING' => planning.FinancialAccountType.checking,
    'SAVINGS' => planning.FinancialAccountType.savings,
    'CASH' => planning.FinancialAccountType.cash,
    'INVESTMENT' => planning.FinancialAccountType.investment,
    _ => planning.FinancialAccountType.other,
  };

  static sql.FinancialAccountType _sqlFinancialAccountType(
    planning.FinancialAccountType type,
  ) => switch (type) {
    planning.FinancialAccountType.checking => sql.FinancialAccountType.CHECKING,
    planning.FinancialAccountType.savings => sql.FinancialAccountType.SAVINGS,
    planning.FinancialAccountType.cash => sql.FinancialAccountType.CASH,
    planning.FinancialAccountType.investment =>
      sql.FinancialAccountType.INVESTMENT,
    planning.FinancialAccountType.other => sql.FinancialAccountType.OTHER,
  };

  static cash.CashFlowDirection _cashFlowDirection(String value) =>
      value == 'INCOME'
      ? cash.CashFlowDirection.income
      : cash.CashFlowDirection.expense;

  static cash.CashFlowStatus _cashFlowStatus(String value) => switch (value) {
    'PLANNED' => cash.CashFlowStatus.scheduled,
    'CANCELLED' => cash.CashFlowStatus.cancelled,
    _ => cash.CashFlowStatus.confirmed,
  };

  static cash.RecurrenceFrequency _cashRecurrenceFrequency(String value) =>
      switch (value) {
        'WEEKLY' => cash.RecurrenceFrequency.weekly,
        'BIWEEKLY' => cash.RecurrenceFrequency.biweekly,
        'MONTHLY' => cash.RecurrenceFrequency.monthly,
        'ANNUAL' => cash.RecurrenceFrequency.yearly,
        _ => throw StateError('Frequência recorrente desconhecida: $value'),
      };

  static cash.CashFlowKind _cashFlowKind(String value) => switch (value) {
    'SALARY' => cash.CashFlowKind.salary,
    'THIRTEENTH_SALARY' => cash.CashFlowKind.thirteenthSalary,
    'VACATION_PAY' => cash.CashFlowKind.vacationPay,
    'BONUS' => cash.CashFlowKind.bonus,
    'REFUND' => cash.CashFlowKind.refund,
    'BILL' => cash.CashFlowKind.bill,
    'CASH_PURCHASE' => cash.CashFlowKind.cashPurchase,
    'CARD_PURCHASE' => cash.CashFlowKind.cardPurchase,
    'SUBSCRIPTION' => cash.CashFlowKind.subscription,
    'TAX' => cash.CashFlowKind.tax,
    'LOAN_PAYMENT' => cash.CashFlowKind.loanPayment,
    'OTHER_INCOME' => cash.CashFlowKind.otherIncome,
    _ => cash.CashFlowKind.otherExpense,
  };

  static cash.CashFlowPaymentMethod _cashFlowPaymentMethod(String value) =>
      switch (value) {
        'PIX' => cash.CashFlowPaymentMethod.pix,
        'CASH' => cash.CashFlowPaymentMethod.cash,
        'BANK_TRANSFER' => cash.CashFlowPaymentMethod.bankTransfer,
        'DEBIT_CARD' => cash.CashFlowPaymentMethod.debitCard,
        'CREDIT_CARD' => cash.CashFlowPaymentMethod.creditCard,
        _ => cash.CashFlowPaymentMethod.other,
      };

  static sql.CashFlowDirection _sqlCashFlowDirection(
    cash.CashFlowDirection direction,
  ) => direction == cash.CashFlowDirection.income
      ? sql.CashFlowDirection.INCOME
      : sql.CashFlowDirection.EXPENSE;

  static sql.CashFlowStatus _sqlCashFlowStatus(
    cash.CashFlowStatus status,
    cash.CashFlowDirection direction,
  ) => switch (status) {
    cash.CashFlowStatus.scheduled => sql.CashFlowStatus.PLANNED,
    cash.CashFlowStatus.confirmed =>
      direction == cash.CashFlowDirection.income
          ? sql.CashFlowStatus.RECEIVED
          : sql.CashFlowStatus.PAID,
    cash.CashFlowStatus.cancelled => sql.CashFlowStatus.CANCELLED,
  };

  static sql.CashFlowRecurrenceFrequency _sqlRecurrenceFrequency(
    cash.RecurrenceFrequency frequency,
  ) => switch (frequency) {
    cash.RecurrenceFrequency.weekly => sql.CashFlowRecurrenceFrequency.WEEKLY,
    cash.RecurrenceFrequency.biweekly =>
      sql.CashFlowRecurrenceFrequency.BIWEEKLY,
    cash.RecurrenceFrequency.monthly => sql.CashFlowRecurrenceFrequency.MONTHLY,
    cash.RecurrenceFrequency.yearly => sql.CashFlowRecurrenceFrequency.ANNUAL,
    cash.RecurrenceFrequency.none => throw StateError(
      'Uma série precisa possuir frequência.',
    ),
  };

  static schedule.RecurrenceFrequency _scheduleFrequency(
    cash.RecurrenceFrequency frequency,
  ) => switch (frequency) {
    cash.RecurrenceFrequency.weekly => schedule.RecurrenceFrequency.weekly,
    cash.RecurrenceFrequency.biweekly => schedule.RecurrenceFrequency.biweekly,
    cash.RecurrenceFrequency.monthly => schedule.RecurrenceFrequency.monthly,
    cash.RecurrenceFrequency.yearly => schedule.RecurrenceFrequency.yearly,
    cash.RecurrenceFrequency.none => throw StateError(
      'Uma série precisa possuir frequência.',
    ),
  };

  static sql.CashFlowKind _sqlCashFlowKind(cash.CashFlowKind kind) =>
      switch (kind) {
        cash.CashFlowKind.salary => sql.CashFlowKind.SALARY,
        cash.CashFlowKind.thirteenthSalary =>
          sql.CashFlowKind.THIRTEENTH_SALARY,
        cash.CashFlowKind.vacationPay => sql.CashFlowKind.VACATION_PAY,
        cash.CashFlowKind.bonus => sql.CashFlowKind.BONUS,
        cash.CashFlowKind.refund => sql.CashFlowKind.REFUND,
        cash.CashFlowKind.bill => sql.CashFlowKind.BILL,
        cash.CashFlowKind.cashPurchase => sql.CashFlowKind.CASH_PURCHASE,
        cash.CashFlowKind.cardPurchase => sql.CashFlowKind.CARD_PURCHASE,
        cash.CashFlowKind.subscription => sql.CashFlowKind.SUBSCRIPTION,
        cash.CashFlowKind.tax => sql.CashFlowKind.TAX,
        cash.CashFlowKind.loanPayment => sql.CashFlowKind.LOAN_PAYMENT,
        cash.CashFlowKind.otherIncome => sql.CashFlowKind.OTHER_INCOME,
        cash.CashFlowKind.otherExpense => sql.CashFlowKind.OTHER_EXPENSE,
      };

  static sql.CashFlowPaymentMethod _sqlCashFlowPaymentMethod(
    cash.CashFlowPaymentMethod method,
  ) => switch (method) {
    cash.CashFlowPaymentMethod.pix => sql.CashFlowPaymentMethod.PIX,
    cash.CashFlowPaymentMethod.cash => sql.CashFlowPaymentMethod.CASH,
    cash.CashFlowPaymentMethod.bankTransfer =>
      sql.CashFlowPaymentMethod.BANK_TRANSFER,
    cash.CashFlowPaymentMethod.debitCard =>
      sql.CashFlowPaymentMethod.DEBIT_CARD,
    cash.CashFlowPaymentMethod.creditCard =>
      sql.CashFlowPaymentMethod.CREDIT_CARD,
    cash.CashFlowPaymentMethod.other => sql.CashFlowPaymentMethod.OTHER,
  };

  static domain.InstallmentStatus _installmentStatus(
    sql.EnumValue<sql.InstallmentStatus> status,
  ) => switch (status.stringValue) {
    'PLANNED' => domain.InstallmentStatus.planned,
    'PAID' => domain.InstallmentStatus.paid,
    'CANCELLED' => domain.InstallmentStatus.cancelled,
    _ => domain.InstallmentStatus.open,
  };

  static domain.LoanInstallmentStatus _loanInstallmentStatus(
    sql.EnumValue<sql.LoanInstallmentStatus> status,
  ) => switch (status.stringValue) {
    'PLANNED' => domain.LoanInstallmentStatus.planned,
    'PARTIALLY_PAID' => domain.LoanInstallmentStatus.partiallyPaid,
    'PAID' => domain.LoanInstallmentStatus.paid,
    'OVERDUE' => domain.LoanInstallmentStatus.overdue,
    'CANCELLED' => domain.LoanInstallmentStatus.cancelled,
    _ => domain.LoanInstallmentStatus.open,
  };

  static cash.CashFlowStatus _occurrenceStatus({
    required cash.CashFlowStatus requested,
    required DateTime scheduledDate,
  }) {
    if (requested != cash.CashFlowStatus.confirmed) return requested;
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final date = DateTime(
      scheduledDate.year,
      scheduledDate.month,
      scheduledDate.day,
    );
    return date.isAfter(today)
        ? cash.CashFlowStatus.scheduled
        : cash.CashFlowStatus.confirmed;
  }

  static int _defaultRecurrenceHorizon(cash.RecurrenceFrequency frequency) =>
      switch (frequency) {
        cash.RecurrenceFrequency.weekly => 53,
        cash.RecurrenceFrequency.biweekly => 27,
        cash.RecurrenceFrequency.monthly => 24,
        cash.RecurrenceFrequency.yearly => 10,
        cash.RecurrenceFrequency.none => 0,
      };

  static int _recurrenceIndexFor({
    required DateTime startDate,
    required DateTime occurrenceDate,
    required cash.RecurrenceFrequency frequency,
  }) => switch (frequency) {
    cash.RecurrenceFrequency.weekly =>
      _civilDaysBetween(startDate, occurrenceDate) ~/ 7 + 1,
    cash.RecurrenceFrequency.biweekly =>
      _civilDaysBetween(startDate, occurrenceDate) ~/ 14 + 1,
    cash.RecurrenceFrequency.monthly =>
      (occurrenceDate.year - startDate.year) * 12 +
          occurrenceDate.month -
          startDate.month +
          1,
    cash.RecurrenceFrequency.yearly => occurrenceDate.year - startDate.year + 1,
    cash.RecurrenceFrequency.none => throw StateError(
      'Uma série precisa possuir frequência.',
    ),
  };

  static int _civilDaysBetween(DateTime start, DateTime end) => DateTime.utc(
    end.year,
    end.month,
    end.day,
  ).difference(DateTime.utc(start.year, start.month, start.day)).inDays;

  static DateTime _nextRecurrenceDate(
    cash.RecurrenceRule recurrence,
    DateTime current,
  ) => const schedule.RecurrenceScheduleGenerator()
      .generate(
        seriesId: 'next-occurrence',
        startsOn: current,
        frequency: _scheduleFrequency(recurrence.frequency),
        occurrenceCount: 2,
        preferredDay: recurrence.preferredDay,
      )
      .last
      .scheduledDate;

  static DateTime _invoiceDueDate(DateTime reference, int dueDay) =>
      _safeDate(reference.year, reference.month, dueDay);

  static DateTime _safeDate(int year, int month, int day) {
    final firstOfFollowingMonth = DateTime(year, month + 1, 1);
    final lastDay = firstOfFollowingMonth.subtract(const Duration(days: 1)).day;
    return DateTime(year, month, min(day, lastDay));
  }

  static Timestamp _timestamp(DateTime value) => Timestamp(
    0,
    value.toUtc().millisecondsSinceEpoch ~/ Duration.millisecondsPerSecond,
  );

  static String _secureToken() {
    final bytes = List<int>.generate(32, (_) => Random.secure().nextInt(256));
    return base64UrlEncode(bytes).replaceAll('=', '');
  }

  static String _hashToken(String token) =>
      sha256.convert(utf8.encode(token)).toString();

  static String _uuidFromHash(String hash) =>
      '${hash.substring(0, 8)}-${hash.substring(8, 12)}-4${hash.substring(13, 16)}-a${hash.substring(17, 20)}-${hash.substring(20, 32)}';

  static String _extractToken(String input) {
    final value = input.trim();
    final uri = Uri.tryParse(value);
    final queryToken = uri?.queryParameters['invite'];
    if (queryToken != null && queryToken.isNotEmpty) return queryToken;
    if (uri != null && uri.pathSegments.isNotEmpty && uri.hasScheme) {
      return uri.pathSegments.last;
    }
    return value;
  }

  static int _colorValue(String hex) =>
      int.parse('FF${hex.replaceFirst('#', '')}', radix: 16);

  static String _colorHex(int value) =>
      '#${(value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';

  static String? _optionalText(String? value) {
    final normalized = value?.trim();
    return normalized == null || normalized.isEmpty ? null : normalized;
  }

  static String _relativeTime(DateTime value) {
    final difference = DateTime.now().difference(value.toLocal());
    if (difference.inMinutes < 1) return 'Agora';
    if (difference.inHours < 1) return 'Há ${difference.inMinutes} min';
    if (difference.inDays < 1) return 'Há ${difference.inHours} h';
    if (difference.inDays == 1) return 'Ontem';
    return 'Há ${difference.inDays} dias';
  }
}

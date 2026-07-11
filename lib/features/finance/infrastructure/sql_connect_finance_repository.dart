import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_data_connect/firebase_data_connect.dart';

import '../../../core/money/money.dart';
import '../../billing/domain/installment_schedule.dart';
import '../application/finance_repository.dart';
import '../domain/finance_models.dart' as domain;
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
    final currentUid = FirebaseAuth.instance.currentUser?.uid;
    final currentMember = spaceMembers.firstWhere(
      (member) => member.memberFirebaseUid == currentUid,
      orElse: () => spaceMembers.first,
    );
    final rulesByType = {
      for (final rule in data.notificationRules)
        rule.eventType.stringValue: rule,
    };
    final preference = data.notificationPreferences.firstOrNull;

    return WorkspaceSnapshot(
      id: space.id,
      name: space.name,
      colorValue: _colorValue(space.colorHex),
      cards: cards,
      purchases: [
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
      ],
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
    final firstReference = DateTime(
      purchaseDate.year,
      purchaseDate.month + (purchaseDate.day > cardClosingDay ? 1 : 0),
      1,
    );
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
              dueDate: _invoiceDueDate(reference, cardClosingDay, cardDueDay),
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
  }) async {
    if (amount.cents >= pendingBeforePayment.cents) {
      await _client
          .registerFullInvoicePayment(
            spaceId: spaceId,
            invoiceId: invoiceId,
            amountCents: BigInt.from(amount.cents),
            paidAt: _timestamp(paidAt),
            idempotencyKey: _secureToken(),
          )
          .execute();
      return;
    }
    await _client
        .registerInvoicePayment(
          spaceId: spaceId,
          invoiceId: invoiceId,
          amountCents: BigInt.from(amount.cents),
          paidAt: _timestamp(paidAt),
          idempotencyKey: _secureToken(),
          resultingStatus: sql.InvoiceStatus.PARTIALLY_PAID,
        )
        .execute();
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
  }) async {
    await _client
        .registerLoanPayment(
          spaceId: spaceId,
          loanId: loanId,
          loanInstallmentId: installmentId,
          amountCents: BigInt.from(amount.cents),
          paidAt: _timestamp(paidAt),
          idempotencyKey: _secureToken(),
          resultingStatus: amount.cents >= pendingBeforePayment.cents
              ? sql.LoanInstallmentStatus.PAID
              : sql.LoanInstallmentStatus.PARTIALLY_PAID,
        )
        .execute();
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
            dueDate: _invoiceDueDate(referenceMonth, closingDay, dueDay),
          )
          .execute();
      return created.data.invoice.id;
    } catch (_) {
      final raced = await find();
      if (raced != null) return raced;
      rethrow;
    }
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

  static DateTime _invoiceDueDate(
    DateTime reference,
    int closingDay,
    int dueDay,
  ) => _safeDate(
    reference.year,
    reference.month + (dueDay <= closingDay ? 1 : 0),
    dueDay,
  );

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

  static String _relativeTime(DateTime value) {
    final difference = DateTime.now().difference(value.toLocal());
    if (difference.inMinutes < 1) return 'Agora';
    if (difference.inHours < 1) return 'Há ${difference.inMinutes} min';
    if (difference.inDays < 1) return 'Há ${difference.inHours} h';
    if (difference.inDays == 1) return 'Ontem';
    return 'Há ${difference.inDays} dias';
  }
}

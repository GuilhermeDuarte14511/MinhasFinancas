import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/application/finance_controller.dart';
import 'package:nossa_grana/features/finance/application/finance_repository.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';

void main() {
  group('FinanceController correction flows', () {
    test('future income defaults to scheduled', () async {
      final repository = _FakeFinanceRepository();
      final controller = await _loadController(repository);

      await controller.addCashFlowEntry(
        direction: CashFlowDirection.income,
        kind: CashFlowKind.salary,
        paymentMethod: CashFlowPaymentMethod.bankTransfer,
        description: 'Salário futuro',
        amount: Money.fromCents(450000),
        occurredAt: DateTime.now().add(const Duration(days: 10)),
      );

      expect(repository.lastCreatedStatus, CashFlowStatus.scheduled);
      expect(controller.state.cashFlowEntries, hasLength(1));
      expect(
        controller.state.cashFlowEntries.single.status,
        CashFlowStatus.scheduled,
      );
    });

    test('scheduled entry can be confirmed and is reloaded', () async {
      final entry = _entry(
        id: 'scheduled-income',
        direction: CashFlowDirection.income,
        amountCents: 300000,
        date: DateTime.now(),
        status: CashFlowStatus.scheduled,
      );
      final repository = _FakeFinanceRepository(entries: [entry]);
      final controller = await _loadController(repository);

      await controller.updateCashFlowStatus(entry.id, CashFlowStatus.confirmed);

      expect(repository.lastStatusEntryId, entry.id);
      expect(repository.lastStatusDirection, CashFlowDirection.income);
      expect(repository.lastUpdatedStatus, CashFlowStatus.confirmed);
      expect(
        controller.state.cashFlowEntries.single.status,
        CashFlowStatus.confirmed,
      );
      expect(
        controller.state.cashFlowOverview.currentMonth.income.cents,
        300000,
      );
      expect(
        controller.state.cashFlowOverview.currentMonthPlanned.income.cents,
        0,
      );
    });

    test('non-recurring expense is always deleted with single scope', () async {
      final entry = _entry(
        id: 'ordinary-expense',
        direction: CashFlowDirection.expense,
        amountCents: 8500,
        date: DateTime.now(),
      );
      final repository = _FakeFinanceRepository(entries: [entry]);
      final controller = await _loadController(repository);

      await controller.deleteCashFlowEntry(
        entry.id,
        RecurrenceScope.entireSeries,
      );

      expect(repository.lastDeletedEntryId, entry.id);
      expect(repository.lastDeleteScope, RecurrenceScope.single);
      expect(controller.state.cashFlowEntries, isEmpty);
    });

    for (final scope in RecurrenceScope.values) {
      test('recurring deletion forwards ${scope.name} scope', () async {
        final entry = _entry(
          id: 'recurring-${scope.name}',
          direction: CashFlowDirection.expense,
          amountCents: 12000,
          date: DateTime.now(),
          recurrenceSeriesId: 'monthly-bill',
          occurrenceIndex: 2,
        );
        final repository = _FakeFinanceRepository(entries: [entry]);
        final controller = await _loadController(repository);

        await controller.deleteCashFlowEntry(entry.id, scope);

        expect(repository.lastDeletedEntryId, entry.id);
        expect(repository.lastDeleteScope, scope);
      });
    }

    test('deletion reloads immediately and recalculates totals', () async {
      final now = DateTime.now();
      final income = _entry(
        id: 'income',
        direction: CashFlowDirection.income,
        amountCents: 500000,
        date: now,
      );
      final expense = _entry(
        id: 'expense',
        direction: CashFlowDirection.expense,
        amountCents: 125000,
        date: now,
      );
      final repository = _FakeFinanceRepository(entries: [income, expense]);
      final controller = await _loadController(repository);

      expect(
        controller.state.cashFlowOverview.currentMonth.result.cents,
        375000,
      );
      expect(repository.loadWorkspaceCalls, 1);

      await controller.deleteCashFlowEntry(expense.id, RecurrenceScope.single);

      expect(repository.loadWorkspaceCalls, 2);
      expect(controller.state.cashFlowEntries.map((entry) => entry.id), [
        income.id,
      ]);
      expect(controller.state.cashFlowOverview.currentMonth.expense.cents, 0);
      expect(
        controller.state.cashFlowOverview.currentMonth.result.cents,
        500000,
      );
    });

    test('deleteCard cascades and reloads a clean card snapshot', () async {
      final card = _card();
      final purchase = _purchase(card.id);
      final invoice = _invoice(card.id);
      final installment = _installment(purchase.id, invoice.id);
      final repository = _FakeFinanceRepository(
        cards: [card],
        purchases: [purchase],
        invoices: [invoice],
        purchaseInstallments: [installment],
      );
      final controller = await _loadController(repository);

      expect(controller.state.cards, hasLength(1));
      expect(controller.state.purchases, hasLength(1));
      expect(controller.state.invoices, hasLength(1));

      await controller.deleteCard(card.id);

      expect(repository.deletedCardIds, [card.id]);
      expect(repository.loadWorkspaceCalls, 2);
      expect(controller.state.cards, isEmpty);
      expect(controller.state.purchases, isEmpty);
      expect(controller.state.purchaseInstallments, isEmpty);
      expect(controller.state.invoices, isEmpty);
    });
  });
}

Future<FinanceController> _loadController(
  _FakeFinanceRepository repository,
) async {
  final container = ProviderContainer.test(
    overrides: [financeRepositoryProvider.overrideWithValue(repository)],
  );
  addTearDown(container.dispose);
  final controller = container.read(financeControllerProvider.notifier);
  await controller.resolveWorkspace();
  return controller;
}

final class _FakeFinanceRepository implements FinanceRepository {
  _FakeFinanceRepository({
    List<CashFlowEntry> entries = const [],
    List<CreditCardAccount> cards = const [],
    List<PurchaseRecord> purchases = const [],
    List<PurchaseInstallmentRecord> purchaseInstallments = const [],
    List<InvoiceSummary> invoices = const [],
  }) : entries = List.of(entries),
       cards = List.of(cards),
       purchases = List.of(purchases),
       purchaseInstallments = List.of(purchaseInstallments),
       invoices = List.of(invoices);

  final List<CashFlowEntry> entries;
  final List<CreditCardAccount> cards;
  final List<PurchaseRecord> purchases;
  final List<PurchaseInstallmentRecord> purchaseInstallments;
  final List<InvoiceSummary> invoices;

  CashFlowStatus? lastCreatedStatus;
  String? lastStatusEntryId;
  CashFlowDirection? lastStatusDirection;
  CashFlowStatus? lastUpdatedStatus;
  String? lastDeletedEntryId;
  RecurrenceScope? lastDeleteScope;
  final List<String> deletedCardIds = [];
  int loadWorkspaceCalls = 0;

  @override
  Future<List<WorkspaceSummary>> listMySpaces() async => const [
    WorkspaceSummary(
      id: 'space-1',
      name: 'Família Teste',
      colorValue: 0xFF3525CD,
      role: MembershipRole.owner,
    ),
  ];

  @override
  Future<WorkspaceSnapshot> loadWorkspace(String spaceId) async {
    loadWorkspaceCalls++;
    return WorkspaceSnapshot(
      id: spaceId,
      name: 'Família Teste',
      colorValue: 0xFF3525CD,
      cards: List.unmodifiable(cards),
      purchases: List.unmodifiable(purchases),
      cashFlowEntries: List.unmodifiable(entries),
      cashFlowOverview: CashFlowOverview.fromEntries(
        entries: entries,
        referenceDate: DateTime.now(),
      ),
      purchaseInstallments: List.unmodifiable(purchaseInstallments),
      invoices: List.unmodifiable(invoices),
      loans: const [],
      loanInstallments: const [],
      activities: const [],
      categories: const ['Outros'],
      categoryIdsByName: const {'Outros': 'category-other'},
      members: const [
        MemberRecord(
          id: 'member-1',
          name: 'Pessoa Teste',
          email: 'teste@example.com',
          role: MembershipRole.owner,
          status: MembershipStatus.active,
          isCurrentUser: true,
        ),
      ],
      invitations: const [],
      currentRole: MembershipRole.owner,
      notificationSettings: const NotificationSettings(
        enabled: true,
        pushEnabled: false,
        inAppEnabled: true,
        preferredTime: '09:00',
        invoiceClosing: true,
        invoiceDue: true,
        loanDue: true,
        daysBefore: 3,
      ),
    );
  }

  @override
  Future<void> createCashFlowEntry({
    required String spaceId,
    required CashFlowDirection direction,
    required CashFlowKind kind,
    required CashFlowPaymentMethod paymentMethod,
    required String description,
    required Money amount,
    required DateTime occurredAt,
    required CashFlowStatus status,
    RecurrenceRule? recurrence,
    String? categoryId,
    String? accountId,
    String? notes,
  }) async {
    lastCreatedStatus = status;
    entries.add(
      CashFlowEntry(
        id: 'created-${entries.length + 1}',
        direction: direction,
        kind: kind,
        paymentMethod: paymentMethod,
        description: description,
        amount: amount,
        occurredAt: occurredAt,
        competenceMonth: DateTime(occurredAt.year, occurredAt.month),
        status: status,
        createdBy: 'Pessoa Teste',
        categoryId: categoryId,
        categoryName: categoryId == null ? null : 'Outros',
        notes: notes,
        recurrenceSeriesId: recurrence?.isRecurring == true
            ? 'created-series'
            : null,
      ),
    );
  }

  @override
  Future<void> updateCashFlowStatus({
    required String spaceId,
    required String entryId,
    required CashFlowDirection direction,
    required CashFlowStatus status,
  }) async {
    lastStatusEntryId = entryId;
    lastStatusDirection = direction;
    lastUpdatedStatus = status;
    final index = entries.indexWhere((entry) => entry.id == entryId);
    entries[index] = _copyEntry(entries[index], status: status);
  }

  @override
  Future<void> deleteCashFlowEntry({
    required String spaceId,
    required String entryId,
    required String? recurrenceSeriesId,
    required DateTime occurredAt,
    required RecurrenceScope scope,
  }) async {
    lastDeletedEntryId = entryId;
    lastDeleteScope = scope;
    final target = entries.firstWhere((entry) => entry.id == entryId);
    switch (scope) {
      case RecurrenceScope.single:
        entries.removeWhere((entry) => entry.id == entryId);
      case RecurrenceScope.thisAndFuture:
        entries.removeWhere(
          (entry) =>
              entry.recurrenceSeriesId == target.recurrenceSeriesId &&
              (entry.occurrenceIndex ?? -1) >= (target.occurrenceIndex ?? -1),
        );
      case RecurrenceScope.entireSeries:
        entries.removeWhere(
          (entry) => entry.recurrenceSeriesId == target.recurrenceSeriesId,
        );
    }
  }

  @override
  Future<void> deleteCard({
    required String spaceId,
    required String cardId,
  }) async {
    deletedCardIds.add(cardId);
    final purchaseIds = purchases
        .where((purchase) => purchase.cardId == cardId)
        .map((purchase) => purchase.id)
        .toSet();
    purchases.removeWhere((purchase) => purchase.cardId == cardId);
    purchaseInstallments.removeWhere(
      (installment) => purchaseIds.contains(installment.purchaseId),
    );
    invoices.removeWhere((invoice) => invoice.cardId == cardId);
    cards.removeWhere((card) => card.id == cardId);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) {
    throw UnsupportedError(
      'Unexpected repository call: ${invocation.memberName}',
    );
  }
}

CashFlowEntry _entry({
  required String id,
  required CashFlowDirection direction,
  required int amountCents,
  required DateTime date,
  CashFlowStatus status = CashFlowStatus.confirmed,
  String? recurrenceSeriesId,
  int? occurrenceIndex,
}) => CashFlowEntry(
  id: id,
  direction: direction,
  kind: direction == CashFlowDirection.income
      ? CashFlowKind.salary
      : CashFlowKind.bill,
  paymentMethod: CashFlowPaymentMethod.pix,
  description: id,
  amount: Money.fromCents(amountCents),
  occurredAt: date,
  competenceMonth: DateTime(date.year, date.month),
  status: status,
  createdBy: 'Pessoa Teste',
  categoryId: direction == CashFlowDirection.expense ? 'category-other' : null,
  categoryName: direction == CashFlowDirection.expense ? 'Outros' : null,
  recurrenceSeriesId: recurrenceSeriesId,
  occurrenceIndex: occurrenceIndex,
);

CashFlowEntry _copyEntry(
  CashFlowEntry entry, {
  required CashFlowStatus status,
}) => CashFlowEntry(
  id: entry.id,
  direction: entry.direction,
  kind: entry.kind,
  paymentMethod: entry.paymentMethod,
  description: entry.description,
  amount: entry.amount,
  occurredAt: entry.occurredAt,
  competenceMonth: entry.competenceMonth,
  status: status,
  createdBy: entry.createdBy,
  categoryId: entry.categoryId,
  categoryName: entry.categoryName,
  notes: entry.notes,
  sourceType: entry.sourceType,
  sourceEntityId: entry.sourceEntityId,
  recurrenceSeriesId: entry.recurrenceSeriesId,
  occurrenceIndex: entry.occurrenceIndex,
  isRecurrenceException: entry.isRecurrenceException,
  receivedAt: entry.receivedAt,
  paidAt: entry.paidAt,
);

CreditCardAccount _card() => CreditCardAccount(
  id: 'card-1',
  nickname: 'Cartão principal',
  lastFourDigits: '1234',
  cardholder: 'Pessoa Teste',
  limit: Money.fromCents(500000),
  committed: Money.fromCents(120000),
  closingDay: 10,
  dueDay: 17,
  colorValue: 0xFF3525CD,
);

PurchaseRecord _purchase(String cardId) => PurchaseRecord(
  id: 'purchase-1',
  description: 'Compra vinculada',
  category: 'Outros',
  cardId: cardId,
  total: Money.fromCents(120000),
  installmentCount: 1,
  purchaseDate: DateTime.now(),
  createdBy: 'Pessoa Teste',
);

InvoiceSummary _invoice(String cardId) => InvoiceSummary(
  id: 'invoice-1',
  cardId: cardId,
  cardName: 'Cartão principal',
  referenceMonth: DateTime(DateTime.now().year, DateTime.now().month),
  dueDate: DateTime.now().add(const Duration(days: 7)),
  total: Money.fromCents(120000),
  paid: const Money.zero(),
  status: InvoiceStatus.open,
);

PurchaseInstallmentRecord _installment(String purchaseId, String invoiceId) =>
    PurchaseInstallmentRecord(
      id: 'installment-1',
      purchaseId: purchaseId,
      invoiceId: invoiceId,
      number: 1,
      count: 1,
      amount: Money.fromCents(120000),
      dueDate: DateTime.now().add(const Duration(days: 7)),
      status: InstallmentStatus.open,
    );

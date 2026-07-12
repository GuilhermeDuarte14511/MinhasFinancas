import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/application/finance_controller.dart';
import 'package:nossa_grana/features/finance/application/finance_repository.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/presentation/add_cash_flow_entry_page.dart';
import 'package:nossa_grana/features/finance/presentation/agenda_page.dart';
import 'package:nossa_grana/features/finance/presentation/card_detail_page.dart';
import 'package:nossa_grana/features/finance/presentation/cash_flow_entry_detail_page.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  Future<ProviderContainer> configuredContainer({
    List<CashFlowEntry> entries = const [],
    List<CreditCardAccount> cards = const [],
  }) async {
    final container = ProviderContainer(
      overrides: [
        financeRepositoryProvider.overrideWithValue(
          _PresentationRepository(entries: entries, cards: cards),
        ),
      ],
    );
    await container.read(financeControllerProvider.notifier).resolveWorkspace();
    return container;
  }

  Widget app(ProviderContainer container, Widget home) =>
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          locale: const Locale('pt', 'BR'),
          supportedLocales: const [Locale('pt', 'BR')],
          localizationsDelegates: GlobalMaterialLocalizations.delegates,
          home: home,
        ),
      );

  Future<void> disposeTest(
    WidgetTester tester,
    ProviderContainer container,
  ) async {
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  }

  testWidgets('income date picker allows dates far in the future', (
    tester,
  ) async {
    final container = await configuredContainer();
    await tester.pumpWidget(
      app(
        container,
        const AddCashFlowEntryPage(initialDirection: CashFlowDirection.income),
      ),
    );
    await tester.pumpAndSettle();

    final dateField = find.byKey(const Key('cash-flow-date-field'));
    await tester.ensureVisible(dateField);
    await tester.pumpAndSettle();
    await tester.tap(dateField);
    await tester.pumpAndSettle();

    final picker = tester.widget<CalendarDatePicker>(
      find.byType(CalendarDatePicker),
    );
    expect(picker.firstDate, DateTime(2000));
    expect(picker.lastDate, DateTime(9999, 12, 31));
    await disposeTest(tester, container);
  });

  testWidgets('income form exposes status and monthly recurrence options', (
    tester,
  ) async {
    final container = await configuredContainer();
    await tester.pumpWidget(
      app(
        container,
        const AddCashFlowEntryPage(initialDirection: CashFlowDirection.income),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Status da entrada'), findsOneWidget);
    expect(find.text('Sem recorrência'), findsOneWidget);
    final recurrenceField = find.byKey(const Key('cash-flow-recurrence-field'));
    await tester.ensureVisible(recurrenceField);
    await tester.pumpAndSettle();
    await tester.tap(recurrenceField);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Mensal').last);
    await tester.pumpAndSettle();

    expect(find.text('Como a entrada deve se repetir?'), findsOneWidget);
    expect(find.text('Dia preferencial'), findsOneWidget);
    expect(find.textContaining('último dia válido'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await disposeTest(tester, container);
  });

  testWidgets('agenda identifies type, status and recurrence deletion scope', (
    tester,
  ) async {
    final now = DateTime.now();
    final entry = _scheduledSalary(now, recurrenceSeriesId: 'series-1');
    final container = await configuredContainer(entries: [entry]);
    await tester.pumpWidget(app(container, const Scaffold(body: AgendaPage())));
    await tester.pumpAndSettle();

    expect(find.text('Salário de agosto'), findsOneWidget);
    expect(find.text('Salário'), findsOneWidget);
    expect(find.text('Prevista'), findsOneWidget);

    await tester.tap(find.byTooltip('Ações do lançamento'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Excluir lançamento'));
    await tester.pumpAndSettle();

    expect(
      find.text('Qual parte da recorrência deseja excluir?'),
      findsOneWidget,
    );
    expect(find.text('Somente este lançamento'), findsOneWidget);
    expect(find.text('Este e os próximos'), findsOneWidget);
    expect(find.text('Toda a série'), findsOneWidget);
    await disposeTest(tester, container);
  });

  testWidgets('card deletion explains every cascading consequence', (
    tester,
  ) async {
    final card = CreditCardAccount(
      id: 'card-1',
      nickname: 'Cartão da família',
      lastFourDigits: '1234',
      cardholder: 'Guilherme',
      limit: Money.fromCents(500000),
      committed: const Money.zero(),
      closingDay: 15,
      dueDay: 25,
      colorValue: 0xFF3525CD,
    );
    final container = await configuredContainer(cards: [card]);
    await tester.pumpWidget(
      app(container, const CardDetailPage(cardId: 'card-1')),
    );
    await tester.pumpAndSettle();

    final deleteButton = find.text('Excluir cartão e histórico');
    await tester.ensureVisible(deleteButton);
    await tester.pumpAndSettle();
    await tester.tap(deleteButton);
    await tester.pumpAndSettle();

    expect(find.text('Excluir cartão permanentemente?'), findsOneWidget);
    expect(
      find.textContaining('Todas as faturas, compras e parcelas'),
      findsOneWidget,
    );
    expect(find.text('Excluir tudo'), findsOneWidget);
    await disposeTest(tester, container);
  });

  testWidgets('cash flow detail offers confirmation, edit and delete', (
    tester,
  ) async {
    final now = DateTime.now();
    final entry = _scheduledSalary(now);
    final container = await configuredContainer(entries: [entry]);
    await tester.pumpWidget(
      app(container, const CashFlowEntryDetailPage(entryId: 'income-1')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Prevista'), findsOneWidget);
    expect(find.text('Confirmar recebimento'), findsOneWidget);
    expect(find.text('Editar lançamento'), findsOneWidget);
    expect(find.text('Excluir lançamento'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await disposeTest(tester, container);
  });
}

CashFlowEntry _scheduledSalary(DateTime date, {String? recurrenceSeriesId}) =>
    CashFlowEntry(
      id: 'income-1',
      direction: CashFlowDirection.income,
      kind: CashFlowKind.salary,
      paymentMethod: CashFlowPaymentMethod.bankTransfer,
      description: 'Salário de agosto',
      amount: Money.fromCents(500000),
      occurredAt: DateTime(date.year, date.month, 30),
      competenceMonth: DateTime(date.year, date.month),
      status: CashFlowStatus.scheduled,
      createdBy: 'Guilherme',
      recurrenceSeriesId: recurrenceSeriesId,
      occurrenceIndex: recurrenceSeriesId == null ? null : 1,
    );

final class _PresentationRepository implements FinanceRepository {
  const _PresentationRepository({required this.entries, required this.cards});

  final List<CashFlowEntry> entries;
  final List<CreditCardAccount> cards;

  @override
  Future<List<WorkspaceSummary>> listMySpaces() async => const [
    WorkspaceSummary(
      id: 'space-1',
      name: 'Finanças da Família',
      colorValue: 0xFF3525CD,
      role: MembershipRole.owner,
    ),
  ];

  @override
  Future<WorkspaceSnapshot> loadWorkspace(String spaceId) async =>
      WorkspaceSnapshot(
        id: spaceId,
        name: 'Finanças da Família',
        colorValue: 0xFF3525CD,
        cards: cards,
        purchases: const [],
        cashFlowEntries: entries,
        cashFlowOverview: CashFlowOverview.fromEntries(
          entries: entries,
          referenceDate: DateTime.now(),
        ),
        purchaseInstallments: const [],
        invoices: const [],
        loans: const [],
        loanInstallments: const [],
        activities: const [],
        categories: const ['Outros'],
        categoryIdsByName: const {'Outros': 'category-other'},
        members: const [],
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

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

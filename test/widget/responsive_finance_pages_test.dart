import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/dashboard/presentation/app_shell.dart';
import 'package:nossa_grana/features/dashboard/presentation/analytics_page.dart';
import 'package:nossa_grana/features/dashboard/presentation/dashboard_page.dart';
import 'package:nossa_grana/features/finance/application/finance_controller.dart';
import 'package:nossa_grana/features/finance/application/finance_repository.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/domain/financial_planning.dart';
import 'package:nossa_grana/features/finance/presentation/accounts_page.dart';
import 'package:nossa_grana/features/finance/presentation/add_card_page.dart';
import 'package:nossa_grana/features/finance/presentation/add_cash_flow_entry_page.dart';
import 'package:nossa_grana/features/finance/presentation/agenda_page.dart';
import 'package:nossa_grana/features/finance/presentation/cards_page.dart';
import 'package:nossa_grana/features/finance/presentation/budgets_page.dart';
import 'package:nossa_grana/features/finance/presentation/cash_flow_forecast_page.dart';
import 'package:nossa_grana/features/finance/presentation/members_page.dart';

void main() {
  setUpAll(() => initializeDateFormatting('pt_BR'));

  Future<ProviderContainer> configuredContainer() async {
    final container = ProviderContainer(
      overrides: [
        financeRepositoryProvider.overrideWithValue(
          _ResponsiveFinanceRepository(),
        ),
      ],
    );
    await container.read(financeControllerProvider.notifier).resolveWorkspace();
    return container;
  }

  void useCompactViewport(WidgetTester tester) {
    tester.view
      ..physicalSize = const Size(320, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
  }

  testWidgets('members remain readable at 320 px', (tester) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: MembersPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Guilherme Duarte de Oliveira'), findsOneWidget);
    expect(find.text('guilherme.duarte@example.com'), findsOneWidget);
    expect(find.text('Proprietário'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('empty cards page uses compact CTA without overflow', (
    tester,
  ) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: CardsPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Adicionar cartão'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('card limit is formatted as BRL on a compact form', (
    tester,
  ) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AddCardPage()),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextFormField).at(2), '232131231231212');
    await tester.pump();

    expect(find.text('2.321.312.312.312,12'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('general finance dashboard fits a 320 px viewport', (
    tester,
  ) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: DashboardPage())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seu mês em uma visão'), findsOneWidget);
    expect(find.textContaining('RESULTADO PREVISTO DE'), findsOneWidget);
    final resultValue = find.byKey(const Key('monthly-result-value'));
    expect(resultValue, findsOneWidget);
    expect(
      tester.widget<Text>(resultValue).data,
      Money.fromCents(350000).format(),
    );
    expect(find.text(Money.fromCents(450000).format()), findsOneWidget);
    expect(find.text('Entradas do mês'), findsOneWidget);
    expect(find.text('Saídas do mês'), findsOneWidget);
    expect(find.text('Próximos compromissos'), findsOneWidget);
    expect(find.text('Ver análises e relatórios'), findsOneWidget);
    expect(find.text('Movimentações recentes'), findsOneWidget);
    expect(find.text('Atividades do espaço'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('home remains usable at 320 px with text enlarged to 200%', (
    tester,
  ) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
          home: const Scaffold(body: DashboardPage()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seu mês em uma visão'), findsOneWidget);
    expect(find.text('Movimentações recentes'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('analytics page remains readable at 320 px', (tester) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AnalyticsPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Seu fluxo em perspectiva'), findsOneWidget);
    expect(find.text('Filtrar'), findsOneWidget);
    expect(
      tester.getSize(find.text('Seu fluxo em perspectiva')).width,
      greaterThan(120),
    );
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('accounts and budgets remain readable at 320 px', (tester) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AccountsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Saldo atual'), findsOneWidget);
    expect(find.text('Conta conjunta'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: BudgetsPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Limites por categoria'), findsOneWidget);
    expect(find.text('Mercado'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('forecast and agenda projection remain readable at 320 px', (
    tester,
  ) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: CashFlowForecastPage()),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Previsão de caixa'), findsOneWidget);
    expect(find.text('30 dias'), findsOneWidget);
    expect(find.text('Linha do tempo financeira'), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: AgendaPage())),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Saldo no fim do mês'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('cash flow form fits a 320 px viewport', (tester) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(
          home: AddCashFlowEntryPage(
            initialDirection: CashFlowDirection.expense,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Dinheiro que saiu'), findsOneWidget);
    expect(find.text('Registrar saída'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });

  testWidgets('workspace picker scrolls on a compact viewport', (tester) async {
    useCompactViewport(tester);
    final container = await configuredContainer();

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: AppShell(section: 'home')),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Finanças da Família').first);
    await tester.pumpAndSettle();

    expect(find.text('Espaço financeiro'), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsWidgets);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    container.dispose();
  });
}

final class _ResponsiveFinanceRepository implements FinanceRepository {
  @override
  Future<List<WorkspaceSummary>> listMySpaces() async => const [
    WorkspaceSummary(
      id: 'space-1',
      name: 'Finanças da Família',
      colorValue: 0xFF3525CD,
      role: MembershipRole.owner,
    ),
    WorkspaceSummary(
      id: 'space-2',
      name: 'Casa e despesas compartilhadas',
      colorValue: 0xFF19766E,
      role: MembershipRole.editor,
    ),
    WorkspaceSummary(
      id: 'space-3',
      name: 'Planejamento de longo prazo',
      colorValue: 0xFF9F1844,
      role: MembershipRole.editor,
    ),
    WorkspaceSummary(
      id: 'space-4',
      name: 'Viagem em família',
      colorValue: 0xFF4D6770,
      role: MembershipRole.viewer,
    ),
    WorkspaceSummary(
      id: 'space-5',
      name: 'Reforma do apartamento',
      colorValue: 0xFF3D2DB8,
      role: MembershipRole.editor,
    ),
  ];

  @override
  Future<WorkspaceSnapshot> loadWorkspace(String spaceId) async =>
      WorkspaceSnapshot(
        id: spaceId,
        name: 'Finanças da Família',
        colorValue: 0xFF3525CD,
        cards: const [],
        purchases: const [],
        cashFlowEntries: [
          CashFlowEntry(
            id: 'cash-flow-1',
            direction: CashFlowDirection.income,
            kind: CashFlowKind.salary,
            paymentMethod: CashFlowPaymentMethod.pix,
            description: 'Salário do mês',
            amount: Money.fromCents(350000),
            occurredAt: DateTime(2026, 7, 5),
            competenceMonth: DateTime(2026, 7),
            status: CashFlowStatus.confirmed,
            createdBy: 'Guilherme',
            accountId: 'account-1',
          ),
        ],
        cashFlowOverview: CashFlowOverview.empty(DateTime(2026, 7)),
        purchaseInstallments: const [],
        invoices: const [],
        loans: const [],
        loanInstallments: const [],
        activities: const [
          ActivityEntry(
            person: 'Guilherme',
            description: 'registrou uma entrada',
            whenLabel: 'Hoje, 09:30',
          ),
        ],
        categories: const ['Outros'],
        categoryIdsByName: const {'Outros': 'category-other'},
        members: const [
          MemberRecord(
            id: 'member-1',
            name: 'Guilherme Duarte de Oliveira',
            email: 'guilherme.duarte@example.com',
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
        accounts: [
          FinancialAccount(
            id: 'account-1',
            name: 'Conta conjunta',
            institutionName: 'Nossa conta',
            type: FinancialAccountType.checking,
            openingBalance: Money.fromCents(100000),
            openingBalanceAt: DateTime(2026, 7, 1),
            colorValue: 0xFF3525CD,
            includeInTotal: true,
          ),
        ],
        monthlyBudgets: [
          MonthlyBudget(
            id: 'budget-1',
            categoryId: 'category-market',
            categoryName: 'Mercado',
            referenceMonth: DateTime(DateTime.now().year, DateTime.now().month),
            limit: Money.fromCents(80000),
          ),
        ],
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

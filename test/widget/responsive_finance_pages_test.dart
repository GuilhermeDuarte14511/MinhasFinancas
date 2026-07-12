import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:nossa_grana/features/dashboard/presentation/app_shell.dart';
import 'package:nossa_grana/features/dashboard/presentation/dashboard_page.dart';
import 'package:nossa_grana/features/finance/application/finance_controller.dart';
import 'package:nossa_grana/features/finance/application/finance_repository.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/presentation/add_card_page.dart';
import 'package:nossa_grana/features/finance/presentation/add_cash_flow_entry_page.dart';
import 'package:nossa_grana/features/finance/presentation/cards_page.dart';
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

    expect(find.textContaining('Resultado de'), findsOneWidget);
    expect(find.text('Fluxo em 2026'), findsOneWidget);
    expect(find.text('Desde o primeiro registro'), findsOneWidget);
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
        cashFlowEntries: const [],
        cashFlowOverview: CashFlowOverview.empty(DateTime(2026, 7)),
        purchaseInstallments: const [],
        invoices: const [],
        loans: const [],
        loanInstallments: const [],
        activities: const [],
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
      );

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

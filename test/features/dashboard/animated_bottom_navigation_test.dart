import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/features/dashboard/presentation/animated_bottom_navigation.dart';

void main() {
  const destinations = <AppBottomNavigationDestination>[
    AppBottomNavigationDestination(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Início',
    ),
    AppBottomNavigationDestination(
      icon: Icons.credit_card_outlined,
      selectedIcon: Icons.credit_card_rounded,
      label: 'Cartões',
    ),
    AppBottomNavigationDestination(
      icon: Icons.add_circle_outline_rounded,
      selectedIcon: Icons.add_circle_rounded,
      label: 'Novo',
    ),
    AppBottomNavigationDestination(
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      label: 'Agenda',
    ),
    AppBottomNavigationDestination(
      icon: Icons.more_horiz_rounded,
      selectedIcon: Icons.more_horiz_rounded,
      label: 'Mais',
    ),
  ];

  testWidgets('shows icon-above-label destinations and handles taps', (
    tester,
  ) async {
    var selectedIndex = 0;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          bottomNavigationBar: AnimatedBottomNavigationBar(
            selectedIndex: selectedIndex,
            destinations: destinations,
            onDestinationSelected: (index) => selectedIndex = index,
          ),
        ),
      ),
    );

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Cartões'), findsOneWidget);
    expect(find.text('Novo'), findsOneWidget);
    expect(find.text('Agenda'), findsOneWidget);
    expect(find.text('Mais'), findsOneWidget);

    await tester.tap(find.text('Agenda'));
    await tester.pump();

    expect(selectedIndex, 3);
    expect(tester.takeException(), isNull);
  });

  testWidgets('remains usable with enlarged text on a narrow phone', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(320, 800)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: const TextScaler.linear(2)),
          child: child!,
        ),
        home: Scaffold(
          bottomNavigationBar: AnimatedBottomNavigationBar(
            selectedIndex: 0,
            destinations: destinations,
            onDestinationSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Início'), findsOneWidget);
    expect(find.text('Mais'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

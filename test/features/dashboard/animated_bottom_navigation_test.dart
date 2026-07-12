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
      icon: Icons.calendar_today_outlined,
      selectedIcon: Icons.calendar_month_rounded,
      label: 'Agenda',
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
    expect(find.text('Agenda'), findsOneWidget);

    await tester.tap(find.text('Agenda'));
    await tester.pump();

    expect(selectedIndex, 2);
  });
}

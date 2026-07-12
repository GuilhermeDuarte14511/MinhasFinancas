import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/app/navigation/workspace_history_navigation.dart';
import 'package:nossa_grana/app/widgets/app_widgets.dart';

void main() {
  testWidgets('opens commitments from the upcoming section heading', (
    tester,
  ) async {
    registerWorkspaceHistoryPageBuilder(
      (destination) => Scaffold(body: Text(destination.name)),
    );

    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SectionHeading(title: 'Próximos compromissos'),
        ),
      ),
    );

    expect(find.text('Ver mais'), findsOneWidget);

    await tester.tap(find.text('Ver mais'));
    await tester.pumpAndSettle();

    expect(find.text('commitments'), findsOneWidget);
  });
}

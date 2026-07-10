import 'package:flutter/material.dart' show Key, MaterialApp;
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nossa_grana/features/auth/presentation/login_page.dart';

void main() {
  testWidgets('login validates required credentials', (tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: MaterialApp(home: LoginPage())),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nossa Grana'), findsOneWidget);
    await tester.tap(find.byKey(const Key('login-submit')));
    await tester.pump();

    expect(find.text('Informe um e-mail válido.'), findsOneWidget);
    expect(
      find.text('A senha deve ter pelo menos 6 caracteres.'),
      findsOneWidget,
    );
  });
}

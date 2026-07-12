import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/navigation/workspace_history_navigation.dart';
import 'app/nossa_grana_app.dart';
import 'features/finance/application/finance_controller.dart';
import 'features/finance/infrastructure/sql_connect_finance_repository.dart';
import 'features/finance/presentation/workspace_history_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await initializeDateFormatting('pt_BR');

  registerWorkspaceHistoryPageBuilder(
    (destination) => WorkspaceHistoryPage(
      initialSection: destination,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [
        financeRepositoryProvider.overrideWithValue(
          const SqlConnectFinanceRepository(),
        ),
      ],
      child: const NossaGranaApp(),
    ),
  );
}

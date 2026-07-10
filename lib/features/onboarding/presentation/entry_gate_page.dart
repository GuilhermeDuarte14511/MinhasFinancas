import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../auth/infrastructure/firebase_auth_service.dart';
import '../../finance/application/finance_controller.dart';

class EntryGatePage extends ConsumerStatefulWidget {
  const EntryGatePage({super.key});

  @override
  ConsumerState<EntryGatePage> createState() => _EntryGatePageState();
}

class _EntryGatePageState extends ConsumerState<EntryGatePage> {
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _resolve());
  }

  Future<void> _resolve() async {
    setState(() => _error = null);
    final user = ref.read(firebaseAuthServiceProvider).currentUser;
    if (user != null) {
      ref
          .read(financeControllerProvider.notifier)
          .updateProfile(
            name: user.displayName ?? user.email?.split('@').first ?? 'Você',
            email: user.email ?? '',
          );
    }
    try {
      final hasSpace = await ref
          .read(financeControllerProvider.notifier)
          .resolveWorkspace();
      if (!mounted) return;
      context.go(hasSpace ? '/app/home' : '/welcome');
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = ref.read(financeControllerProvider).errorMessage,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedPageEntry(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const BrandMark(size: 72),
              const SizedBox(height: 22),
              if (_error == null) ...[
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 14),
                const Text('Sincronizando seus espaços...'),
              ] else ...[
                const Icon(Icons.cloud_off_outlined, color: AppColors.error),
                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Text(_error!, textAlign: TextAlign.center),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _resolve,
                  child: const Text('Tentar novamente'),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';

class OfflinePage extends ConsumerStatefulWidget {
  const OfflinePage({this.onRetry, super.key});

  final Future<bool> Function()? onRetry;

  @override
  ConsumerState<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends ConsumerState<OfflinePage> {
  bool _retrying = false;
  String? _error;

  Future<void> _retry() async {
    setState(() {
      _retrying = true;
      _error = null;
    });
    try {
      final callback = widget.onRetry;
      if (callback != null) {
        if (!await callback()) {
          throw StateError('Ainda sem conexão.');
        }
      } else {
        await ref.read(financeControllerProvider.notifier).refresh();
      }
      if (mounted && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    } catch (_) {
      if (mounted) {
        setState(
          () => _error = 'Ainda não foi possível conectar. Tente novamente.',
        );
      }
    } finally {
      if (mounted) setState(() => _retrying = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Sem conexão', showBack: true),
      body: SafeArea(
        child: AppContent(
          maxWidth: 560,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: Container(
                    width: 112,
                    height: 112,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(36),
                    ),
                    child: const Icon(
                      Icons.cloud_off_rounded,
                      size: 58,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  'Você está sem conexão',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Confira sua internet para sincronizar as informações do espaço financeiro.',
                  textAlign: TextAlign.center,
                ),
                if (_error != null) ...[
                  const SizedBox(height: 18),
                  Text(
                    _error!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.error),
                  ),
                ],
                const SizedBox(height: 28),
                FilledButton.icon(
                  onPressed: _retrying ? null : _retry,
                  icon: const Icon(Icons.refresh_rounded),
                  label: Text(
                    _retrying ? 'Reconectando...' : 'Tentar novamente',
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Nenhuma alteração será enviada enquanto a conexão não voltar.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

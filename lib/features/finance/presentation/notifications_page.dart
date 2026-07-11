import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage({super.key});

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  bool _invoiceClosing = true;
  bool _invoiceDue = true;
  bool _loanDue = true;
  double _daysBefore = 3;
  bool _initialized = false;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(financeControllerProvider).notificationsEnabled;
    final saved = ref.watch(financeControllerProvider).notificationSettings;
    if (!_initialized) {
      _invoiceClosing = saved.invoiceClosing;
      _invoiceDue = saved.invoiceDue;
      _loanDue = saved.loanDue;
      _daysBefore = saved.daysBefore.toDouble();
      _initialized = true;
    }
    return Scaffold(
      appBar: const BrandAppBar(title: 'Lembretes', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Fique em dia sem esforço',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                const Text('Escolha os avisos que fazem sentido para você.'),
                const SizedBox(height: 24),
                Card(
                  color: enabled ? AppColors.surfaceLow : null,
                  child: SwitchListTile(
                    minTileHeight: 76,
                    secondary: const CircleAvatar(
                      backgroundColor: AppColors.primaryContainer,
                      child: Icon(
                        Icons.notifications_active_rounded,
                        color: Colors.white,
                      ),
                    ),
                    title: const Text('Lembretes ativos'),
                    subtitle: const Text('Avisos internos neste dispositivo'),
                    value: enabled,
                    onChanged: (value) async {
                      try {
                        var next = ref
                            .read(financeControllerProvider)
                            .notificationSettings
                            .copyWith(enabled: value);
                        if (value) {
                          final permission = await FirebaseMessaging.instance
                              .requestPermission(
                                alert: true,
                                badge: true,
                                sound: true,
                              );
                          next = next.copyWith(
                            pushEnabled:
                                permission.authorizationStatus ==
                                    AuthorizationStatus.authorized ||
                                permission.authorizationStatus ==
                                    AuthorizationStatus.provisional,
                          );
                          if (next.pushEnabled) {
                            try {
                              final token = await FirebaseMessaging.instance
                                  .getToken();
                              if (token != null) {
                                await ref
                                    .read(financeControllerProvider.notifier)
                                    .registerNotificationDevice(
                                      token: token,
                                      isWeb: kIsWeb,
                                      deviceName: kIsWeb
                                          ? 'Navegador Web'
                                          : 'Dispositivo Android',
                                    );
                              }
                            } catch (_) {
                              next = next.copyWith(pushEnabled: false);
                            }
                          }
                        }
                        await ref
                            .read(financeControllerProvider.notifier)
                            .updateNotificationSettings(next);
                      } catch (_) {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                ref
                                        .read(financeControllerProvider)
                                        .errorMessage ??
                                    'Não foi possível salvar os lembretes.',
                              ),
                            ),
                          );
                        }
                      }
                    },
                  ),
                ),
                const SizedBox(height: 22),
                Text(
                  'Avisar sobre',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Card(
                  child: Column(
                    children: [
                      SwitchListTile(
                        title: const Text('Fechamento de fatura'),
                        subtitle: const Text('Antes do cartão fechar'),
                        value: _invoiceClosing && enabled,
                        onChanged: enabled
                            ? (value) => setState(() => _invoiceClosing = value)
                            : null,
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Vencimento de fatura'),
                        subtitle: const Text('Para evitar juros e atrasos'),
                        value: _invoiceDue && enabled,
                        onChanged: enabled
                            ? (value) => setState(() => _invoiceDue = value)
                            : null,
                      ),
                      const Divider(height: 1),
                      SwitchListTile(
                        title: const Text('Parcela de empréstimo'),
                        subtitle: const Text('Aviso de próxima parcela'),
                        value: _loanDue && enabled,
                        onChanged: enabled
                            ? (value) => setState(() => _loanDue = value)
                            : null,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 22),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Antecedência: ${_daysBefore.round()} dias',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Slider(
                          value: _daysBefore,
                          min: 0,
                          max: 7,
                          divisions: 7,
                          label: '${_daysBefore.round()} dias',
                          onChanged: enabled
                              ? (value) => setState(() => _daysBefore = value)
                              : null,
                        ),
                        const Text(
                          'Horário preferido: 09:00 • America/Sao_Paulo',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: enabled && !_saving
                      ? () async {
                          setState(() => _saving = true);
                          try {
                            await ref
                                .read(financeControllerProvider.notifier)
                                .updateNotificationSettings(
                                  saved.copyWith(
                                    invoiceClosing: _invoiceClosing,
                                    invoiceDue: _invoiceDue,
                                    loanDue: _loanDue,
                                    daysBefore: _daysBefore.round(),
                                  ),
                                );
                            if (context.mounted) {
                              showSuccessMessage(
                                context,
                                'Preferências de lembrete salvas.',
                              );
                            }
                          } catch (_) {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Não foi possível salvar as preferências.',
                                  ),
                                ),
                              );
                            }
                          } finally {
                            if (mounted) setState(() => _saving = false);
                          }
                        }
                      : null,
                  child: Text(_saving ? 'Salvando...' : 'Salvar preferências'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Notificações push serão ativadas quando o Firebase Cloud Messaging estiver configurado. Lembretes internos continuam disponíveis.',
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

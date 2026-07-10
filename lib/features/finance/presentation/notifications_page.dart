import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

  @override
  Widget build(BuildContext context) {
    final enabled = ref.watch(financeControllerProvider).notificationsEnabled;
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
                        await ref
                            .read(financeControllerProvider.notifier)
                            .setNotificationsEnabled(value);
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
                  onPressed: enabled
                      ? () => showSuccessMessage(
                          context,
                          'Preferências de lembrete salvas.',
                        )
                      : null,
                  child: const Text('Salvar preferências'),
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

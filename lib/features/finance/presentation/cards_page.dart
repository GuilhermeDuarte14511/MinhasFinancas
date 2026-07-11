import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class CardsPage extends ConsumerWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meus cartões',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text('Visão unificada dos limites compartilhados.'),
              const SizedBox(height: 26),
              Container(
                padding: const EdgeInsets.fromLTRB(26, 26, 26, 28),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: const Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x120F172A),
                      blurRadius: 14,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LIMITE TOTAL DO CASAL'),
                    const SizedBox(height: 8),
                    FittedBox(
                      child: Text(
                        finance.totalLimit.format(),
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'DISPONÍVEL PARA USO',
                      style: TextStyle(color: AppColors.secondary),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      finance.availableLimit.format(),
                      style: const TextStyle(
                        fontSize: 27,
                        color: AppColors.secondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              if (finance.cards.isEmpty)
                const _CardsEmptyState()
              else
                for (final card in finance.cards) ...[
                  _CreditCardPanel(card: card),
                  const SizedBox(height: 20),
                ],
              OutlinedButton.icon(
                onPressed: finance.currentRole == MembershipRole.viewer
                    ? null
                    : () => context.push('/new-card'),
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar cartão compartilhado'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CreditCardPanel extends ConsumerWidget {
  const _CreditCardPanel({required this.card});

  final CreditCardAccount card;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final matchingInvoices = finance.invoices.where(
      (invoice) => invoice.cardId == card.id,
    );
    final invoice = matchingInvoices.isEmpty ? null : matchingInvoices.first;
    final usage = card.limit.isZero
        ? 0.0
        : card.committed.cents / card.limit.cents;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/card/${card.id}'),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Color(card.colorValue),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          card.nickname,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                          ),
                        ),
                      ),
                      const StatusPill(
                        label: 'Aberta',
                        color: Color(0xFF99EFE5),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '••••  ${card.lastFourDigits}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    card.cardholder,
                    style: const TextStyle(color: Color(0xFFDAD7FF)),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: _CardMetric(
                          label: 'Fatura atual',
                          value: invoice?.total.format() ?? 'Sem fatura',
                        ),
                      ),
                      Expanded(
                        child: _CardMetric(
                          label: 'Limite disponível',
                          value: card.available.format(),
                          color: AppColors.secondary,
                          alignEnd: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Uso do limite (${(usage * 100).round()}%)',
                        ),
                      ),
                      Text('Total: ${card.limit.format()}'),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(99),
                    child: LinearProgressIndicator(
                      value: usage.clamp(0, 1),
                      minHeight: 9,
                      color: Color(card.colorValue),
                      backgroundColor: AppColors.surfaceContainer,
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Divider(),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 18),
                      const SizedBox(width: 8),
                      Text('Fechamento: ${card.closingDay}'),
                      const Spacer(),
                      const Icon(
                        Icons.event_busy_outlined,
                        size: 18,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Vencimento: ${card.dueDay}',
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton.icon(
                      onPressed: () => context.push('/card/${card.id}'),
                      icon: const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Ver detalhes'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardsEmptyState extends StatelessWidget {
  const _CardsEmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(
                Icons.credit_card_off_rounded,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Nenhum cartão por aqui',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 6),
            const Text(
              'Adicione o primeiro cartão para acompanhar limites, faturas e compras.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _CardMetric extends StatelessWidget {
  const _CardMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text,
    this.alignEnd = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 23,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

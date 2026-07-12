import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
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
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Meus cartões',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 4),
              const Text('Visão unificada dos limites compartilhados.'),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.fromLTRB(22, 22, 22, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: const Border(
                    left: BorderSide(color: AppColors.primary, width: 4),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('LIMITES COMPARTILHADOS'),
                    const SizedBox(height: 16),
                    _LimitSummary(
                      total: finance.totalLimit,
                      available: finance.availableLimit,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              if (finance.cards.isEmpty)
                const _CardsEmptyState()
              else
                for (final card in finance.cards) ...[
                  _CreditCardPanel(card: card),
                  const SizedBox(height: 20),
                ],
              const SizedBox(height: 20),
              LayoutBuilder(
                builder: (context, constraints) => FilledButton.icon(
                  onPressed: finance.currentRole == MembershipRole.viewer
                      ? null
                      : () => context.push('/new-card'),
                  icon: const Icon(Icons.add_rounded),
                  label: Text(
                    constraints.maxWidth < 340
                        ? 'Adicionar cartão'
                        : 'Adicionar cartão compartilhado',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              const SizedBox(height: 8),
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
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 6,
                    spacing: 16,
                    children: [
                      Text('Uso do limite (${(usage * 100).round()}%)'),
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
                  Wrap(
                    spacing: 18,
                    runSpacing: 12,
                    alignment: WrapAlignment.spaceBetween,
                    children: [
                      _CardDateLabel(
                        icon: Icons.calendar_today_outlined,
                        label: 'Fechamento: ${card.closingDay}',
                      ),
                      _CardDateLabel(
                        icon: Icons.event_busy_outlined,
                        label: 'Vencimento: ${card.dueDay}',
                        color: AppColors.error,
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
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          const CircleAvatar(
            radius: 24,
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
          const SizedBox(height: 8),
          const Text(
            'Adicione o primeiro cartão para acompanhar limites, faturas e compras.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _CardDateLabel extends StatelessWidget {
  const _CardDateLabel({
    required this.icon,
    required this.label,
    this.color = AppColors.text,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18, color: color),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: color)),
      ],
    );
  }
}

class _LimitSummary extends StatelessWidget {
  const _LimitSummary({required this.total, required this.available});

  final Money total;
  final Money available;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 280) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _LimitMetric(label: 'Total', value: total),
              const SizedBox(height: 16),
              const Divider(height: 1),
              const SizedBox(height: 16),
              _LimitMetric(
                label: 'Disponível',
                value: available,
                color: AppColors.secondary,
              ),
            ],
          );
        }
        return Row(
          children: [
            Expanded(
              child: _LimitMetric(label: 'Total', value: total),
            ),
            Container(
              width: 1,
              height: 56,
              color: AppColors.outline.withValues(alpha: .55),
            ),
            Expanded(
              child: _LimitMetric(
                label: 'Disponível',
                value: available,
                color: AppColors.secondary,
                alignEnd: true,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LimitMetric extends StatelessWidget {
  const _LimitMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text,
    this.alignEnd = false,
  });

  final String label;
  final Money value;
  final Color color;
  final bool alignEnd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: alignEnd ? 14 : 0,
        right: alignEnd ? 0 : 14,
      ),
      child: Column(
        crossAxisAlignment: alignEnd
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 5),
          FittedBox(
            child: AnimatedMoneyText(
              value: value,
              style: TextStyle(
                fontSize: 23,
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
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

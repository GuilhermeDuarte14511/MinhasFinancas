import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/domain/finance_models.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          maxWidth: 760,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _InvoiceOverview(finance: finance),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: _LimitTile(
                      label: 'Limite disponível',
                      value: finance.availableLimit,
                      emphasized: true,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _LimitTile(
                      label: 'Limite total',
                      value: finance.totalLimit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              SectionHeading(
                title: 'Nossos cartões',
                actionLabel: 'Ver todos',
                onAction: () => context.go('/app/cards'),
              ),
              const SizedBox(height: 12),
              if (finance.cards.isEmpty)
                Card(
                  color: AppColors.surfaceLow,
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.add_card_rounded,
                          size: 38,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Comece cadastrando o primeiro cartão do espaço.',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        FilledButton(
                          onPressed: () => context.push('/new-card'),
                          child: const Text('Adicionar cartão'),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SizedBox(
                  height: 182,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: finance.cards.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 14),
                    itemBuilder: (context, index) =>
                        _MiniCard(card: finance.cards[index]),
                  ),
                ),
              const SizedBox(height: 30),
              const SectionHeading(title: 'Próximos vencimentos'),
              const SizedBox(height: 12),
              Card(
                child: Column(
                  children: [
                    if (finance.invoices.isEmpty && finance.loans.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(22),
                        child: Text('Nenhum vencimento programado.'),
                      ),
                    for (
                      var index = 0;
                      index < finance.invoices.length;
                      index++
                    )
                      _DueRow(
                        invoice: finance.invoices[index],
                        showDivider: index < finance.invoices.length - 1,
                      ),
                    if (finance.loans.isNotEmpty)
                      _LoanDueRow(loan: finance.loans.first),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              const SectionHeading(title: 'Atividades recentes'),
              const SizedBox(height: 12),
              if (finance.activities.isEmpty)
                const Card(
                  child: Padding(
                    padding: EdgeInsets.all(22),
                    child: Text('As ações dos membros aparecerão aqui.'),
                  ),
                ),
              for (final activity in finance.activities.take(4)) ...[
                _ActivityTile(activity: activity),
                const SizedBox(height: 12),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _InvoiceOverview extends StatelessWidget {
  const _InvoiceOverview({required this.finance});

  final FinanceState finance;

  @override
  Widget build(BuildContext context) {
    final referenceMonths = finance.invoices
        .map((invoice) => invoice.referenceMonth)
        .toSet();
    final invoiceTitle = referenceMonths.length == 1
        ? 'Faturas de ${toBeginningOfSentenceCase(DateFormat.MMMM('pt_BR').format(referenceMonths.first))}'
        : 'Resumo das faturas';
    final fraction = finance.invoiceTotal.isZero
        ? 0.0
        : finance.paidTotal.cents / finance.invoiceTotal.cents;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    invoiceTitle,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLow,
                    borderRadius: BorderRadius.circular(99),
                  ),
                  child: const Text(
                    'Atualizado agora',
                    style: TextStyle(color: AppColors.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              'TOTAL EM FATURAS',
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(letterSpacing: 1.1),
            ),
            const SizedBox(height: 4),
            Text(
              finance.invoiceTotal.format(),
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pago: ${finance.paidTotal.format()}',
                  style: const TextStyle(color: AppColors.secondary),
                ),
                Flexible(
                  child: Text('Pendente: ${finance.pendingTotal.format()}'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: fraction.clamp(0, 1),
                minHeight: 14,
                color: AppColors.secondary,
                backgroundColor: AppColors.secondaryContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LimitTile extends StatelessWidget {
  const _LimitTile({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final Money value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: emphasized ? AppColors.primaryContainer : AppColors.surfaceLow,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: emphasized ? AppColors.primaryContainer : AppColors.outline,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x100F172A),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: emphasized ? const Color(0xFFDAD7FF) : AppColors.textMuted,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              value.format(),
              style: TextStyle(
                color: emphasized ? Colors.white : AppColors.text,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.card});

  final CreditCardAccount card;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(card.colorValue),
            Color(card.colorValue).withBlue(190),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
          BoxShadow(
            color: Color(0x220F172A),
            blurRadius: 12,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  card.nickname.toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const Icon(Icons.contactless_rounded, color: Colors.white),
            ],
          ),
          const Spacer(),
          Text(
            card.cardholder,
            style: const TextStyle(color: Color(0xFFDAD7FF)),
          ),
          const SizedBox(height: 7),
          Row(
            children: [
              Text(
                '••••  ${card.lastFourDigits}',
                style: const TextStyle(color: Colors.white, fontSize: 19),
              ),
              const Spacer(),
              const Icon(Icons.credit_card_rounded, color: Colors.white),
            ],
          ),
        ],
      ),
    );
  }
}

class _DueRow extends StatelessWidget {
  const _DueRow({required this.invoice, required this.showDivider});

  final InvoiceSummary invoice;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () => context.push('/invoice/${invoice.id}'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFE2DFFF),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(invoice.cardName),
                      Text(
                        'Vence em ${DateFormat("d 'de' MMM", 'pt_BR').format(invoice.dueDate)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  invoice.pending.format(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _LoanDueRow extends StatelessWidget {
  const _LoanDueRow({required this.loan});

  final LoanContract loan;

  @override
  Widget build(BuildContext context) {
    final dueDate = _nextDateForDay(loan.dueDay);
    return Column(
      children: [
        const Divider(height: 1),
        InkWell(
          onTap: () => context.push('/loans'),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: AppColors.surfaceContainer,
                  child: Icon(Icons.account_balance_rounded),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Empréstimo'),
                      Text(
                        'Vence em ${DateFormat("d 'de' MMM", 'pt_BR').format(dueDate)}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Text(
                  loan.installmentAmount.format(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

DateTime _nextDateForDay(int day) {
  final now = DateTime.now();
  DateTime inMonth(int year, int month) {
    final lastDay = DateUtils.getDaysInMonth(year, month);
    return DateTime(year, month, day.clamp(1, lastDay));
  }

  final current = inMonth(now.year, now.month);
  if (!current.isBefore(DateTime(now.year, now.month, now.day))) return current;
  final nextMonth = DateTime(now.year, now.month + 1);
  return inMonth(nextMonth.year, nextMonth.month);
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityEntry activity;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.surfaceContainer,
          child: Text(activity.person.characters.first),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Card(
            color: AppColors.surfaceLow,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '${activity.person} ',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        TextSpan(text: activity.description),
                      ],
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    activity.whenLabel,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

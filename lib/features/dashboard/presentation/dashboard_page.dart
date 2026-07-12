import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/domain/cash_flow.dart';
import '../../finance/domain/finance_models.dart';
import '../../finance/presentation/cash_flow_labels.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final overview = finance.cashFlowOverview;
    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          maxWidth: 760,
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AnimatedPageEntry(child: _MonthlyResultPanel(overview: overview)),
              const SizedBox(height: 16),
              AnimatedPageEntry(
                delay: const Duration(milliseconds: 80),
                child: _QuickActions(enabled: finance.canEdit),
              ),
              const SizedBox(height: 36),
              _AnnualFlowSection(overview: overview),
              const SizedBox(height: 36),
              _LifetimeSection(overview: overview),
              if (finance.cashFlowEntries.isNotEmpty) ...[
                const SizedBox(height: 36),
                const SectionHeading(title: 'Movimentações recentes'),
                const SizedBox(height: 8),
                _RecentCashFlowList(entries: finance.cashFlowEntries.take(5)),
              ],
              const SizedBox(height: 36),
              _UpcomingSection(finance: finance),
              const SizedBox(height: 36),
              _CardsSection(finance: finance),
              if (finance.activities.isNotEmpty) ...[
                const SizedBox(height: 36),
                const SectionHeading(title: 'Atividades do espaço'),
                const SizedBox(height: 12),
                for (final activity in finance.activities.take(3)) ...[
                  _ActivityTile(activity: activity),
                  const SizedBox(height: 12),
                ],
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyResultPanel extends StatelessWidget {
  const _MonthlyResultPanel({required this.overview});

  final CashFlowOverview overview;

  @override
  Widget build(BuildContext context) {
    final realized = overview.currentMonth;
    final planned = overview.currentMonthPlanned;
    final projected = overview.projectedMonth;
    final projectedResult = projected.result;
    final monthName = toBeginningOfSentenceCase(
      DateFormat.MMMM('pt_BR').format(overview.referenceMonth),
    );
    final statusLabel = projectedResult.isNegative
        ? 'Projeção de falta'
        : projectedResult.isZero
        ? 'Projeção equilibrada'
        : 'Projeção de sobra';
    final highlightedValue = projectedResult.isNegative
        ? projected.shortfall
        : projectedResult;
    return Semantics(
      container: true,
      excludeSemantics: true,
      label:
          'Resultado de $monthName. Realizado: entradas ${realized.income.format()}, saídas ${realized.expense.format()} e saldo ${realized.result.format()}. Ainda previsto: entradas ${planned.income.format()} e saídas ${planned.expense.format()}. $statusLabel ${highlightedValue.format()}.',
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 22, 20, 20),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    'Resultado de $monthName',
                    style: Theme.of(
                      context,
                    ).textTheme.titleLarge?.copyWith(color: Colors.white),
                  ),
                ),
                const Icon(Icons.insights_rounded, color: Color(0xFFDAD7FF)),
              ],
            ),
            const SizedBox(height: 18),
            Text(
              statusLabel.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFFDAD7FF),
                fontSize: 12,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 5),
            FittedBox(
              alignment: Alignment.centerLeft,
              child: AnimatedMoneyText(
                value: highlightedValue,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontSize: 38,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 7),
            Text(
              'Saldo realizado até agora: ${realized.result.format()}',
              style: const TextStyle(
                color: Color(0xFFDAD7FF),
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Divider(color: Colors.white.withValues(alpha: .22)),
            ),
            _PanelMetricGroup(
              label: 'Realizado',
              totals: realized,
              incomeColor: const Color(0xFF99EFE5),
              expenseColor: Colors.white,
            ),
            const SizedBox(height: 20),
            _PanelMetricGroup(
              label: 'Ainda previsto',
              totals: planned,
              incomeColor: const Color(0xFFC2FFF7),
              expenseColor: const Color(0xFFDAD7FF),
            ),
          ],
        ),
      ),
    );
  }
}

class _PanelMetricGroup extends StatelessWidget {
  const _PanelMetricGroup({
    required this.label,
    required this.totals,
    required this.incomeColor,
    required this.expenseColor,
  });

  final String label;
  final PeriodTotals totals;
  final Color incomeColor;
  final Color expenseColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            color: Color(0xFFDAD7FF),
            fontSize: 11,
            fontWeight: FontWeight.w600,
            letterSpacing: .9,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _PanelMetric(
                label: 'Entradas',
                value: totals.income,
                icon: Icons.south_west_rounded,
                color: incomeColor,
              ),
            ),
            Container(
              width: 1,
              height: 48,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              color: Colors.white.withValues(alpha: .22),
            ),
            Expanded(
              child: _PanelMetric(
                label: 'Saídas',
                value: totals.expense,
                icon: Icons.north_east_rounded,
                color: expenseColor,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _PanelMetric extends StatelessWidget {
  const _PanelMetric({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final Money value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: color),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        FittedBox(
          alignment: Alignment.centerLeft,
          child: AnimatedMoneyText(
            value: value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.enabled});

  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.secondary,
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: enabled ? () => context.push('/new-income') : null,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Entrada'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: enabled ? () => context.push('/new-expense') : null,
            icon: const Icon(Icons.remove_rounded),
            label: const Text('Saída'),
          ),
        ),
      ],
    );
  }
}

class _AnnualFlowSection extends StatelessWidget {
  const _AnnualFlowSection({required this.overview});

  final CashFlowOverview overview;

  @override
  Widget build(BuildContext context) {
    final year = overview.referenceMonth.year;
    final totals = overview.currentYear;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(title: 'Fluxo em $year'),
        const SizedBox(height: 4),
        const Text(
          'Entradas, despesas, faturas e pagamentos de empréstimo reconhecidos em cada mês.',
        ),
        const SizedBox(height: 18),
        _AnnualFlowChart(series: overview.yearSeries),
        const SizedBox(height: 18),
        _PeriodSummary(totals: totals, resultLabel: 'Resultado no ano'),
      ],
    );
  }
}

class _AnnualFlowChart extends StatelessWidget {
  const _AnnualFlowChart({required this.series});

  final List<MonthlyCashFlow> series;

  @override
  Widget build(BuildContext context) {
    final hasValues = series.any(
      (item) => !item.totals.income.isZero || !item.totals.expense.isZero,
    );
    if (!hasValues) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.surfaceLow,
          borderRadius: BorderRadius.circular(18),
        ),
        child: const Row(
          children: [
            Icon(Icons.bar_chart_rounded, color: AppColors.primary),
            SizedBox(width: 14),
            Expanded(
              child: Text(
                'O gráfico será preenchido com suas movimentações e compromissos financeiros.',
              ),
            ),
          ],
        ),
      );
    }
    final disableAnimations = MediaQuery.disableAnimationsOf(context);
    final accessibleValues = series
        .where(
          (item) => !item.totals.income.isZero || !item.totals.expense.isZero,
        )
        .map(
          (item) =>
              '${DateFormat.MMM('pt_BR').format(item.month)}: entradas ${item.totals.income.format()}, saídas ${item.totals.expense.format()}',
        )
        .join('; ');
    return Semantics(
      image: true,
      excludeSemantics: true,
      label:
          'Gráfico de entradas e saídas de ${series.first.month.year}. $accessibleValues',
      child: Column(
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _FlowLegend(color: AppColors.secondary, label: 'Entradas'),
              SizedBox(width: 16),
              _FlowLegend(color: AppColors.primary, label: 'Saídas'),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 190,
            child: TweenAnimationBuilder<double>(
              tween: Tween(end: 1),
              duration: disableAnimations
                  ? Duration.zero
                  : const Duration(milliseconds: 720),
              curve: Curves.easeOutCubic,
              builder: (context, progress, _) => CustomPaint(
                size: Size.infinite,
                painter: _AnnualFlowPainter(
                  series: series,
                  progress: progress,
                  textDirection: Directionality.of(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FlowLegend extends StatelessWidget {
  const _FlowLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

class _AnnualFlowPainter extends CustomPainter {
  const _AnnualFlowPainter({
    required this.series,
    required this.progress,
    required this.textDirection,
  });

  final List<MonthlyCashFlow> series;
  final double progress;
  final TextDirection textDirection;

  @override
  void paint(Canvas canvas, Size size) {
    const labelHeight = 24.0;
    const topPadding = 8.0;
    final chartHeight = size.height - labelHeight - topPadding;
    final maxCents = series.fold<int>(
      1,
      (current, item) => math.max(
        current,
        math.max(item.totals.income.cents, item.totals.expense.cents),
      ),
    );
    final gridPaint = Paint()
      ..color = AppColors.outline.withValues(alpha: .35)
      ..strokeWidth = 1;
    for (var line = 0; line <= 2; line++) {
      final y = topPadding + chartHeight * line / 2;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }
    final groupWidth = size.width / series.length;
    final barWidth = math.max(4.0, math.min(10.0, groupWidth * .28));
    final incomePaint = Paint()..color = AppColors.secondary;
    final expensePaint = Paint()..color = AppColors.primary;
    for (var index = 0; index < series.length; index++) {
      final item = series[index];
      final center = groupWidth * (index + .5);
      _drawBar(
        canvas,
        center - barWidth - 1.5,
        barWidth,
        chartHeight,
        item.totals.income.cents / maxCents,
        incomePaint,
        topPadding,
      );
      _drawBar(
        canvas,
        center + 1.5,
        barWidth,
        chartHeight,
        item.totals.expense.cents / maxCents,
        expensePaint,
        topPadding,
      );
      final label = DateFormat.MMM(
        'pt_BR',
      ).format(item.month).replaceAll('.', '');
      final painter = TextPainter(
        text: TextSpan(
          text: label,
          style: const TextStyle(color: AppColors.textMuted, fontSize: 9),
        ),
        textDirection: textDirection,
      )..layout(maxWidth: groupWidth);
      painter.paint(
        canvas,
        Offset(center - painter.width / 2, size.height - painter.height),
      );
    }
  }

  void _drawBar(
    Canvas canvas,
    double x,
    double width,
    double chartHeight,
    double fraction,
    Paint paint,
    double topPadding,
  ) {
    final height = chartHeight * fraction.clamp(0, 1) * progress;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x, topPadding + chartHeight - height, width, height),
      const Radius.circular(4),
    );
    canvas.drawRRect(rect, paint);
  }

  @override
  bool shouldRepaint(covariant _AnnualFlowPainter oldDelegate) =>
      oldDelegate.progress != progress || oldDelegate.series != series;
}

class _PeriodSummary extends StatelessWidget {
  const _PeriodSummary({required this.totals, required this.resultLabel});

  final PeriodTotals totals;
  final String resultLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryMetric(
                label: 'Total que entrou',
                value: totals.income,
                color: AppColors.secondary,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: _SummaryMetric(
                label: 'Total que saiu',
                value: totals.expense,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Divider(height: 1),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: Text(
                resultLabel,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Flexible(
              child: FittedBox(
                alignment: Alignment.centerRight,
                child: AnimatedMoneyText(
                  value: totals.result,
                  style: TextStyle(
                    color: totals.result.isNegative
                        ? AppColors.error
                        : AppColors.secondary,
                    fontSize: 21,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    this.color = AppColors.text,
  });

  final String label;
  final Money value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 6),
        FittedBox(
          alignment: Alignment.centerLeft,
          child: AnimatedMoneyText(
            value: value,
            style: TextStyle(
              color: color,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _LifetimeSection extends StatelessWidget {
  const _LifetimeSection({required this.overview});

  final CashFlowOverview overview;

  @override
  Widget build(BuildContext context) {
    final first = overview.firstRecordMonth;
    final last = overview.lastRecordMonth;
    final range = first == null || last == null
        ? 'Todos os registros aparecerão aqui.'
        : first.year == last.year
        ? 'Registros de ${first.year}'
        : 'De ${first.year} até ${last.year}';
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 22),
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.outline),
          bottom: BorderSide(color: AppColors.outline),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Desde o primeiro registro',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 4),
          Text(range),
          const SizedBox(height: 20),
          _PeriodSummary(
            totals: overview.lifetime,
            resultLabel: 'Resultado acumulado',
          ),
        ],
      ),
    );
  }
}

class _RecentCashFlowList extends StatelessWidget {
  const _RecentCashFlowList({required this.entries});

  final Iterable<CashFlowEntry> entries;

  @override
  Widget build(BuildContext context) {
    final items = entries.toList();
    return Column(
      children: [
        for (var index = 0; index < items.length; index++) ...[
          _CashFlowRow(entry: items[index]),
          if (index < items.length - 1) const Divider(height: 1),
        ],
      ],
    );
  }
}

class _CashFlowRow extends StatelessWidget {
  const _CashFlowRow({required this.entry});

  final CashFlowEntry entry;

  @override
  Widget build(BuildContext context) {
    final income = entry.direction == CashFlowDirection.income;
    final cancelled = entry.status == CashFlowStatus.cancelled;
    final color = cancelled
        ? AppColors.textMuted
        : income
        ? AppColors.secondary
        : AppColors.error;
    final statusLabel = switch (entry.status) {
      CashFlowStatus.scheduled => 'Prevista',
      CashFlowStatus.confirmed => income ? 'Recebida' : 'Paga',
      CashFlowStatus.cancelled => 'Cancelada',
    };
    final statusColor = entry.status == CashFlowStatus.scheduled
        ? AppColors.primary
        : color;
    final effectiveDate = entry.status == CashFlowStatus.scheduled
        ? entry.occurredAt
        : income
        ? entry.receivedAt ?? entry.occurredAt
        : entry.paidAt ?? entry.occurredAt;
    final formattedDate = DateFormat(
      "d 'de' MMM",
      'pt_BR',
    ).format(effectiveDate);
    final directionLabel = income ? 'Entrada' : 'Saída';
    final signedValue = '${income ? '+' : '−'} ${entry.amount.format()}';
    return Semantics(
      container: true,
      excludeSemantics: true,
      label:
          '${entry.description}. $directionLabel de ${entry.amount.format()}. $statusLabel em $formattedDate. ${cashFlowKindLabel(entry.kind)}.',
      child: InkWell(
        onTap: () => context.push('/cash-flow/${entry.id}'),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: color.withValues(alpha: .1),
                child: Icon(
                  cashFlowKindIcon(entry.kind),
                  size: 21,
                  color: color,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            entry.description,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              decoration: cancelled
                                  ? TextDecoration.lineThrough
                                  : null,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          flex: 2,
                          child: FittedBox(
                            alignment: Alignment.centerRight,
                            fit: BoxFit.scaleDown,
                            child: Text(
                              signedValue,
                              style: TextStyle(
                                color: color,
                                fontWeight: FontWeight.w700,
                                decoration: cancelled
                                    ? TextDecoration.lineThrough
                                    : null,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: statusLabel,
                            style: TextStyle(
                              color: statusColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          TextSpan(
                            text:
                                ' • ${cashFlowKindLabel(entry.kind)} • $formattedDate',
                          ),
                        ],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _UpcomingSection extends StatelessWidget {
  const _UpcomingSection({required this.finance});

  final FinanceState finance;

  @override
  Widget build(BuildContext context) {
    final invoices =
        finance.invoices.where((invoice) => invoice.pending.cents > 0).toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final loansById = {for (final loan in finance.loans) loan.id: loan};
    final loanInstallments =
        finance.loanInstallments
            .where(
              (installment) =>
                  installment.pending.cents > 0 &&
                  installment.status != LoanInstallmentStatus.cancelled &&
                  loansById.containsKey(installment.loanId),
            )
            .toList()
          ..sort((a, b) => a.dueDate.compareTo(b.dueDate));
    final nextLoanInstallment = loanInstallments.firstOrNull;
    final nextLoan = nextLoanInstallment == null
        ? null
        : loansById[nextLoanInstallment.loanId];
    final hasItems = invoices.isNotEmpty || nextLoan != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SectionHeading(title: 'Próximos compromissos'),
        const SizedBox(height: 4),
        const Text('Faturas e empréstimos que ainda precisam de atenção.'),
        const SizedBox(height: 12),
        if (!hasItems)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: const BoxDecoration(
              border: Border(
                top: BorderSide(color: AppColors.outline),
                bottom: BorderSide(color: AppColors.outline),
              ),
            ),
            child: const Text('Nenhum compromisso programado.'),
          )
        else
          Column(
            children: [
              for (var index = 0; index < invoices.take(3).length; index++) ...[
                _DueRow(invoice: invoices[index]),
                const Divider(height: 1),
              ],
              if (nextLoan != null && nextLoanInstallment != null)
                _LoanDueRow(loan: nextLoan, installment: nextLoanInstallment),
            ],
          ),
      ],
    );
  }
}

class _DueRow extends StatelessWidget {
  const _DueRow({required this.invoice});

  final InvoiceSummary invoice;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/invoice/${invoice.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            const CircleAvatar(
              backgroundColor: Color(0xFFE2DFFF),
              child: Icon(Icons.receipt_long_rounded, color: AppColors.primary),
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
            const SizedBox(width: 10),
            Flexible(
              child: FittedBox(
                child: Text(
                  invoice.pending.format(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanDueRow extends StatelessWidget {
  const _LoanDueRow({required this.loan, required this.installment});

  final LoanContract loan;
  final LoanInstallmentRecord installment;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/loans/${loan.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
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
                  Text(loan.description),
                  Text(
                    'Vence em ${DateFormat("d 'de' MMM", 'pt_BR').format(installment.dueDate)}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Flexible(
              child: FittedBox(
                child: Text(
                  installment.pending.format(),
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CardsSection extends StatelessWidget {
  const _CardsSection({required this.finance});

  final FinanceState finance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SectionHeading(
          title: 'Cartões',
          actionLabel: finance.cards.isEmpty ? null : 'Ver todos',
          onAction: () => context.go('/app/cards'),
        ),
        const SizedBox(height: 4),
        const Text('Limites e compras no crédito ficam organizados aqui.'),
        const SizedBox(height: 16),
        if (finance.cards.isEmpty)
          InkWell(
            onTap: finance.canEdit ? () => context.push('/new-card') : null,
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.outline),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: AppColors.surfaceContainer,
                    child: Icon(
                      Icons.add_card_rounded,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 14),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nenhum cartão cadastrado',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 3),
                        Text('Adicione um cartão quando precisar.'),
                      ],
                    ),
                  ),
                  if (finance.canEdit) const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          )
        else ...[
          Row(
            children: [
              Expanded(
                child: _SummaryMetric(
                  label: 'Limite disponível',
                  value: finance.availableLimit,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _SummaryMetric(
                  label: 'Faturas do mês',
                  value: finance.invoiceTotal,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 174,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: finance.cards.length,
              separatorBuilder: (_, _) => const SizedBox(width: 14),
              itemBuilder: (context, index) =>
                  _MiniCard(card: finance.cards[index]),
            ),
          ),
        ],
      ],
    );
  }
}

class _MiniCard extends StatelessWidget {
  const _MiniCard({required this.card});

  final CreditCardAccount card;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push('/card/${card.id}'),
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        width: 276,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Color(card.colorValue),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    card.nickname.toUpperCase(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
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
      ),
    );
  }
}

class _ActivityTile extends StatelessWidget {
  const _ActivityTile({required this.activity});

  final ActivityEntry activity;

  @override
  Widget build(BuildContext context) {
    final initial = activity.person.trim().isEmpty
        ? '?'
        : activity.person.characters.first;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundColor: AppColors.surfaceContainer,
          child: Text(initial),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceLow,
              borderRadius: BorderRadius.circular(16),
            ),
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
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/domain/cash_flow.dart';
import '../../finance/domain/cash_flow_forecast.dart';
import '../../finance/domain/finance_models.dart';
import '../../finance/presentation/cash_flow_labels.dart';

class DashboardPage extends ConsumerWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final month = DateTime(now.year, now.month);
    final monthEnd = DateTime(now.year, now.month + 1, 0);
    final forecast = finance.cashFlowForecast(
      referenceDate: today,
      horizonDays: monthEnd.difference(today).inDays,
    );
    final position = finance.financialPosition(today);
    final budgets = finance.budgetProgress(month);
    final budgetLimit = _sumMoney(budgets.map((item) => item.budget.limit));
    final budgetCommitted = _sumMoney(budgets.map((item) => item.committed));
    final monthName = toBeginningOfSentenceCase(
      DateFormat.MMMM('pt_BR').format(month),
    );

    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          maxWidth: 760,
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.md,
            AppSpacing.xl,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MonthHeader(monthName: monthName, year: month.year),
              const SizedBox(height: AppSpacing.md),
              AnimatedPageEntry(
                duration: AppMotion.emphasized,
                child: _MonthlyPositionHero(
                  monthName: monthName,
                  monthEnd: monthEnd,
                  hasAccounts: finance.accounts.isNotEmpty,
                  currentBalance: position.currentBalance,
                  forecast: forecast,
                ),
              ),
              if (finance.accounts.isEmpty ||
                  forecast.hasNegativeBalanceRisk ||
                  forecast.overdueCount > 0) ...[
                const SizedBox(height: AppSpacing.sm),
                _DashboardAlert(
                  hasAccounts: finance.accounts.isNotEmpty,
                  forecast: forecast,
                ),
              ],
              const SizedBox(height: AppSpacing.lg),
              SectionHeading(
                title: 'Próximos compromissos',
                actionLabel: 'Ver agenda',
                onAction: () => context.go('/app/agenda'),
              ),
              const SizedBox(height: AppSpacing.xs),
              _UpcomingCommitments(lines: forecast.lines.take(3).toList()),
              if (budgets.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                _BudgetOverview(limit: budgetLimit, committed: budgetCommitted),
              ],
              if (finance.cashFlowEntries.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const SectionHeading(title: 'Movimentações recentes'),
                const SizedBox(height: AppSpacing.xs),
                AppSurfaceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.md,
                  ),
                  child: _RecentCashFlowList(
                    entries: finance.cashFlowEntries.take(4),
                  ),
                ),
              ],
              if (finance.activities.isNotEmpty) ...[
                const SizedBox(height: AppSpacing.lg),
                const SectionHeading(title: 'Atividades do espaço'),
                const SizedBox(height: AppSpacing.xs),
                for (final activity in finance.activities.take(2)) ...[
                  _ActivityTile(activity: activity),
                  const SizedBox(height: AppSpacing.xs),
                ],
              ],
              const SizedBox(height: AppSpacing.md),
              OutlinedButton.icon(
                onPressed: () => context.push('/analytics'),
                icon: const Icon(Icons.query_stats_rounded),
                label: const Text('Ver análises e relatórios'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthlyPositionHero extends StatelessWidget {
  const _MonthlyPositionHero({
    required this.monthName,
    required this.monthEnd,
    required this.hasAccounts,
    required this.currentBalance,
    required this.forecast,
  });

  final String monthName;
  final DateTime monthEnd;
  final bool hasAccounts;
  final Money currentBalance;
  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context) {
    final risk = forecast.hasNegativeBalanceRisk;
    return Semantics(
      container: true,
      label:
          'Previsão de $monthName. Saldo no fim do mês ${forecast.closingBalance.format()}. Ainda entra ${forecast.expectedIncome.format()} e ainda sai ${forecast.expectedExpenses.format()}.',
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.heroDark, AppColors.primaryContainer],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppRadius.hero),
          boxShadow: const [
            BoxShadow(
              color: Color(0x243525CD),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                Text(
                  'PREVISÃO PARA ${DateFormat('dd/MM', 'pt_BR').format(monthEnd)}',
                  style: const TextStyle(
                    color: AppColors.onPrimaryContainer,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: .8,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        risk
                            ? Icons.warning_amber_rounded
                            : Icons.check_circle_outline_rounded,
                        color: risk
                            ? AppColors.errorContainer
                            : AppColors.secondaryContainer,
                        size: 15,
                      ),
                      const SizedBox(width: AppSpacing.xxs),
                      Flexible(
                        child: Text(
                          risk ? 'Atenção' : 'No controle',
                          maxLines: 2,
                          style: TextStyle(
                            color: risk
                                ? AppColors.errorContainer
                                : AppColors.secondaryContainer,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.xs),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                forecast.closingBalance.format(),
                style: TextStyle(
                  color: risk ? AppColors.errorContainer : Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w700,
                  fontFeatures: const [FontFeature.tabularFigures()],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: _HeroMetric(
                    label: hasAccounts ? 'Saldo hoje' : 'Saldo inicial',
                    value: currentBalance,
                    icon: Icons.account_balance_wallet_outlined,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _HeroMetric(
                    label: 'Ainda entra',
                    value: forecast.expectedIncome,
                    icon: Icons.south_west_rounded,
                    color: AppColors.secondaryContainer,
                  ),
                ),
                const SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: _HeroMetric(
                    label: 'Ainda sai',
                    value: forecast.expectedExpenses,
                    icon: Icons.north_east_rounded,
                    color: AppColors.errorContainer,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Container(height: 1, color: Colors.white.withValues(alpha: .18)),
            const SizedBox(height: AppSpacing.xs),
            InkWell(
              onTap: () => context.push('/forecast'),
              borderRadius: BorderRadius.circular(AppRadius.control),
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xs),
                child: Row(
                  children: [
                    Icon(
                      Icons.timeline_rounded,
                      size: 18,
                      color: AppColors.onPrimaryContainer,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Expanded(
                      child: Text(
                        'Ver previsão detalhada de caixa',
                        style: TextStyle(
                          color: AppColors.onPrimaryContainer,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.onPrimaryContainer,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.onPrimaryContainer,
  });

  final String label;
  final Money value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(AppSpacing.xs),
    decoration: BoxDecoration(
      color: Colors.white.withValues(alpha: .1),
      borderRadius: BorderRadius.circular(AppRadius.input),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: color),
            const SizedBox(width: AppSpacing.xxs),
            Expanded(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: color, fontSize: 10),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxs),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value.format(),
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ),
      ],
    ),
  );
}

class _DashboardAlert extends StatelessWidget {
  const _DashboardAlert({required this.hasAccounts, required this.forecast});

  final bool hasAccounts;
  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context) {
    final negative = forecast.hasNegativeBalanceRisk;
    final color = negative ? AppColors.error : AppColors.warning;
    final title = !hasAccounts
        ? 'Configure suas contas para usar o saldo real'
        : negative
        ? 'Saldo pode ficar negativo em ${DateFormat('dd/MM').format(forecast.lowestBalanceDate)}'
        : '${forecast.overdueCount} ${forecast.overdueCount == 1 ? 'compromisso atrasado' : 'compromissos atrasados'}';
    final route = !hasAccounts ? '/accounts' : '/forecast';
    return AppSurfaceCard(
      color: negative ? const Color(0xFFFFF1F0) : AppColors.warningContainer,
      onTap: () => context.push(route),
      child: Row(
        children: [
          Icon(
            negative
                ? Icons.warning_amber_rounded
                : Icons.notification_important_outlined,
            color: color,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: color),
        ],
      ),
    );
  }
}

class _UpcomingCommitments extends StatelessWidget {
  const _UpcomingCommitments({required this.lines});

  final List<CashForecastLine> lines;

  @override
  Widget build(BuildContext context) => AppSurfaceCard(
    padding: EdgeInsets.zero,
    child: lines.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                Icon(Icons.event_available_rounded, color: AppColors.secondary),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: Text('Nenhum compromisso pendente neste mês.')),
              ],
            ),
          )
        : Column(
            children: [
              for (final indexed in lines.indexed) ...[
                _UpcomingRow(line: indexed.$2),
                if (indexed.$1 < lines.length - 1) const Divider(height: 1),
              ],
            ],
          ),
  );
}

class _UpcomingRow extends StatelessWidget {
  const _UpcomingRow({required this.line});

  final CashForecastLine line;

  @override
  Widget build(BuildContext context) {
    final event = line.event;
    final income = event.isIncome;
    final color = event.isOverdue
        ? AppColors.error
        : income
        ? AppColors.secondary
        : AppColors.primary;
    final icon = switch (event.source) {
      CashForecastSource.cashFlow =>
        income ? Icons.south_west_rounded : Icons.receipt_long_outlined,
      CashForecastSource.invoice => Icons.credit_card_outlined,
      CashForecastSource.loanInstallment => Icons.account_balance_outlined,
    };
    final route = switch (event.source) {
      CashForecastSource.cashFlow => '/cash-flow/${event.sourceId}',
      CashForecastSource.invoice => '/invoice/${event.sourceId}',
      CashForecastSource.loanInstallment => '/loans/${event.sourceId}',
    };
    return InkWell(
      onTap: () => context.push(route),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: .11),
                child: Icon(icon, color: color, size: 20),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      event.isOverdue
                          ? 'Atrasado desde ${DateFormat('dd/MM').format(event.date)}'
                          : '${income ? 'Entra' : 'Sai'} em ${DateFormat('dd/MM').format(event.date)}',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${income ? '+' : '−'} ${event.amount.format()}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BudgetOverview extends StatelessWidget {
  const _BudgetOverview({required this.limit, required this.committed});

  final Money limit;
  final Money committed;

  @override
  Widget build(BuildContext context) {
    final remaining = limit - committed;
    final usage = limit.cents <= 0 ? 0.0 : committed.cents / limit.cents;
    final color = remaining.isNegative ? AppColors.error : AppColors.primary;
    return AppSurfaceCard(
      onTap: () => context.push('/budgets'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.donut_small_rounded, color: AppColors.primary),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Orçamento do mês',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Text(
                      remaining.isNegative ? 'Excedido' : 'Disponível',
                      style: TextStyle(color: color, fontSize: 12),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right_rounded),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    remaining.format(),
                    style: TextStyle(
                      color: color,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ),
              Text(
                '${(usage * 100).round()}% usado',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.pill),
            child: LinearProgressIndicator(
              value: usage.clamp(0, 1),
              minHeight: 8,
              color: color,
            ),
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
    final income = entry.isIncome;
    final cancelled = entry.status == CashFlowStatus.cancelled;
    final color = cancelled
        ? AppColors.textMuted
        : income
        ? AppColors.secondary
        : AppColors.error;
    final statusLabel = switch (entry.status) {
      CashFlowStatus.scheduled => income ? 'Prevista' : 'Pendente',
      CashFlowStatus.confirmed => income ? 'Recebida' : 'Paga',
      CashFlowStatus.cancelled => 'Cancelada',
    };
    final effectiveDate = entry.status == CashFlowStatus.scheduled
        ? entry.occurredAt
        : income
        ? entry.receivedAt ?? entry.occurredAt
        : entry.paidAt ?? entry.occurredAt;
    return InkWell(
      borderRadius: BorderRadius.circular(AppRadius.control),
      onTap: () => context.push('/cash-flow/${entry.id}'),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 72),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: color.withValues(alpha: .1),
                child: Icon(
                  cashFlowKindIcon(entry.kind),
                  size: 20,
                  color: color,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
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
                    const SizedBox(height: 3),
                    Text(
                      '$statusLabel • ${DateFormat("d 'de' MMM", 'pt_BR').format(effectiveDate)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.xs),
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    '${income ? '+' : '−'} ${entry.amount.format()}',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.w700,
                      fontFeatures: const [FontFeature.tabularFigures()],
                      decoration: cancelled ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
              ),
            ],
          ),
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
        : activity.person.characters.first.toUpperCase();
    return AppSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: AppColors.surfaceContainer,
            child: Text(initial),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '${activity.person} ',
                        style: const TextStyle(fontWeight: FontWeight.w700),
                      ),
                      TextSpan(text: activity.description),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  activity.whenLabel,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.monthName, required this.year});

  final String monthName;
  final int year;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 40,
        height: 40,
        decoration: const BoxDecoration(
          color: AppColors.primaryFixed,
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.calendar_month_rounded,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(width: AppSpacing.sm),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Seu mês em uma visão',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$monthName de $year',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      IconButton(
        tooltip: 'Análises e relatórios',
        onPressed: () => context.push('/analytics'),
        icon: const Icon(Icons.query_stats_rounded),
      ),
    ],
  );
}

Money _sumMoney(Iterable<Money> values) =>
    values.fold(const Money.zero(), (total, value) => total + value);

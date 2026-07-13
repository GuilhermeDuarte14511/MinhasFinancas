import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow_forecast.dart';

class CashFlowForecastPage extends ConsumerStatefulWidget {
  const CashFlowForecastPage({super.key});

  @override
  ConsumerState<CashFlowForecastPage> createState() =>
      _CashFlowForecastPageState();
}

class _CashFlowForecastPageState extends ConsumerState<CashFlowForecastPage> {
  int _horizonDays = 30;

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final forecast = finance.cashFlowForecast(horizonDays: _horizonDays);
    return Scaffold(
      appBar: const BrandAppBar(title: 'Previsão de caixa', showBack: true),
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AppContent(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Veja o que entra, o que sai e quanto deve sobrar.',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 18),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (final days in const [30, 60, 90]) ...[
                        ChoiceChip(
                          label: Text('$days dias'),
                          selected: _horizonDays == days,
                          onSelected: (_) =>
                              setState(() => _horizonDays = days),
                        ),
                        if (days != 90) const SizedBox(width: 8),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 18),
                _ForecastHero(forecast: forecast),
                const SizedBox(height: 14),
                if (finance.accounts.isEmpty)
                  _ForecastAlert(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'Cadastre uma conta para partir do saldo real',
                    description:
                        'As entradas e saídas já são projetadas, mas o saldo inicial está zerado.',
                    actionLabel: finance.canEdit ? 'Cadastrar conta' : null,
                    onAction: finance.canEdit
                        ? () => context.push('/accounts/new')
                        : null,
                  )
                else if (forecast.hasNegativeBalanceRisk)
                  _ForecastAlert(
                    icon: Icons.warning_amber_rounded,
                    title:
                        'Risco de saldo negativo em ${_shortDate(forecast.lowestBalanceDate)}',
                    description:
                        'O menor saldo previsto é ${forecast.lowestBalance.format()}. Revise os vencimentos ou antecipe uma receita.',
                    isError: true,
                    actionLabel: 'Ver agenda',
                    onAction: () => context.go('/app/agenda'),
                  )
                else if (forecast.overdueCount > 0)
                  _ForecastAlert(
                    icon: Icons.notification_important_outlined,
                    title:
                        '${forecast.overdueCount} ${forecast.overdueCount == 1 ? 'lançamento atrasado' : 'lançamentos atrasados'}',
                    description:
                        'Valores vencidos foram aplicados hoje para manter a projeção conservadora.',
                    actionLabel: 'Ver agenda',
                    onAction: () => context.go('/app/agenda'),
                  ),
                const SizedBox(height: 26),
                SectionHeading(
                  title: 'Linha do tempo financeira',
                  actionLabel: 'Agenda',
                  onAction: () => context.go('/app/agenda'),
                ),
                const SizedBox(height: 6),
                Text(
                  'O saldo é recalculado depois de cada compromisso pendente.',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 12),
                if (forecast.lines.isEmpty)
                  const _EmptyForecast()
                else
                  for (
                    var index = 0;
                    index < forecast.lines.length;
                    index++
                  ) ...[
                    _ForecastTimelineItem(line: forecast.lines[index]),
                    if (index < forecast.lines.length - 1)
                      const SizedBox(height: 10),
                  ],
                const SizedBox(height: 18),
                const _ForecastExplanation(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ForecastHero extends StatelessWidget {
  const _ForecastHero({required this.forecast});

  final CashFlowForecast forecast;

  @override
  Widget build(BuildContext context) {
    final positive = !forecast.closingBalance.isNegative;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF302F69), AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
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
          Text(
            'SALDO PREVISTO EM ${_shortDate(forecast.throughDate).toUpperCase()}',
            style: const TextStyle(
              color: Color(0xFFDAD7FF),
              fontSize: 11,
              letterSpacing: .8,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              forecast.closingBalance.format(),
              style: TextStyle(
                color: positive ? Colors.white : const Color(0xFFFFDAD6),
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxWidth < 360;
              final children = [
                _ForecastMetric(
                  label: 'Saldo de hoje',
                  value: forecast.openingBalance,
                  icon: Icons.account_balance_wallet_outlined,
                ),
                _ForecastMetric(
                  label: 'Entradas',
                  value: forecast.expectedIncome,
                  icon: Icons.south_west_rounded,
                  color: const Color(0xFF99EFE5),
                ),
                _ForecastMetric(
                  label: 'Saídas',
                  value: forecast.expectedExpenses,
                  icon: Icons.north_east_rounded,
                  color: const Color(0xFFFFDAD6),
                ),
              ];
              if (compact) {
                return Column(
                  children: [
                    for (var index = 0; index < children.length; index++) ...[
                      children[index],
                      if (index < children.length - 1)
                        const SizedBox(height: 9),
                    ],
                  ],
                );
              }
              return Row(
                children: [
                  for (var index = 0; index < children.length; index++) ...[
                    Expanded(child: children[index]),
                    if (index < children.length - 1) const SizedBox(width: 10),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0x33FFFFFF)),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(
                Icons.vertical_align_bottom_rounded,
                size: 18,
                color: Color(0xFFDAD7FF),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Menor saldo em ${_shortDate(forecast.lowestBalanceDate)}',
                  style: const TextStyle(
                    color: Color(0xFFDAD7FF),
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                forecast.lowestBalance.format(),
                style: TextStyle(
                  color: forecast.lowestBalance.isNegative
                      ? const Color(0xFFFFDAD6)
                      : Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ForecastMetric extends StatelessWidget {
  const _ForecastMetric({
    required this.label,
    required this.value,
    required this.icon,
    this.color = const Color(0xFFDAD7FF),
  });

  final String label;
  final Money value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(11),
    decoration: BoxDecoration(
      color: const Color(0x18FFFFFF),
      borderRadius: BorderRadius.circular(13),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 5),
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
        const SizedBox(height: 6),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value.format(),
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ),
      ],
    ),
  );
}

class _ForecastAlert extends StatelessWidget {
  const _ForecastAlert({
    required this.icon,
    required this.title,
    required this.description,
    this.isError = false,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool isError;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final color = isError ? AppColors.error : AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isError ? const Color(0xFFFFDAD6) : AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: .25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(color: color, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 3),
                Text(description),
                if (actionLabel != null && onAction != null) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: onAction,
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      foregroundColor: color,
                    ),
                    child: Text(actionLabel!),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ForecastTimelineItem extends StatelessWidget {
  const _ForecastTimelineItem({required this.line});

  final CashForecastLine line;

  @override
  Widget build(BuildContext context) {
    final event = line.event;
    final route = switch (event.source) {
      CashForecastSource.cashFlow => '/cash-flow/${event.sourceId}',
      CashForecastSource.invoice => '/invoice/${event.sourceId}',
      CashForecastSource.loanInstallment => '/loans/${event.sourceId}',
    };
    final color = event.isIncome ? AppColors.secondary : AppColors.error;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push(route),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .1),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Column(
                  children: [
                    Text(
                      '${event.date.day}',
                      style: TextStyle(
                        color: color,
                        fontSize: 19,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      DateFormat.MMM('pt_BR').format(event.date).toUpperCase(),
                      style: const TextStyle(fontSize: 10),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 5),
                    Wrap(
                      spacing: 7,
                      runSpacing: 7,
                      children: [
                        StatusPill(
                          label: _sourceLabel(event.source),
                          color: AppColors.primary,
                        ),
                        StatusPill(
                          label: event.isOverdue ? 'Atrasado' : 'Previsto',
                          color: event.isOverdue
                              ? AppColors.error
                              : AppColors.textMuted,
                        ),
                      ],
                    ),
                    const SizedBox(height: 9),
                    Text(
                      'Saldo após: ${line.balanceAfter.format()}',
                      style: TextStyle(
                        color: line.balanceAfter.isNegative
                            ? AppColors.error
                            : AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: line.balanceAfter.isNegative
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 108,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        '${event.isIncome ? '+' : '−'} ${event.amount.format()}',
                        style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Icon(Icons.chevron_right_rounded, size: 20),
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

class _EmptyForecast extends StatelessWidget {
  const _EmptyForecast();

  @override
  Widget build(BuildContext context) => Card(
    color: AppColors.surfaceLow,
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const Icon(
            Icons.event_available_rounded,
            size: 40,
            color: AppColors.secondary,
          ),
          const SizedBox(height: 10),
          Text(
            'Nenhuma entrada ou saída pendente neste período.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    ),
  );
}

class _ForecastExplanation extends StatelessWidget {
  const _ForecastExplanation();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline_rounded, color: AppColors.primary),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            'Pagamentos e recebimentos realizados já fazem parte do saldo atual. Compras no cartão entram somente pela fatura, evitando contar a mesma despesa duas vezes.',
          ),
        ),
      ],
    ),
  );
}

String _sourceLabel(CashForecastSource source) => switch (source) {
  CashForecastSource.cashFlow => 'Lançamento',
  CashForecastSource.invoice => 'Fatura',
  CashForecastSource.loanInstallment => 'Empréstimo',
};

String _shortDate(DateTime date) => DateFormat('dd/MM', 'pt_BR').format(date);

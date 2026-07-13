import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

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
    final now = DateTime.now();
    final month = DateTime(now.year, now.month);
    final installments = finance.purchaseInstallments
        .where(
          (installment) =>
              installment.status != InstallmentStatus.cancelled &&
              _isSameMonth(installment.dueDate, month),
        )
        .toList();
    final cardExpenses = _sumMoney(
      installments.map((installment) => installment.amount),
    );
    final incomes = finance.cashFlowEntries
        .where(
          (income) =>
              income.isIncome &&
              income.status != CashFlowStatus.cancelled &&
              _isSameMonth(income.occurredAt, month),
        )
        .toList();
    final expectedIncome = _sumMoney(incomes.map((income) => income.amount));
    final receivedIncome = _sumMoney(
      incomes
          .where((income) => income.status == CashFlowStatus.confirmed)
          .map((income) => income.amount),
    );
    final otherExpenseEntries = finance.cashFlowEntries
        .where(
          (entry) =>
              !entry.isIncome &&
              entry.status != CashFlowStatus.cancelled &&
              _isSameMonth(entry.occurredAt, month),
        )
        .toList();
    final otherExpenses = _sumMoney(
      otherExpenseEntries.map((entry) => entry.amount),
    );
    final weeklyIncome = List<Money>.generate(5, (_) => const Money.zero());
    final weeklyExpenses = List<Money>.generate(5, (_) => const Money.zero());
    for (final income in incomes) {
      final week = ((income.occurredAt.day - 1) ~/ 7).clamp(0, 4);
      weeklyIncome[week] = weeklyIncome[week] + income.amount;
    }
    for (final expense in otherExpenseEntries) {
      final week = ((expense.occurredAt.day - 1) ~/ 7).clamp(0, 4);
      weeklyExpenses[week] = weeklyExpenses[week] + expense.amount;
    }
    for (final installment in installments) {
      final week = ((installment.dueDate.day - 1) ~/ 7).clamp(0, 4);
      weeklyExpenses[week] = weeklyExpenses[week] + installment.amount;
    }
    final loansById = {for (final loan in finance.loans) loan.id: loan};
    final allMonthLoanInstallments = finance.loanInstallments
        .where(
          (installment) =>
              _isSameMonth(installment.dueDate, month) &&
              installment.status != LoanInstallmentStatus.cancelled,
        )
        .toList();
    final loanExpenses = _sumMoney(
      allMonthLoanInstallments.map((installment) => installment.total),
    );
    for (final installment in allMonthLoanInstallments) {
      final week = ((installment.dueDate.day - 1) ~/ 7).clamp(0, 4);
      weeklyExpenses[week] = weeklyExpenses[week] + installment.total;
    }
    final monthLoanInstallments = allMonthLoanInstallments
        .where(
          (installment) => installment.status != LoanInstallmentStatus.paid,
        )
        .toList();
    final scheduledLoanIds = allMonthLoanInstallments
        .map((installment) => installment.loanId)
        .toSet();
    final dueItems = <_DashboardDueItem>[
      for (final invoice in finance.invoices)
        if (_isSameMonth(invoice.dueDate, month) &&
            invoice.status != InvoiceStatus.paid &&
            invoice.status != InvoiceStatus.cancelled)
          _DashboardDueItem.invoice(invoice),
      for (final installment in monthLoanInstallments)
        if (loansById[installment.loanId] case final loan?)
          _DashboardDueItem.loanInstallment(installment, loan),
      for (final loan in finance.loans)
        if (!loan.outstandingBalance.isZero &&
            !scheduledLoanIds.contains(loan.id))
          _DashboardDueItem.loan(
            loan,
            DateTime(
              month.year,
              month.month,
              loan.dueDay.clamp(
                1,
                DateUtils.getDaysInMonth(month.year, month.month),
              ),
            ),
          ),
    ]..sort((first, second) => first.date.compareTo(second.date));
    final overdueCount = dueItems.where((item) => item.isOverdue).length;
    final totalExpenses = cardExpenses + loanExpenses + otherExpenses;
    final balance = expectedIncome - totalExpenses;
    final monthName = toBeginningOfSentenceCase(
      DateFormat.MMMM('pt_BR').format(month),
    );

    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          maxWidth: 760,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _MonthHeader(monthName: monthName, year: month.year),
              const SizedBox(height: 18),
              AnimatedPageEntry(
                child: _CashFlowOverview(
                  monthName: monthName,
                  expectedIncome: expectedIncome,
                  receivedIncome: receivedIncome,
                  cardExpenses: cardExpenses,
                  loanExpenses: loanExpenses,
                  otherExpenses: otherExpenses,
                  balance: balance,
                ),
              ),
              const SizedBox(height: 14),
              AnimatedPageEntry(
                delay: const Duration(milliseconds: 80),
                child: Row(
                  children: [
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.south_west_rounded,
                        label: 'Já recebido',
                        value: receivedIncome.format(),
                        helper:
                            '${incomes.where((income) => income.status == CashFlowStatus.confirmed).length} entradas',
                        isIncome: true,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: _MetricTile(
                        icon: Icons.warning_amber_rounded,
                        label: 'Vencidos',
                        value: '$overdueCount',
                        helper: overdueCount == 1 ? 'pendência' : 'pendências',
                        isError: overdueCount > 0,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 26),
              AnimatedPageEntry(
                delay: const Duration(milliseconds: 140),
                child: _WeeklyCashFlowChart(
                  monthName: monthName,
                  weeklyIncome: weeklyIncome,
                  weeklyExpenses: weeklyExpenses,
                ),
              ),
              const SizedBox(height: 26),
              const SectionHeading(title: 'Limites disponíveis agora'),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _LimitTile(
                      label: 'Disponível',
                      value: finance.availableLimit,
                      emphasized: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _LimitTile(
                      label: 'Limite total',
                      value: finance.totalLimit,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vencimentos de $monthName',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/app/agenda'),
                    child: const Text('Ver agenda'),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _DueItemsCard(items: dueItems.take(4).toList()),
              if (finance.cashFlowEntries.isNotEmpty) ...[
                const SizedBox(height: 28),
                const SectionHeading(title: 'Movimentações recentes'),
                const SizedBox(height: 8),
                _RecentCashFlowList(entries: finance.cashFlowEntries.take(5)),
              ],
              if (finance.activities.isNotEmpty) ...[
                const SizedBox(height: 28),
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
      CashFlowStatus.scheduled => income ? 'Prevista' : 'Pendente',
      CashFlowStatus.confirmed => income ? 'Recebida' : 'Paga',
      CashFlowStatus.cancelled => 'Cancelada',
    };
    final effectiveDate = entry.status == CashFlowStatus.scheduled
        ? entry.occurredAt
        : income
        ? entry.receivedAt ?? entry.occurredAt
        : entry.paidAt ?? entry.occurredAt;
    final formattedDate = DateFormat(
      "d 'de' MMM",
      'pt_BR',
    ).format(effectiveDate);
    final signedValue = '${income ? '+' : '−'} ${entry.amount.format()}';
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: () => context.push('/cash-flow/${entry.id}'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 21,
              backgroundColor: color.withValues(alpha: .1),
              child: Icon(cashFlowKindIcon(entry.kind), size: 21, color: color),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
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
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
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
                  Text(
                    '$statusLabel • ${cashFlowKindLabel(entry.kind)} • $formattedDate',
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

class _MonthHeader extends StatelessWidget {
  const _MonthHeader({required this.monthName, required this.year});

  final String monthName;
  final int year;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Container(
        width: 42,
        height: 42,
        decoration: const BoxDecoration(
          color: Color(0xFFE2DFFF),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.calendar_month_rounded,
          color: AppColors.primary,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Visão de $monthName',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              '$year · somente o mês atual',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      Material(
        color: AppColors.surfaceContainer,
        shape: const StadiumBorder(),
        child: InkWell(
          customBorder: const StadiumBorder(),
          onTap: () => context.push('/analytics'),
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 9),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.query_stats_rounded,
                  size: 18,
                  color: AppColors.primary,
                ),
                SizedBox(width: 6),
                Text(
                  'Análises',
                  style: TextStyle(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ],
  );
}

class _CashFlowOverview extends StatelessWidget {
  const _CashFlowOverview({
    required this.monthName,
    required this.expectedIncome,
    required this.receivedIncome,
    required this.cardExpenses,
    required this.loanExpenses,
    required this.otherExpenses,
    required this.balance,
  });

  final String monthName;
  final Money expectedIncome;
  final Money receivedIncome;
  final Money cardExpenses;
  final Money loanExpenses;
  final Money otherExpenses;
  final Money balance;

  @override
  Widget build(BuildContext context) {
    final expenses = cardExpenses + loanExpenses + otherExpenses;
    final positive = !balance.isNegative;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF302F69), AppColors.primaryContainer],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(18),
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
          Row(
            children: [
              Expanded(
                child: Text(
                  'Fluxo de caixa de ${monthName.toLowerCase()}',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(color: Colors.white),
                ),
              ),
              Material(
                color: const Color(0x22FFFFFF),
                shape: const StadiumBorder(),
                child: InkWell(
                  customBorder: const StadiumBorder(),
                  onTap: () => context.push('/incomes'),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Text(
                      'Ver receitas',
                      style: TextStyle(color: Color(0xFFDAD7FF), fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            positive ? 'SALDO PREVISTO' : 'DÉFICIT PREVISTO',
            style: const TextStyle(
              color: Color(0xFFDAD7FF),
              fontSize: 12,
              fontWeight: FontWeight.w500,
              letterSpacing: 1.1,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              balance.format(),
              style: TextStyle(
                color: positive ? Colors.white : const Color(0xFFFFDAD6),
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _FlowRow(
            icon: Icons.south_west_rounded,
            label: 'Receitas previstas',
            value: expectedIncome,
            color: const Color(0xFF99EFE5),
          ),
          const SizedBox(height: 9),
          _FlowRow(
            icon: Icons.credit_card_outlined,
            label: 'Cartões',
            value: cardExpenses,
            color: const Color(0xFFDAD7FF),
          ),
          const SizedBox(height: 9),
          _FlowRow(
            icon: Icons.account_balance_outlined,
            label: 'Empréstimos',
            value: loanExpenses,
            color: const Color(0xFFDAD7FF),
          ),
          if (!otherExpenses.isZero) ...[
            const SizedBox(height: 9),
            _FlowRow(
              icon: Icons.payments_outlined,
              label: 'Outras despesas',
              value: otherExpenses,
              color: const Color(0xFFDAD7FF),
            ),
          ],
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0x33FFFFFF)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Recebido: ${receivedIncome.format()}',
                  style: const TextStyle(
                    color: Color(0xFF99EFE5),
                    fontSize: 12,
                  ),
                ),
              ),
              Text(
                'Despesas: ${expenses.format()}',
                style: const TextStyle(color: Color(0xFFDAD7FF), fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _FlowRow extends StatelessWidget {
  const _FlowRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Money value;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, color: color, size: 18),
      const SizedBox(width: 8),
      Expanded(
        child: Text(label, style: TextStyle(color: color, fontSize: 13)),
      ),
      Text(
        value.format(),
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w600,
          fontSize: 13,
        ),
      ),
    ],
  );
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.label,
    required this.value,
    required this.helper,
    this.isError = false,
    this.isIncome = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final String helper;
  final bool isError;
  final bool isIncome;

  @override
  Widget build(BuildContext context) {
    final background = isIncome
        ? AppColors.secondaryContainer
        : isError
        ? const Color(0xFFFFDAD6)
        : AppColors.surfaceLow;
    final foreground = isIncome
        ? AppColors.secondary
        : isError
        ? const Color(0xFF93000A)
        : AppColors.text;
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isError ? AppColors.error : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: foreground),
              const SizedBox(width: 7),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: foreground, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                color: foreground,
                fontSize: 22,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Text(
            helper,
            style: TextStyle(
              color: foreground.withValues(alpha: .76),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyCashFlowChart extends StatelessWidget {
  const _WeeklyCashFlowChart({
    required this.monthName,
    required this.weeklyIncome,
    required this.weeklyExpenses,
  });

  final String monthName;
  final List<Money> weeklyIncome;
  final List<Money> weeklyExpenses;

  @override
  Widget build(BuildContext context) {
    final maxCents = [...weeklyIncome, ...weeklyExpenses].fold<int>(
      0,
      (maximum, value) => value.cents > maximum ? value.cents : maximum,
    );
    const labels = ['1–7', '8–14', '15–21', '22–28', '29+'];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D0F172A),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.secondaryContainer,
                child: Icon(
                  Icons.bar_chart_rounded,
                  color: AppColors.secondary,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Entradas e saídas',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      'Movimentação prevista por semana de $monthName',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Row(
            children: [
              _ChartLegend(color: AppColors.secondary, label: 'Receitas'),
              SizedBox(width: 16),
              _ChartLegend(color: AppColors.primary, label: 'Despesas'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 132,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < weeklyIncome.length; index++)
                  Expanded(
                    child: _WeeklyBarPair(
                      label: labels[index],
                      income: weeklyIncome[index],
                      expenses: weeklyExpenses[index],
                      incomeFraction: maxCents == 0
                          ? 0
                          : weeklyIncome[index].cents / maxCents,
                      expenseFraction: maxCents == 0
                          ? 0
                          : weeklyExpenses[index].cents / maxCents,
                    ),
                  ),
              ],
            ),
          ),
          if (maxCents == 0)
            const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Text(
                'Receitas, compras e empréstimos aparecerão aqui ao serem registrados.',
                style: TextStyle(color: AppColors.textMuted, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}

class _ChartLegend extends StatelessWidget {
  const _ChartLegend({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        width: 9,
        height: 9,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
      ),
    ],
  );
}

class _WeeklyBarPair extends StatelessWidget {
  const _WeeklyBarPair({
    required this.label,
    required this.income,
    required this.expenses,
    required this.incomeFraction,
    required this.expenseFraction,
  });

  final String label;
  final Money income;
  final Money expenses;
  final double incomeFraction;
  final double expenseFraction;

  @override
  Widget build(BuildContext context) => Tooltip(
    message:
        '$label · Receitas: ${income.format()} · Despesas: ${expenses.format()}',
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: FractionallySizedBox(
                      heightFactor: incomeFraction == 0
                          ? .035
                          : (.15 + incomeFraction * .85),
                      widthFactor: .68,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.secondary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 3),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomLeft,
                    child: FractionallySizedBox(
                      heightFactor: expenseFraction == 0
                          ? .035
                          : (.15 + expenseFraction * .85),
                      widthFactor: .68,
                      child: Container(
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(6),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 7),
          Text(
            label,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    ),
  );
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
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: emphasized ? AppColors.primaryContainer : AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(
        color: emphasized ? AppColors.primaryContainer : AppColors.outline,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: emphasized ? const Color(0xFFDAD7FF) : AppColors.textMuted,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            value.format(),
            style: TextStyle(
              color: emphasized ? Colors.white : AppColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    ),
  );
}

class _DueItemsCard extends StatelessWidget {
  const _DueItemsCard({required this.items});

  final List<_DashboardDueItem> items;

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: AppColors.outline),
    ),
    child: items.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(24),
            child: Row(
              children: [
                Icon(Icons.event_available_rounded, color: AppColors.secondary),
                SizedBox(width: 12),
                Expanded(child: Text('Nenhum vencimento pendente neste mês.')),
              ],
            ),
          )
        : Column(
            children: [
              for (final entry in items.indexed) ...[
                InkWell(
                  borderRadius: entry.$1 == 0
                      ? const BorderRadius.vertical(top: Radius.circular(18))
                      : entry.$1 == items.length - 1
                      ? const BorderRadius.vertical(bottom: Radius.circular(18))
                      : BorderRadius.zero,
                  onTap: () => context.push(entry.$2.route),
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: entry.$2.isOverdue
                              ? const Color(0xFFFFDAD6)
                              : entry.$2.iconBackground,
                          child: Icon(
                            entry.$2.isOverdue
                                ? Icons.warning_amber_rounded
                                : entry.$2.icon,
                            color: entry.$2.isOverdue
                                ? const Color(0xFF93000A)
                                : entry.$2.iconColor,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                entry.$2.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                entry.$2.subtitle,
                                style: TextStyle(
                                  color: entry.$2.isOverdue
                                      ? AppColors.error
                                      : AppColors.textMuted,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          entry.$2.amount.format(),
                          style: TextStyle(
                            color: entry.$2.isOverdue
                                ? AppColors.error
                                : AppColors.text,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                if (entry.$1 < items.length - 1) const Divider(height: 1),
              ],
            ],
          ),
  );
}

class _DashboardDueItem {
  const _DashboardDueItem({
    required this.title,
    required this.subtitle,
    required this.date,
    required this.amount,
    required this.route,
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.isOverdue,
  });

  factory _DashboardDueItem.invoice(InvoiceSummary invoice) {
    final overdue =
        invoice.status == InvoiceStatus.overdue ||
        invoice.dueDate.isBefore(DateUtils.dateOnly(DateTime.now()));
    return _DashboardDueItem(
      title: invoice.cardName.toLowerCase().startsWith('fatura')
          ? invoice.cardName
          : 'Fatura ${invoice.cardName}',
      subtitle: overdue
          ? 'Venceu em ${DateFormat('dd/MM').format(invoice.dueDate)}'
          : 'Vence em ${DateFormat('dd/MM').format(invoice.dueDate)}',
      date: invoice.dueDate,
      amount: invoice.pending,
      route: '/invoice/${invoice.id}',
      icon: Icons.receipt_long_outlined,
      iconBackground: const Color(0xFFE2DFFF),
      iconColor: AppColors.primary,
      isOverdue: overdue,
    );
  }

  factory _DashboardDueItem.loan(LoanContract loan, DateTime date) {
    final overdue = date.isBefore(DateUtils.dateOnly(DateTime.now()));
    return _DashboardDueItem(
      title: loan.description,
      subtitle: overdue
          ? 'Venceu em ${DateFormat('dd/MM').format(date)}'
          : 'Vence em ${DateFormat('dd/MM').format(date)}',
      date: date,
      amount: loan.installmentAmount,
      route: '/loans/${loan.id}',
      icon: Icons.account_balance_outlined,
      iconBackground: AppColors.surfaceContainer,
      iconColor: AppColors.text,
      isOverdue: overdue,
    );
  }

  factory _DashboardDueItem.loanInstallment(
    LoanInstallmentRecord installment,
    LoanContract loan,
  ) {
    final overdue =
        installment.status == LoanInstallmentStatus.overdue ||
        installment.dueDate.isBefore(DateUtils.dateOnly(DateTime.now()));
    return _DashboardDueItem(
      title: loan.description,
      subtitle: overdue
          ? 'Venceu em ${DateFormat('dd/MM').format(installment.dueDate)}'
          : 'Vence em ${DateFormat('dd/MM').format(installment.dueDate)}',
      date: installment.dueDate,
      amount: installment.pending,
      route: '/loans/${loan.id}',
      icon: Icons.account_balance_outlined,
      iconBackground: AppColors.surfaceContainer,
      iconColor: AppColors.text,
      isOverdue: overdue,
    );
  }

  final String title;
  final String subtitle;
  final DateTime date;
  final Money amount;
  final String route;
  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final bool isOverdue;
}

Money _sumMoney(Iterable<Money> values) =>
    values.fold(const Money.zero(), (total, value) => total + value);

bool _isSameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

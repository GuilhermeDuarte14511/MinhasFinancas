import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../../finance/application/finance_controller.dart';
import '../../finance/domain/cash_flow.dart';
import '../../finance/domain/finance_models.dart';

enum _AnalyticsPeriod {
  currentMonth,
  lastThreeMonths,
  lastSixMonths,
  currentYear,
}

enum _FlowType { all, income, expenses, cards, loans }

class AnalyticsPage extends ConsumerStatefulWidget {
  const AnalyticsPage({super.key});

  @override
  ConsumerState<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends ConsumerState<AnalyticsPage> {
  _AnalyticsPeriod _period = _AnalyticsPeriod.currentMonth;
  _FlowType _flowType = _FlowType.all;
  String? _category;
  String? _cardId;

  int get _activeFilterCount =>
      (_period == _AnalyticsPeriod.currentMonth ? 0 : 1) +
      (_flowType == _FlowType.all ? 0 : 1) +
      (_category == null ? 0 : 1) +
      (_cardId == null ? 0 : 1);

  void _resetFilters() {
    setState(() {
      _period = _AnalyticsPeriod.currentMonth;
      _flowType = _FlowType.all;
      _category = null;
      _cardId = null;
    });
  }

  Future<void> _openFilters(
    List<String> categories,
    List<CreditCardAccount> cards,
  ) async {
    var period = _period;
    var flowType = _flowType;
    var category = _category;
    var cardId = _cardId;
    final selection = await showModalBottomSheet<_AnalyticsSelection>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              20,
              4,
              20,
              20 + MediaQuery.viewInsetsOf(context).bottom,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Filtrar análises',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                Text(
                  'Combine período, cartão e categoria para comparar seus gastos.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<_FlowType>(
                  initialValue: flowType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo de movimentação',
                    prefixIcon: Icon(Icons.swap_vert_rounded),
                  ),
                  items: [
                    for (final value in _FlowType.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(_flowTypeLabel(value)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => flowType = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<_AnalyticsPeriod>(
                  initialValue: period,
                  decoration: const InputDecoration(
                    labelText: 'Período',
                    prefixIcon: Icon(Icons.date_range_outlined),
                  ),
                  items: [
                    for (final value in _AnalyticsPeriod.values)
                      DropdownMenuItem(
                        value: value,
                        child: Text(_periodLabel(value)),
                      ),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      setSheetState(() => period = value);
                    }
                  },
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: cardId,
                  decoration: const InputDecoration(
                    labelText: 'Cartão',
                    prefixIcon: Icon(Icons.credit_card_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todos os cartões'),
                    ),
                    for (final card in cards)
                      DropdownMenuItem<String?>(
                        value: card.id,
                        child: Text(card.nickname),
                      ),
                  ],
                  onChanged: (value) => setSheetState(() => cardId = value),
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  initialValue: category,
                  decoration: const InputDecoration(
                    labelText: 'Categoria',
                    prefixIcon: Icon(Icons.category_outlined),
                  ),
                  items: [
                    const DropdownMenuItem<String?>(
                      value: null,
                      child: Text('Todas as categorias'),
                    ),
                    for (final item in categories)
                      DropdownMenuItem<String?>(value: item, child: Text(item)),
                  ],
                  onChanged: (value) => setSheetState(() => category = value),
                ),
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: () => Navigator.pop(
                    sheetContext,
                    _AnalyticsSelection(
                      period: period,
                      flowType: flowType,
                      category: category,
                      cardId: cardId,
                    ),
                  ),
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Aplicar filtros'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    if (selection == null || !mounted) return;
    setState(() {
      _period = selection.period;
      _flowType = selection.flowType;
      _category = selection.category;
      _cardId = selection.cardId;
    });
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final now = DateTime.now();
    final bounds = _periodBounds(_period, now);
    final purchasesById = {
      for (final purchase in finance.purchases) purchase.id: purchase,
    };
    final categorySet = <String>{
      ...finance.categories,
      ...finance.purchases.map((purchase) => purchase.category),
      ...finance.cashFlowEntries.map(
        (entry) => entry.categoryName ?? 'Sem categoria',
      ),
      'Empréstimos',
    }..removeWhere((category) => category.trim().isEmpty);
    final categories = categorySet.toList()..sort();
    final allEntries = <_FlowEntry>[
      for (final entry in finance.cashFlowEntries)
        if (entry.status != CashFlowStatus.cancelled)
          _FlowEntry(
            type: entry.isIncome ? _FlowType.income : _FlowType.expenses,
            date: entry.occurredAt,
            amount: entry.amount,
            category: entry.categoryName ?? 'Sem categoria',
          ),
      for (final installment in finance.purchaseInstallments)
        if (installment.status != InstallmentStatus.cancelled)
          if (purchasesById[installment.purchaseId] case final purchase?)
            _FlowEntry(
              type: _FlowType.cards,
              date: installment.dueDate,
              amount: installment.amount,
              category: purchase.category,
              cardId: purchase.cardId,
            ),
      for (final installment in finance.loanInstallments)
        if (installment.status != LoanInstallmentStatus.cancelled)
          _FlowEntry(
            type: _FlowType.loans,
            date: installment.dueDate,
            amount: installment.total,
            category: 'Empréstimos',
          ),
    ];
    final entries = allEntries.where((entry) {
      if (entry.date.isBefore(bounds.start) ||
          !entry.date.isBefore(bounds.end)) {
        return false;
      }
      if (_flowType != _FlowType.all && entry.type != _flowType) return false;
      if (_category != null && entry.category != _category) return false;
      if (_cardId != null && entry.cardId != _cardId) return false;
      return true;
    }).toList();
    final incomeTotal = _sumMoney(
      entries
          .where((entry) => entry.type == _FlowType.income)
          .map((entry) => entry.amount),
    );
    final expenseTotal = _sumMoney(
      entries
          .where((entry) => entry.type != _FlowType.income)
          .map((entry) => entry.amount),
    );
    final balance = incomeTotal - expenseTotal;
    final months = _monthsBetween(bounds.start, bounds.end);
    final monthlyTotals = [
      for (final month in months)
        _MonthTotal(
          month: month,
          income: _sumMoney(
            entries
                .where(
                  (entry) =>
                      entry.type == _FlowType.income &&
                      entry.date.year == month.year &&
                      entry.date.month == month.month,
                )
                .map((entry) => entry.amount),
          ),
          expenses: _sumMoney(
            entries
                .where(
                  (entry) =>
                      entry.type != _FlowType.income &&
                      entry.date.year == month.year &&
                      entry.date.month == month.month,
                )
                .map((entry) => entry.amount),
          ),
        ),
    ];
    final incomeBreakdown =
        _flowType == _FlowType.income ||
        (expenseTotal.isZero && !incomeTotal.isZero);
    final categoryEntries = incomeBreakdown
        ? entries.where((entry) => entry.type == _FlowType.income)
        : entries.where((entry) => entry.type != _FlowType.income);
    final categoryAmounts = <String, Money>{};
    for (final entry in categoryEntries) {
      categoryAmounts[entry.category] =
          (categoryAmounts[entry.category] ?? const Money.zero()) +
          entry.amount;
    }
    final categoryTotals = [
      for (final entry in categoryAmounts.entries)
        _CategoryTotal(category: entry.key, amount: entry.value),
    ]..sort((first, second) => second.amount.compareTo(first.amount));
    final averageBalance = Money.fromCents(
      monthlyTotals.isEmpty ? 0 : balance.cents ~/ monthlyTotals.length,
    );
    final categoryTotal = incomeBreakdown ? incomeTotal : expenseTotal;
    final selectedCardName = finance.cards
        .where((card) => card.id == _cardId)
        .map((card) => card.nickname)
        .firstOrNull;

    return Scaffold(
      appBar: BrandAppBar(
        title: 'Análises',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Filtrar análises',
            onPressed: () => _openFilters(categories, finance.cards),
            icon: Badge(
              isLabelVisible: _activeFilterCount > 0,
              label: Text('$_activeFilterCount'),
              child: const Icon(Icons.tune_rounded),
            ),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: AppContent(
          maxWidth: 760,
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  final copy = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Seu fluxo em perspectiva',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Compare receitas, cartões e empréstimos em qualquer período.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  );
                  final button = FilledButton.tonalIcon(
                    onPressed: () => _openFilters(categories, finance.cards),
                    icon: const Icon(Icons.tune_rounded, size: 18),
                    label: const Text('Filtrar'),
                  );
                  if (constraints.maxWidth < 420) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [copy, const SizedBox(height: 14), button],
                    );
                  }
                  return Row(
                    children: [
                      Expanded(child: copy),
                      const SizedBox(width: 12),
                      button,
                    ],
                  );
                },
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterPill(
                      icon: Icons.date_range_outlined,
                      label: _periodLabel(_period),
                    ),
                    if (_flowType != _FlowType.all) ...[
                      const SizedBox(width: 8),
                      _FilterPill(
                        icon: Icons.swap_vert_rounded,
                        label: _flowTypeLabel(_flowType),
                      ),
                    ],
                    if (selectedCardName != null) ...[
                      const SizedBox(width: 8),
                      _FilterPill(
                        icon: Icons.credit_card_outlined,
                        label: selectedCardName,
                      ),
                    ],
                    if (_category != null) ...[
                      const SizedBox(width: 8),
                      _FilterPill(
                        icon: Icons.category_outlined,
                        label: _category!,
                      ),
                    ],
                    if (_activeFilterCount > 0) ...[
                      const SizedBox(width: 4),
                      TextButton(
                        onPressed: _resetFilters,
                        child: const Text('Limpar'),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 18),
              AnimatedPageEntry(
                child: _AnalyticsSummary(
                  income: incomeTotal,
                  expenses: expenseTotal,
                  balance: balance,
                  averageBalance: averageBalance,
                  entryCount: entries.length,
                ),
              ),
              const SizedBox(height: 22),
              AnimatedPageEntry(
                delay: const Duration(milliseconds: 80),
                child: _MonthlyChart(values: monthlyTotals),
              ),
              const SizedBox(height: 22),
              AnimatedPageEntry(
                delay: const Duration(milliseconds: 160),
                child: _CategoryBreakdown(
                  values: categoryTotals,
                  total: categoryTotal,
                  incomeMode: incomeBreakdown,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnalyticsSummary extends StatelessWidget {
  const _AnalyticsSummary({
    required this.income,
    required this.expenses,
    required this.balance,
    required this.averageBalance,
    required this.entryCount,
  });

  final Money income;
  final Money expenses;
  final Money balance;
  final Money averageBalance;
  final int entryCount;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      gradient: const LinearGradient(
        colors: [AppColors.primary, AppColors.primaryContainer],
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
        const Row(
          children: [
            Icon(
              Icons.account_balance_wallet_outlined,
              color: Color(0xFFDAD7FF),
            ),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Saldo previsto no período',
                style: TextStyle(color: Color(0xFFDAD7FF), fontSize: 14),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.centerLeft,
          child: Text(
            balance.format(),
            style: TextStyle(
              color: balance.isNegative
                  ? const Color(0xFFFFDAD6)
                  : Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _SummaryDetail(
                label: 'Receitas',
                value: income.format(),
                valueColor: const Color(0xFF99EFE5),
              ),
            ),
            Container(width: 1, height: 36, color: const Color(0x55DAD7FF)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _SummaryDetail(
                  label: 'Despesas',
                  value: expenses.format(),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Expanded(
              child: _SummaryDetail(
                label: 'Média de saldo mensal',
                value: averageBalance.format(),
              ),
            ),
            Container(width: 1, height: 36, color: const Color(0x55DAD7FF)),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: _SummaryDetail(
                  label: 'Lançamentos',
                  value: '$entryCount',
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

class _SummaryDetail extends StatelessWidget {
  const _SummaryDetail({
    required this.label,
    required this.value,
    this.valueColor = Colors.white,
  });

  final String label;
  final String value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(color: Color(0xFFDAD7FF), fontSize: 11),
      ),
      const SizedBox(height: 3),
      FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          value,
          style: TextStyle(
            color: valueColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

class _MonthlyChart extends StatelessWidget {
  const _MonthlyChart({required this.values});

  final List<_MonthTotal> values;

  @override
  Widget build(BuildContext context) {
    final maxCents = values.fold<int>(0, (maximum, value) {
      final monthMaximum = value.income.cents > value.expenses.cents
          ? value.income.cents
          : value.expenses.cents;
      return monthMaximum > maximum ? monthMaximum : maximum;
    });
    return _AnalyticsCard(
      title: 'Evolução mensal',
      subtitle: 'Receitas e despesas em cada mês do período',
      icon: Icons.bar_chart_rounded,
      child: Column(
        children: [
          const Row(
            children: [
              _AnalysisLegend(color: AppColors.secondary, label: 'Receitas'),
              SizedBox(width: 16),
              _AnalysisLegend(color: AppColors.primary, label: 'Despesas'),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 170,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (final value in values)
                  Expanded(
                    child: Tooltip(
                      message:
                          '${DateFormat('MMMM y', 'pt_BR').format(value.month)} · Receitas: ${value.income.format()} · Despesas: ${value.expenses.format()}',
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                _AnalysisBar(
                                  color: AppColors.secondary,
                                  fraction: maxCents == 0
                                      ? 0
                                      : value.income.cents / maxCents,
                                ),
                                const SizedBox(width: 2),
                                _AnalysisBar(
                                  color: AppColors.primary,
                                  fraction: maxCents == 0
                                      ? 0
                                      : value.expenses.cents / maxCents,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            DateFormat.MMM(
                              'pt_BR',
                            ).format(value.month).replaceAll('.', ''),
                            maxLines: 1,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AnalysisBar extends StatelessWidget {
  const _AnalysisBar({required this.color, required this.fraction});

  final Color color;
  final double fraction;

  @override
  Widget build(BuildContext context) => Flexible(
    child: Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: fraction == 0 ? .035 : (.12 + fraction * .88),
        widthFactor: .7,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 24),
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(6)),
          ),
        ),
      ),
    ),
  );
}

class _AnalysisLegend extends StatelessWidget {
  const _AnalysisLegend({required this.color, required this.label});

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

class _CategoryBreakdown extends StatelessWidget {
  const _CategoryBreakdown({
    required this.values,
    required this.total,
    required this.incomeMode,
  });

  final List<_CategoryTotal> values;
  final Money total;
  final bool incomeMode;

  @override
  Widget build(BuildContext context) => _AnalyticsCard(
    title: 'Por categoria',
    subtitle: incomeMode
        ? 'De onde vieram as receitas do período'
        : 'Onde as despesas estão mais concentradas',
    icon: Icons.donut_small_rounded,
    child: values.isEmpty
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 26),
            child: Column(
              children: [
                Icon(
                  Icons.insights_outlined,
                  size: 38,
                  color: AppColors.textMuted,
                ),
                SizedBox(height: 10),
                Text(
                  'Nenhum lançamento encontrado com esses filtros.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ],
            ),
          )
        : Column(
            children: [
              for (final entry in values.take(6).indexed) ...[
                _CategoryRow(
                  value: entry.$2,
                  total: total,
                  color: _chartColors[entry.$1 % _chartColors.length],
                ),
                if (entry.$1 < values.take(6).length - 1)
                  const SizedBox(height: 16),
              ],
            ],
          ),
  );
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow({
    required this.value,
    required this.total,
    required this.color,
  });

  final _CategoryTotal value;
  final Money total;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final fraction = total.isZero ? 0.0 : value.amount.cents / total.cents;
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value.category,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ),
            Text(
              value.amount.format(),
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 34,
              child: Text(
                '${(fraction * 100).round()}%',
                textAlign: TextAlign.right,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 7),
        ClipRRect(
          borderRadius: BorderRadius.circular(99),
          child: LinearProgressIndicator(
            value: fraction.clamp(0, 1),
            minHeight: 7,
            color: color,
            backgroundColor: AppColors.surfaceContainer,
          ),
        ),
      ],
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  const _AnalyticsCard({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.child,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: AppColors.surfaceContainer,
              child: Icon(icon, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        child,
      ],
    ),
  );
}

class _FilterPill extends StatelessWidget {
  const _FilterPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.surfaceContainer,
      borderRadius: BorderRadius.circular(999),
      border: Border.all(color: AppColors.outline),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 6),
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
        ),
      ],
    ),
  );
}

class _AnalyticsSelection {
  const _AnalyticsSelection({
    required this.period,
    required this.flowType,
    required this.category,
    required this.cardId,
  });

  final _AnalyticsPeriod period;
  final _FlowType flowType;
  final String? category;
  final String? cardId;
}

class _DateBounds {
  const _DateBounds({required this.start, required this.end});

  final DateTime start;
  final DateTime end;
}

class _MonthTotal {
  const _MonthTotal({
    required this.month,
    required this.income,
    required this.expenses,
  });

  final DateTime month;
  final Money income;
  final Money expenses;
}

class _FlowEntry {
  const _FlowEntry({
    required this.type,
    required this.date,
    required this.amount,
    required this.category,
    this.cardId,
  });

  final _FlowType type;
  final DateTime date;
  final Money amount;
  final String category;
  final String? cardId;
}

class _CategoryTotal {
  const _CategoryTotal({required this.category, required this.amount});

  final String category;
  final Money amount;
}

const _chartColors = [
  AppColors.primary,
  AppColors.secondary,
  Color(0xFF6B5FD3),
  Color(0xFF2A9D8F),
  Color(0xFFE08B3E),
  Color(0xFF8A5A88),
];

String _periodLabel(_AnalyticsPeriod period) => switch (period) {
  _AnalyticsPeriod.currentMonth => 'Este mês',
  _AnalyticsPeriod.lastThreeMonths => 'Últimos 3 meses',
  _AnalyticsPeriod.lastSixMonths => 'Últimos 6 meses',
  _AnalyticsPeriod.currentYear => 'Ano atual',
};

String _flowTypeLabel(_FlowType type) => switch (type) {
  _FlowType.all => 'Todos os tipos',
  _FlowType.income => 'Receitas',
  _FlowType.expenses => 'Outras despesas',
  _FlowType.cards => 'Cartões',
  _FlowType.loans => 'Empréstimos',
};

_DateBounds _periodBounds(_AnalyticsPeriod period, DateTime now) {
  final end = DateTime(now.year, now.month + 1);
  final start = switch (period) {
    _AnalyticsPeriod.currentMonth => DateTime(now.year, now.month),
    _AnalyticsPeriod.lastThreeMonths => DateTime(now.year, now.month - 2),
    _AnalyticsPeriod.lastSixMonths => DateTime(now.year, now.month - 5),
    _AnalyticsPeriod.currentYear => DateTime(now.year),
  };
  return _DateBounds(start: start, end: end);
}

List<DateTime> _monthsBetween(DateTime start, DateTime end) {
  final months = <DateTime>[];
  var current = DateTime(start.year, start.month);
  while (current.isBefore(end)) {
    months.add(current);
    current = DateTime(current.year, current.month + 1);
  }
  return months;
}

Money _sumMoney(Iterable<Money> values) =>
    values.fold(const Money.zero(), (total, value) => total + value);

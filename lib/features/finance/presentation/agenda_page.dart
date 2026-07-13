import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';
import '../domain/cash_flow_forecast.dart';
import '../domain/finance_models.dart';
import '../domain/loan_agenda_entry.dart';
import 'cash_flow_action_dialogs.dart';
import 'cash_flow_labels.dart';

enum _AgendaFilter { all, income, expenses, invoices, loans }

enum _AgendaAction { markAsCompleted, delete }

class AgendaPage extends ConsumerStatefulWidget {
  const AgendaPage({super.key});

  @override
  ConsumerState<AgendaPage> createState() => _AgendaPageState();
}

class _AgendaPageState extends ConsumerState<AgendaPage> {
  late DateTime _selectedMonth;
  _AgendaFilter _filter = _AgendaFilter.all;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectedMonth = DateTime(now.year, now.month);
  }

  void _changeMonth(int offset) {
    setState(() {
      _selectedMonth = DateTime(
        _selectedMonth.year,
        _selectedMonth.month + offset,
      );
    });
  }

  Future<void> _markAsCompleted(CashFlowEntry entry) async {
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCashFlowStatus(entry.id, CashFlowStatus.confirmed);
      if (mounted) {
        showSuccessMessage(
          context,
          entry.isIncome
              ? 'Entrada marcada como recebida.'
              : 'Despesa marcada como paga.',
        );
      }
    } catch (_) {
      if (mounted) {
        await _showActionError(
          entry.isIncome
              ? 'Não foi possível confirmar a entrada.'
              : 'Não foi possível confirmar a despesa.',
        );
      }
    }
  }

  Future<void> _deleteEntry(CashFlowEntry entry) async {
    var scope = RecurrenceScope.single;
    if (entry.recurrenceSeriesId != null) {
      final selectedScope = await showCashFlowScopePicker(
        context,
        action: CashFlowSeriesAction.delete,
      );
      if (selectedScope == null || !mounted) return;
      scope = selectedScope;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(entry.isIncome ? 'Excluir entrada?' : 'Excluir despesa?'),
        content: Text(
          entry.recurrenceSeriesId == null
              ? '“${entry.description}” será excluído permanentemente e os totais serão atualizados.'
              : '${recurrenceScopeLabel(scope)} de “${entry.description}” será excluído permanentemente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir permanentemente'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deleteCashFlowEntry(entry.id, scope);
      if (mounted) showSuccessMessage(context, 'Lançamento excluído.');
    } catch (_) {
      if (mounted) {
        await _showActionError('Não foi possível excluir o lançamento.');
      }
    }
  }

  Future<void> _showActionError(String fallback) => showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Não foi possível concluir'),
      content: SelectableText(
        ref.read(financeControllerProvider).errorMessage ?? fallback,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Entendi'),
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final monthEnd = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0);
    final forecast = monthEnd.isBefore(today)
        ? null
        : finance.cashFlowForecast(
            referenceDate: today,
            horizonDays: monthEnd.difference(today).inDays,
          );
    final balanceAfterByEvent = {
      if (forecast != null)
        for (final line in forecast.lines) line.event.id: line.balanceAfter,
    };
    final loanEntries = loanAgendaEntriesForMonth(
      loans: finance.loans,
      installments: finance.loanInstallments,
      month: _selectedMonth,
    );
    final items = <_AgendaItem>[
      if (_filter == _AgendaFilter.all || _filter == _AgendaFilter.invoices)
        for (final invoice in finance.invoices)
          if (_isSameMonth(invoice.dueDate, _selectedMonth))
            _AgendaItem.invoice(invoice),
      if (_filter == _AgendaFilter.all || _filter == _AgendaFilter.loans)
        for (final entry in loanEntries) _AgendaItem.loan(entry),
      if (_filter == _AgendaFilter.all ||
          _filter == _AgendaFilter.income ||
          _filter == _AgendaFilter.expenses)
        for (final entry in finance.cashFlowEntries)
          if (entry.status != CashFlowStatus.cancelled &&
              _isSameMonth(entry.occurredAt, _selectedMonth) &&
              (_filter != _AgendaFilter.income || entry.isIncome) &&
              (_filter != _AgendaFilter.expenses || !entry.isIncome))
            _AgendaItem.cashFlow(
              entry,
              relatedCard: _findRelatedCard(entry, finance),
            ),
    ]..sort((a, b) => a.date.compareTo(b.date));
    final groupedItems = <DateTime, List<_AgendaItem>>{};
    for (final item in items) {
      final day = DateTime(item.date.year, item.date.month, item.date.day);
      groupedItems.putIfAbsent(day, () => []).add(item);
    }
    final monthLabel = toBeginningOfSentenceCase(
      DateFormat('MMMM \'de\' y', 'pt_BR').format(_selectedMonth),
    );

    return RefreshIndicator(
      onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: AppContent(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Agenda', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.xxs),
              const Text('O que entra e sai, organizado por data.'),
              const SizedBox(height: AppSpacing.md),
              _MonthSelector(
                monthLabel: monthLabel,
                itemCount: items.length,
                onPrevious: () => _changeMonth(-1),
                onNext: () => _changeMonth(1),
              ),
              if (forecast != null) ...[
                const SizedBox(height: AppSpacing.xs),
                _AgendaProjectionSummary(
                  forecast: forecast,
                  selectedMonth: _selectedMonth,
                  hasAccounts: finance.accounts.isNotEmpty,
                ),
              ],
              const SizedBox(height: AppSpacing.sm),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    for (final filter in _AgendaFilter.values) ...[
                      _FilterChip(
                        label: _filterLabel(filter),
                        selected: _filter == filter,
                        onSelected: () => setState(() => _filter = filter),
                      ),
                      if (filter != _AgendaFilter.values.last)
                        const SizedBox(width: 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              const SectionHeading(title: 'Linha do tempo'),
              const SizedBox(height: AppSpacing.xs),
              if (items.isEmpty)
                _EmptyMonth(selectedMonth: _selectedMonth)
              else
                for (final group in groupedItems.entries) ...[
                  _AgendaDayHeading(date: group.key),
                  const SizedBox(height: AppSpacing.xs),
                  AppSurfaceCard(
                    padding: EdgeInsets.zero,
                    child: Column(
                      children: [
                        for (final indexed in group.value.indexed) ...[
                          _AgendaCard(
                            item: indexed.$2,
                            canEdit: finance.canEdit,
                            balanceAfter:
                                balanceAfterByEvent[indexed.$2.forecastEventId],
                            onDelete: indexed.$2.cashFlowEntry == null
                                ? null
                                : () => _deleteEntry(indexed.$2.cashFlowEntry!),
                            onMarkAsCompleted:
                                indexed.$2.cashFlowEntry?.status ==
                                    CashFlowStatus.scheduled
                                ? () => _markAsCompleted(
                                    indexed.$2.cashFlowEntry!,
                                  )
                                : null,
                          ),
                          if (indexed.$1 < group.value.length - 1)
                            const Divider(height: 1, indent: 68),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                ],
            ],
          ),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.monthLabel,
    required this.itemCount,
    required this.onPrevious,
    required this.onNext,
  });

  final String monthLabel;
  final int itemCount;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => AppSurfaceCard(
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.xxs,
      vertical: AppSpacing.xs,
    ),
    child: Row(
      children: [
        IconButton(
          tooltip: 'Mês anterior',
          color: AppColors.primary,
          onPressed: onPrevious,
          icon: const Icon(Icons.chevron_left_rounded),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                monthLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                '$itemCount ${itemCount == 1 ? 'lançamento' : 'lançamentos'}',
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        IconButton(
          tooltip: 'Próximo mês',
          color: AppColors.primary,
          onPressed: onNext,
          icon: const Icon(Icons.chevron_right_rounded),
        ),
      ],
    ),
  );
}

class _AgendaDayHeading extends StatelessWidget {
  const _AgendaDayHeading({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final today = DateUtils.dateOnly(DateTime.now());
    final tomorrow = today.add(const Duration(days: 1));
    final label = DateUtils.isSameDay(date, today)
        ? 'Hoje'
        : DateUtils.isSameDay(date, tomorrow)
        ? 'Amanhã'
        : toBeginningOfSentenceCase(
            DateFormat("EEEE, d 'de' MMMM", 'pt_BR').format(date),
          );
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: AppSpacing.xs),
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }
}

class _AgendaProjectionSummary extends StatelessWidget {
  const _AgendaProjectionSummary({
    required this.forecast,
    required this.selectedMonth,
    required this.hasAccounts,
  });

  final CashFlowForecast forecast;
  final DateTime selectedMonth;
  final bool hasAccounts;

  @override
  Widget build(BuildContext context) {
    final monthStart = DateTime(selectedMonth.year, selectedMonth.month);
    final monthEnd = DateTime(selectedMonth.year, selectedMonth.month + 1, 0);
    final monthLines = forecast.lines
        .where((line) => _isSameMonth(line.projectedAt, selectedMonth))
        .toList();
    var income = const Money.zero();
    var expenses = const Money.zero();
    var closing = forecast.openingBalance;
    var balanceAtMonthStart = forecast.openingBalance;
    for (final line in forecast.lines) {
      if (line.projectedAt.isBefore(monthStart)) {
        balanceAtMonthStart = line.balanceAfter;
      }
    }
    var lowest = balanceAtMonthStart;
    var lowestDate = monthStart;
    for (final line in forecast.lines) {
      if (!line.projectedAt.isAfter(monthEnd)) closing = line.balanceAfter;
      if (line.projectedAt.isBefore(monthStart) ||
          line.projectedAt.isAfter(monthEnd)) {
        continue;
      }
      if (line.event.isIncome) {
        income += line.event.amount;
      } else {
        expenses += line.event.amount;
      }
      if (line.balanceAfter.cents < lowest.cents) {
        lowest = line.balanceAfter;
        lowestDate = line.projectedAt;
      }
    }
    final risk = lowest.isNegative;
    return AppSurfaceCard(
      color: risk ? const Color(0xFFFFF1F0) : AppColors.surfaceLow,
      onTap: () => context.push('/forecast'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                risk ? Icons.warning_amber_rounded : Icons.timeline_rounded,
                color: risk ? AppColors.error : AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: AppSpacing.xs),
              Expanded(
                child: Text(
                  risk ? 'Atenção à projeção' : 'Saldo no fim do mês',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  closing.format(),
                  style: TextStyle(
                    color: closing.isNegative
                        ? AppColors.error
                        : AppColors.primary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.xxs),
              const Icon(Icons.chevron_right_rounded, size: 20),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Ainda entra ${income.format()}  •  Ainda sai ${expenses.format()}',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: AppSpacing.xxs),
          Text(
            !hasAccounts
                ? 'Cadastre uma conta para partir do saldo real.'
                : risk
                ? 'Menor saldo: ${lowest.format()} em ${DateFormat('dd/MM', 'pt_BR').format(lowestDate)}.'
                : '${monthLines.length} ${monthLines.length == 1 ? 'compromisso pendente' : 'compromissos pendentes'} neste mês.',
            style: TextStyle(
              color: risk ? AppColors.error : AppColors.textMuted,
              fontSize: 12,
              fontWeight: risk ? FontWeight.w700 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  final String label;
  final bool selected;
  final VoidCallback onSelected;

  @override
  Widget build(BuildContext context) => ChoiceChip(
    label: Text(label),
    selected: selected,
    onSelected: (_) => onSelected(),
  );
}

class _AgendaCard extends StatelessWidget {
  const _AgendaCard({
    required this.item,
    required this.canEdit,
    this.balanceAfter,
    this.onDelete,
    this.onMarkAsCompleted,
  });

  final _AgendaItem item;
  final bool canEdit;
  final Money? balanceAfter;
  final VoidCallback? onDelete;
  final VoidCallback? onMarkAsCompleted;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: item.route == null ? null : () => context.push(item.route!),
    child: ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 84),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.sm,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: item.backgroundColor,
              child: Icon(item.icon, color: item.foregroundColor, size: 20),
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${item.type} • ${item.subtitle}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xxs,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      StatusPill(label: item.status, color: item.statusColor),
                      Text(
                        '${item.isIncome ? '+' : '−'} ${item.amount.format()}',
                        style: TextStyle(
                          color: item.amountColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  if (balanceAfter != null) ...[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      'Saldo após: ${balanceAfter!.format()}',
                      style: TextStyle(
                        color: balanceAfter!.isNegative
                            ? AppColors.error
                            : AppColors.textMuted,
                        fontSize: 11,
                        fontWeight: balanceAfter!.isNegative
                            ? FontWeight.w700
                            : FontWeight.normal,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (canEdit && (onDelete != null || onMarkAsCompleted != null))
              PopupMenuButton<_AgendaAction>(
                tooltip: 'Ações do lançamento',
                onSelected: (action) {
                  switch (action) {
                    case _AgendaAction.markAsCompleted:
                      onMarkAsCompleted?.call();
                      break;
                    case _AgendaAction.delete:
                      onDelete?.call();
                      break;
                  }
                },
                itemBuilder: (context) => [
                  if (onMarkAsCompleted != null)
                    PopupMenuItem(
                      value: _AgendaAction.markAsCompleted,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.check_circle_outline_rounded),
                        title: Text(
                          item.isIncome
                              ? 'Marcar como recebida'
                              : 'Marcar como paga',
                        ),
                      ),
                    ),
                  if (onDelete != null)
                    const PopupMenuItem(
                      value: _AgendaAction.delete,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.delete_outline_rounded,
                          color: AppColors.error,
                        ),
                        title: Text('Excluir lançamento'),
                      ),
                    ),
                ],
              )
            else if (item.route != null)
              const Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Icon(Icons.chevron_right_rounded, size: 20),
              ),
          ],
        ),
      ),
    ),
  );
}

class _EmptyMonth extends StatelessWidget {
  const _EmptyMonth({required this.selectedMonth});

  final DateTime selectedMonth;

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
            'Nenhum lançamento em ${DateFormat.MMMM('pt_BR').format(selectedMonth)}.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

class _AgendaItem {
  const _AgendaItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.type,
    required this.amount,
    required this.status,
    required this.statusColor,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.isIncome,
    this.route,
    this.relatedCard,
    this.cashFlowEntry,
    this.forecastEventId,
  });

  factory _AgendaItem.invoice(InvoiceSummary invoice) => _AgendaItem(
    date: invoice.dueDate,
    title: 'Fatura ${invoice.cardName}',
    subtitle:
        'Vence ${DateFormat("d 'de' MMMM", 'pt_BR').format(invoice.dueDate)}',
    type: 'Fatura',
    amount: invoice.pending,
    status: _invoiceStatusLabel(invoice.status, invoice.dueDate),
    statusColor: _invoiceStatusColor(invoice.status, invoice.dueDate),
    route: '/invoice/${invoice.id}',
    relatedCard: invoice.cardName,
    backgroundColor: AppColors.surfaceContainer,
    foregroundColor: AppColors.primary,
    isIncome: false,
    forecastEventId: 'invoice:${invoice.id}',
  );

  factory _AgendaItem.loan(LoanAgendaEntry entry) => _AgendaItem(
    date: entry.installment.dueDate,
    title: entry.loan.description,
    subtitle:
        '${entry.loan.lender} • Parcela ${entry.installment.number}/${entry.loan.installmentCount}',
    type: 'Empréstimo',
    amount: entry.installment.total,
    status: _loanInstallmentStatusLabel(
      entry.installment.status,
      entry.installment.dueDate,
    ),
    statusColor: _loanInstallmentStatusColor(
      entry.installment.status,
      entry.installment.dueDate,
    ),
    route: '/loans/${entry.loan.id}',
    backgroundColor: AppColors.secondaryContainer,
    foregroundColor: AppColors.secondary,
    isIncome: false,
    forecastEventId: 'loan-installment:${entry.installment.id}',
  );

  factory _AgendaItem.cashFlow(CashFlowEntry entry, {String? relatedCard}) =>
      _AgendaItem(
        date: entry.occurredAt,
        title: entry.description,
        subtitle: cashFlowPaymentMethodLabel(entry.paymentMethod),
        type: cashFlowKindLabel(entry.kind),
        amount: entry.amount,
        status: _cashFlowStatusLabel(entry),
        statusColor: _cashFlowStatusColor(entry),
        route: '/cash-flow/${entry.id}',
        relatedCard: relatedCard,
        backgroundColor: entry.isIncome
            ? AppColors.secondaryContainer
            : AppColors.surfaceContainer,
        foregroundColor: entry.isIncome
            ? AppColors.secondary
            : AppColors.primary,
        isIncome: entry.isIncome,
        cashFlowEntry: entry,
        forecastEventId: 'cash-flow:${entry.id}',
      );

  final DateTime date;
  final String title;
  final String subtitle;
  final String type;
  final Money amount;
  final String status;
  final Color statusColor;
  final String? route;
  final String? relatedCard;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool isIncome;
  final CashFlowEntry? cashFlowEntry;
  final String? forecastEventId;

  Color get amountColor => isIncome ? AppColors.secondary : AppColors.error;
  IconData get icon {
    final entry = cashFlowEntry;
    if (entry != null) return cashFlowKindIcon(entry.kind);
    if (route?.startsWith('/invoice/') == true) {
      return Icons.credit_card_outlined;
    }
    return Icons.account_balance_outlined;
  }
}

String? _findRelatedCard(CashFlowEntry entry, FinanceState finance) {
  if (entry.paymentMethod != CashFlowPaymentMethod.creditCard &&
      entry.kind != CashFlowKind.cardPurchase) {
    return null;
  }
  final sourceId = entry.sourceEntityId;
  if (sourceId != null) {
    for (final purchase in finance.purchases) {
      if (purchase.id != sourceId) continue;
      for (final card in finance.cards) {
        if (card.id == purchase.cardId) return card.nickname;
      }
    }
  }
  return 'Cartão de crédito';
}

bool _isSameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

String _filterLabel(_AgendaFilter filter) => switch (filter) {
  _AgendaFilter.all => 'Todos',
  _AgendaFilter.income => 'Entradas',
  _AgendaFilter.expenses => 'Despesas',
  _AgendaFilter.invoices => 'Faturas',
  _AgendaFilter.loans => 'Empréstimos',
};

String _invoiceStatusLabel(InvoiceStatus status, [DateTime? dueDate]) {
  if (dueDate != null &&
      dueDate.isBefore(_today()) &&
      (status == InvoiceStatus.open ||
          status == InvoiceStatus.closed ||
          status == InvoiceStatus.partiallyPaid)) {
    return 'Vencida';
  }
  return switch (status) {
    InvoiceStatus.open || InvoiceStatus.closed => 'Pendente',
    InvoiceStatus.partiallyPaid => 'Parcialmente paga',
    InvoiceStatus.paid => 'Paga',
    InvoiceStatus.overdue => 'Vencida',
    InvoiceStatus.cancelled => 'Cancelada',
  };
}

Color _invoiceStatusColor(InvoiceStatus status, DateTime dueDate) {
  if (dueDate.isBefore(_today()) &&
      status != InvoiceStatus.paid &&
      status != InvoiceStatus.cancelled) {
    return AppColors.error;
  }
  return switch (status) {
    InvoiceStatus.paid => AppColors.secondary,
    InvoiceStatus.overdue || InvoiceStatus.cancelled => AppColors.error,
    _ => AppColors.primary,
  };
}

String _loanInstallmentStatusLabel(
  LoanInstallmentStatus status,
  DateTime dueDate,
) {
  if (dueDate.isBefore(_today()) &&
      status != LoanInstallmentStatus.paid &&
      status != LoanInstallmentStatus.cancelled) {
    return 'Vencida';
  }
  return switch (status) {
    LoanInstallmentStatus.planned || LoanInstallmentStatus.open => 'Pendente',
    LoanInstallmentStatus.partiallyPaid => 'Parcialmente paga',
    LoanInstallmentStatus.paid => 'Paga',
    LoanInstallmentStatus.overdue => 'Vencida',
    LoanInstallmentStatus.cancelled => 'Cancelada',
  };
}

Color _loanInstallmentStatusColor(
  LoanInstallmentStatus status,
  DateTime dueDate,
) {
  if (dueDate.isBefore(_today()) &&
      status != LoanInstallmentStatus.paid &&
      status != LoanInstallmentStatus.cancelled) {
    return AppColors.error;
  }
  return switch (status) {
    LoanInstallmentStatus.paid => AppColors.secondary,
    LoanInstallmentStatus.overdue ||
    LoanInstallmentStatus.cancelled => AppColors.error,
    _ => AppColors.primary,
  };
}

String _cashFlowStatusLabel(CashFlowEntry entry) {
  if (entry.status == CashFlowStatus.scheduled &&
      entry.occurredAt.isBefore(_today())) {
    return entry.isIncome ? 'Atrasada' : 'Vencida';
  }
  return switch (entry.status) {
    CashFlowStatus.scheduled => entry.isIncome ? 'Prevista' : 'Pendente',
    CashFlowStatus.confirmed => entry.isIncome ? 'Recebida' : 'Paga',
    CashFlowStatus.cancelled => 'Cancelada',
  };
}

Color _cashFlowStatusColor(CashFlowEntry entry) {
  if (entry.status == CashFlowStatus.scheduled &&
      entry.occurredAt.isBefore(_today())) {
    return AppColors.error;
  }
  return switch (entry.status) {
    CashFlowStatus.scheduled => AppColors.primary,
    CashFlowStatus.confirmed => AppColors.secondary,
    CashFlowStatus.cancelled => AppColors.error,
  };
}

DateTime _today() {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
}

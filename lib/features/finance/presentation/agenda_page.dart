import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

enum _AgendaFilter { all, invoices, loans }

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

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final items = <_AgendaItem>[
      if (_filter != _AgendaFilter.loans)
        for (final invoice in finance.invoices)
          if (_isSameMonth(invoice.dueDate, _selectedMonth))
            _AgendaItem.invoice(invoice),
      if (_filter != _AgendaFilter.invoices)
        for (final loan in finance.loans)
          if (!loan.outstandingBalance.isZero)
            _AgendaItem.loan(loan, _dateForDay(_selectedMonth, loan.dueDay)),
    ]..sort((a, b) => a.date.compareTo(b.date));
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
              const SizedBox(height: 5),
              const Text('Tudo que precisa da atenção de vocês.'),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 18,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    IconButton(
                      tooltip: 'Mês anterior',
                      color: Colors.white,
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    const CircleAvatar(
                      backgroundColor: Color(0x33FFFFFF),
                      child: Icon(
                        Icons.calendar_month_rounded,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            monthLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                            ),
                          ),
                          Text(
                            '${items.length} ${items.length == 1 ? 'compromisso financeiro' : 'compromissos financeiros'}',
                            style: const TextStyle(color: Color(0xFFDAD7FF)),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Próximo mês',
                      color: Colors.white,
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _FilterChip(
                      label: 'Todos',
                      selected: _filter == _AgendaFilter.all,
                      onSelected: () =>
                          setState(() => _filter = _AgendaFilter.all),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Faturas',
                      selected: _filter == _AgendaFilter.invoices,
                      onSelected: () =>
                          setState(() => _filter = _AgendaFilter.invoices),
                    ),
                    const SizedBox(width: 8),
                    _FilterChip(
                      label: 'Empréstimos',
                      selected: _filter == _AgendaFilter.loans,
                      onSelected: () =>
                          setState(() => _filter = _AgendaFilter.loans),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const SectionHeading(title: 'Compromissos do mês'),
              const SizedBox(height: 12),
              if (items.isEmpty)
                Card(
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
                          'Nenhum compromisso em ${DateFormat.MMMM('pt_BR').format(_selectedMonth)}.',
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              else
                for (final item in items) ...[
                  _AgendaCard(item: item),
                  const SizedBox(height: 12),
                ],
            ],
          ),
        ),
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
  const _AgendaCard({required this.item});

  final _AgendaItem item;

  @override
  Widget build(BuildContext context) {
    final month = DateFormat.MMM('pt_BR').format(item.date).toUpperCase();
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () => context.push(item.route),
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Row(
            children: [
              Container(
                width: 52,
                height: 58,
                decoration: BoxDecoration(
                  color: item.backgroundColor,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${item.date.day}',
                      style: TextStyle(
                        color: item.foregroundColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(month, style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(item.subtitle),
                    const SizedBox(height: 5),
                    StatusPill(label: item.status),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    item.amount.format(),
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const Icon(Icons.chevron_right_rounded),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AgendaItem {
  const _AgendaItem({
    required this.date,
    required this.title,
    required this.subtitle,
    required this.amount,
    required this.status,
    required this.route,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  factory _AgendaItem.invoice(InvoiceSummary invoice) => _AgendaItem(
    date: invoice.dueDate,
    title: invoice.cardName,
    subtitle:
        'Vence ${DateFormat("d 'de' MMMM", 'pt_BR').format(invoice.dueDate)}',
    amount: invoice.pending,
    status: _invoiceStatusLabel(invoice.status),
    route: '/invoice/${invoice.id}',
    backgroundColor: AppColors.surfaceContainer,
    foregroundColor: AppColors.primary,
  );

  factory _AgendaItem.loan(LoanContract loan, DateTime date) => _AgendaItem(
    date: date,
    title: loan.description,
    subtitle: loan.lender,
    amount: loan.installmentAmount,
    status: 'Pendente',
    route: '/loans',
    backgroundColor: AppColors.secondaryContainer,
    foregroundColor: AppColors.secondary,
  );

  final DateTime date;
  final String title;
  final String subtitle;
  final Money amount;
  final String status;
  final String route;
  final Color backgroundColor;
  final Color foregroundColor;
}

bool _isSameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

DateTime _dateForDay(DateTime month, int day) {
  final lastDay = DateUtils.getDaysInMonth(month.year, month.month);
  return DateTime(month.year, month.month, day.clamp(1, lastDay));
}

String _invoiceStatusLabel(InvoiceStatus status) => switch (status) {
  InvoiceStatus.open || InvoiceStatus.closed => 'Pendente',
  InvoiceStatus.partiallyPaid => 'Parcialmente paga',
  InvoiceStatus.paid => 'Paga',
  InvoiceStatus.overdue => 'Vencida',
  InvoiceStatus.cancelled => 'Cancelada',
};

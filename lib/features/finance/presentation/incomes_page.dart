import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';

class IncomesPage extends ConsumerStatefulWidget {
  const IncomesPage({super.key});

  @override
  ConsumerState<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends ConsumerState<IncomesPage> {
  late DateTime _month;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month);
  }

  void _changeMonth(int offset) {
    setState(() => _month = DateTime(_month.year, _month.month + offset));
  }

  Future<void> _markReceived(CashFlowEntry income) async {
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCashFlowStatus(income.id, CashFlowStatus.confirmed);
      if (mounted) {
        showSuccessMessage(context, 'Receita marcada como recebida.');
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível atualizar a receita.')),
      );
    }
  }

  Future<void> _cancel(CashFlowEntry income) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir esta receita?'),
        content: Text(
          'A ocorrência “${income.description}” será removida deste mês. As outras ocorrências mensais serão mantidas.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Manter'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFFFDAD6),
              foregroundColor: const Color(0xFF93000A),
            ),
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deleteCashFlowEntry(income.id, RecurrenceScope.single);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Não foi possível excluir a receita.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final entries =
        finance.cashFlowEntries
            .where(
              (income) =>
                  income.isIncome &&
                  income.status != CashFlowStatus.cancelled &&
                  income.occurredAt.year == _month.year &&
                  income.occurredAt.month == _month.month,
            )
            .toList()
          ..sort((a, b) => a.occurredAt.compareTo(b.occurredAt));
    final expected = _sumMoney(entries.map((income) => income.amount));
    final received = _sumMoney(
      entries
          .where((income) => income.status == CashFlowStatus.confirmed)
          .map((income) => income.amount),
    );
    final monthLabel = toBeginningOfSentenceCase(
      DateFormat('MMMM y', 'pt_BR').format(_month),
    );

    return Scaffold(
      appBar: const BrandAppBar(title: 'Receitas', showBack: true),
      floatingActionButton: finance.canEdit
          ? FloatingActionButton.extended(
              onPressed: () => context.push('/new-income'),
              icon: const Icon(Icons.add_rounded),
              label: const Text('Nova receita'),
            )
          : null,
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AppContent(
            maxWidth: 700,
            padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    IconButton(
                      tooltip: 'Mês anterior',
                      onPressed: () => _changeMonth(-1),
                      icon: const Icon(Icons.chevron_left_rounded),
                    ),
                    Expanded(
                      child: Text(
                        monthLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton(
                      tooltip: 'Próximo mês',
                      onPressed: () => _changeMonth(1),
                      icon: const Icon(Icons.chevron_right_rounded),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF006A63), Color(0xFF008F84)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'RECEITAS PREVISTAS',
                        style: TextStyle(
                          color: Color(0xFFB7FFF5),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        expected.format(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text(
                        'Recebido: ${received.format()}',
                        style: const TextStyle(color: Color(0xFFB7FFF5)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Entradas do mês',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 12),
                if (entries.isEmpty)
                  Container(
                    padding: const EdgeInsets.all(28),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: AppColors.outline),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.savings_outlined,
                          size: 42,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Nenhuma receita prevista para este mês.',
                          textAlign: TextAlign.center,
                        ),
                        if (finance.canEdit) ...[
                          const SizedBox(height: 16),
                          TextButton.icon(
                            onPressed: () => context.push('/new-income'),
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('Adicionar receita'),
                          ),
                        ],
                      ],
                    ),
                  )
                else
                  for (final income in entries) ...[
                    _IncomeCard(
                      income: income,
                      canEdit: finance.canEdit,
                      onMarkReceived: () => _markReceived(income),
                      onCancel: () => _cancel(income),
                    ),
                    const SizedBox(height: 10),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _IncomeCard extends StatelessWidget {
  const _IncomeCard({
    required this.income,
    required this.canEdit,
    required this.onMarkReceived,
    required this.onCancel,
  });

  final CashFlowEntry income;
  final bool canEdit;
  final VoidCallback onMarkReceived;
  final VoidCallback onCancel;

  @override
  Widget build(BuildContext context) {
    final received = income.status == CashFlowStatus.confirmed;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: received
                ? AppColors.secondaryContainer
                : AppColors.surfaceContainer,
            child: Icon(
              received ? Icons.check_rounded : Icons.schedule_rounded,
              color: received ? AppColors.secondary : AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  income.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${income.categoryName ?? 'Sem categoria'} · ${DateFormat('dd/MM').format(income.occurredAt)}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: received
                        ? AppColors.secondaryContainer
                        : AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    received ? 'Recebida' : 'Prevista',
                    style: TextStyle(
                      color: received
                          ? AppColors.secondary
                          : AppColors.textMuted,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                income.amount.format(),
                style: const TextStyle(
                  color: AppColors.secondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              if (canEdit)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (!received)
                      IconButton(
                        tooltip: 'Marcar como recebida',
                        visualDensity: VisualDensity.compact,
                        onPressed: onMarkReceived,
                        icon: const Icon(
                          Icons.check_circle_outline_rounded,
                          color: AppColors.secondary,
                        ),
                      ),
                    IconButton(
                      tooltip: 'Excluir ocorrência',
                      visualDensity: VisualDensity.compact,
                      onPressed: onCancel,
                      icon: const Icon(Icons.delete_outline_rounded, size: 20),
                    ),
                  ],
                ),
            ],
          ),
        ],
      ),
    );
  }
}

Money _sumMoney(Iterable<Money> values) =>
    values.fold(const Money.zero(), (total, value) => total + value);

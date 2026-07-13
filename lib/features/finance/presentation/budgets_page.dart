import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/financial_planning.dart';

class BudgetsPage extends ConsumerStatefulWidget {
  const BudgetsPage({super.key});

  @override
  ConsumerState<BudgetsPage> createState() => _BudgetsPageState();
}

class _BudgetsPageState extends ConsumerState<BudgetsPage> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _moveMonth(int offset) =>
      setState(() => _month = DateTime(_month.year, _month.month + offset));

  Future<void> _openEditor({MonthlyBudget? budget}) async {
    final finance = ref.read(financeControllerProvider);
    if (finance.categories.isEmpty) return;
    final draft = await showModalBottomSheet<_BudgetDraft>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) =>
          _BudgetEditorSheet(categories: finance.categories, budget: budget),
    );
    if (draft == null || !mounted) return;
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .saveMonthlyBudget(
            category: draft.category,
            referenceMonth: _month,
            limit: draft.limit,
          );
      if (mounted) showSuccessMessage(context, 'Orçamento salvo.');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível salvar o orçamento.')),
        );
      }
    }
  }

  Future<void> _delete(MonthlyBudget budget) async {
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deleteMonthlyBudget(budget.id);
      if (mounted) showSuccessMessage(context, 'Orçamento removido.');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível remover o orçamento.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final progress = finance.budgetProgress(_month);
    final totalLimit = progress.fold(
      const Money.zero(),
      (total, item) => total + item.budget.limit,
    );
    final totalCommitted = progress.fold(
      const Money.zero(),
      (total, item) => total + item.committed,
    );
    final monthName = toBeginningOfSentenceCase(
      DateFormat('MMMM y', 'pt_BR').format(_month),
    );
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Orçamento mensal',
        showBack: true,
        actions: [
          if (finance.canEdit && finance.categories.isNotEmpty)
            IconButton(
              tooltip: 'Adicionar orçamento',
              onPressed: _openEditor,
              icon: const Icon(Icons.add_rounded),
            ),
          const SizedBox(width: 6),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(financeControllerProvider.notifier).refresh(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: AppContent(
            maxWidth: 760,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _MonthSelector(
                  label: monthName,
                  onPrevious: () => _moveMonth(-1),
                  onNext: () => _moveMonth(1),
                ),
                const SizedBox(height: 18),
                _BudgetSummary(limit: totalLimit, committed: totalCommitted),
                const SizedBox(height: 26),
                SectionHeading(
                  title: 'Limites por categoria',
                  actionLabel: finance.canEdit && finance.categories.isNotEmpty
                      ? 'Adicionar'
                      : null,
                  onAction: finance.canEdit && finance.categories.isNotEmpty
                      ? _openEditor
                      : null,
                ),
                const SizedBox(height: 6),
                const Text(
                  'Compras no cartão e outras saídas do mês entram no valor comprometido.',
                ),
                const SizedBox(height: 16),
                if (progress.isEmpty)
                  _EmptyBudgets(
                    hasCategories: finance.categories.isNotEmpty,
                    canEdit: finance.canEdit,
                    onAdd: _openEditor,
                  )
                else
                  for (final item in progress) ...[
                    _BudgetCard(
                      progress: item,
                      canEdit: finance.canEdit,
                      onEdit: () => _openEditor(budget: item.budget),
                      onDelete: () => _delete(item.budget),
                    ),
                    const SizedBox(height: 12),
                  ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MonthSelector extends StatelessWidget {
  const _MonthSelector({
    required this.label,
    required this.onPrevious,
    required this.onNext,
  });

  final String label;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: [
      IconButton(
        tooltip: 'Mês anterior',
        onPressed: onPrevious,
        icon: const Icon(Icons.chevron_left_rounded),
      ),
      Expanded(
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
      IconButton(
        tooltip: 'Próximo mês',
        onPressed: onNext,
        icon: const Icon(Icons.chevron_right_rounded),
      ),
    ],
  );
}

class _BudgetSummary extends StatelessWidget {
  const _BudgetSummary({required this.limit, required this.committed});

  final Money limit;
  final Money committed;

  @override
  Widget build(BuildContext context) {
    final available = limit - committed;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'DISPONÍVEL NO ORÇAMENTO',
            style: TextStyle(
              color: Color(0xFFDAD7FF),
              fontSize: 11,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 5),
          FittedBox(
            child: Text(
              available.format(),
              style: TextStyle(
                color: available.isNegative
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
                child: _SummaryValue(label: 'Limites', value: limit),
              ),
              Expanded(
                child: _SummaryValue(label: 'Comprometido', value: committed),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final Money value;

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
        child: Text(
          value.format(),
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    ],
  );
}

class _BudgetCard extends StatelessWidget {
  const _BudgetCard({
    required this.progress,
    required this.canEdit,
    required this.onEdit,
    required this.onDelete,
  });

  final BudgetProgress progress;
  final bool canEdit;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final color = progress.isExceeded ? AppColors.error : AppColors.primary;
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: progress.isExceeded ? AppColors.error : AppColors.outline,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: .1),
                child: Icon(Icons.category_outlined, color: color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      progress.budget.categoryName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '${progress.committed.format()} de ${progress.budget.limit.format()}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Text(
                '${(progress.usage * 100).round()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.w700),
              ),
              if (canEdit)
                PopupMenuButton<String>(
                  onSelected: (value) =>
                      value == 'edit' ? onEdit() : onDelete(),
                  itemBuilder: (_) => const [
                    PopupMenuItem(value: 'edit', child: Text('Editar limite')),
                    PopupMenuItem(value: 'delete', child: Text('Remover')),
                  ],
                ),
            ],
          ),
          const SizedBox(height: 14),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: LinearProgressIndicator(
              value: progress.usage.clamp(0, 1),
              minHeight: 9,
              color: color,
              backgroundColor: AppColors.surfaceContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            progress.isExceeded
                ? 'Limite excedido em ${Money.fromCents(progress.remaining.cents.abs()).format()}'
                : 'Restante: ${progress.remaining.format()}',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _EmptyBudgets extends StatelessWidget {
  const _EmptyBudgets({
    required this.hasCategories,
    required this.canEdit,
    required this.onAdd,
  });

  final bool hasCategories;
  final bool canEdit;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(28),
    decoration: BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(18),
    ),
    child: Column(
      children: [
        const Icon(
          Icons.donut_small_rounded,
          size: 44,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        Text(
          'Nenhum limite definido neste mês',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 6),
        Text(
          hasCategories
              ? 'Defina quanto pretende gastar em cada categoria.'
              : 'Cadastre uma categoria antes de criar um orçamento.',
          textAlign: TextAlign.center,
        ),
        if (canEdit && hasCategories) ...[
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: onAdd,
            icon: const Icon(Icons.add_rounded),
            label: const Text('Criar orçamento'),
          ),
        ],
      ],
    ),
  );
}

class _BudgetEditorSheet extends StatefulWidget {
  const _BudgetEditorSheet({required this.categories, this.budget});

  final List<String> categories;
  final MonthlyBudget? budget;

  @override
  State<_BudgetEditorSheet> createState() => _BudgetEditorSheetState();
}

class _BudgetEditorSheetState extends State<_BudgetEditorSheet> {
  late String _category =
      widget.budget?.categoryName ?? widget.categories.first;
  late Money _limit = widget.budget?.limit ?? const Money.zero();

  @override
  Widget build(BuildContext context) => SafeArea(
    child: SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        4,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            widget.budget == null ? 'Novo orçamento' : 'Editar orçamento',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 6),
          const Text('Defina o limite mensal para esta categoria.'),
          const SizedBox(height: 20),
          DropdownButtonFormField<String>(
            initialValue: _category,
            isExpanded: true,
            decoration: const InputDecoration(
              labelText: 'Categoria',
              prefixIcon: Icon(Icons.category_outlined),
            ),
            items: [
              for (final value in widget.categories)
                DropdownMenuItem(value: value, child: Text(value)),
            ],
            onChanged: widget.budget == null
                ? (value) {
                    if (value != null) _category = value;
                  }
                : null,
          ),
          const SizedBox(height: 16),
          CurrencyField(
            label: 'Limite mensal',
            initialCents: _limit.cents,
            onChanged: (value) => _limit = value,
          ),
          const SizedBox(height: 20),
          FilledButton.icon(
            onPressed: () {
              if (_limit.cents <= 0) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Informe um limite maior que zero.'),
                  ),
                );
                return;
              }
              Navigator.pop(
                context,
                _BudgetDraft(category: _category, limit: _limit),
              );
            },
            icon: const Icon(Icons.check_rounded),
            label: const Text('Salvar orçamento'),
          ),
        ],
      ),
    ),
  );
}

final class _BudgetDraft {
  const _BudgetDraft({required this.category, required this.limit});

  final String category;
  final Money limit;
}

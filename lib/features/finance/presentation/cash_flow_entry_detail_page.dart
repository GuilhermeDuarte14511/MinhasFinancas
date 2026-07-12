import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';
import 'cash_flow_action_dialogs.dart';
import 'cash_flow_labels.dart';

class CashFlowEntryDetailPage extends ConsumerStatefulWidget {
  const CashFlowEntryDetailPage({required this.entryId, super.key});

  final String entryId;

  @override
  ConsumerState<CashFlowEntryDetailPage> createState() =>
      _CashFlowEntryDetailPageState();
}

class _CashFlowEntryDetailPageState
    extends ConsumerState<CashFlowEntryDetailPage> {
  var _isSaving = false;

  Future<void> _confirm(CashFlowEntry entry) async {
    setState(() => _isSaving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCashFlowStatus(entry.id, CashFlowStatus.confirmed);
      if (mounted) {
        showSuccessMessage(
          context,
          entry.isIncome ? 'Recebimento confirmado.' : 'Pagamento confirmado.',
        );
      }
    } catch (_) {
      if (mounted) await _showError('Não foi possível atualizar o status.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _edit(CashFlowEntry entry, List<String> categories) async {
    final values = await showModalBottomSheet<_CashFlowEditValues>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (context) =>
          _EditCashFlowSheet(entry: entry, categories: categories),
    );
    if (values == null || !mounted) return;

    var scope = RecurrenceScope.single;
    if (entry.recurrenceSeriesId != null) {
      final selected = await showCashFlowScopePicker(
        context,
        action: CashFlowSeriesAction.edit,
      );
      if (selected == null || !mounted) return;
      scope = selected;
    }

    setState(() => _isSaving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCashFlowEntry(
            entryId: entry.id,
            description: values.description,
            amount: values.amount,
            occurredAt: values.occurredAt,
            kind: values.kind,
            paymentMethod: values.paymentMethod,
            category: values.category,
            notes: values.notes,
            status: values.status,
            scope: scope,
          );
      if (mounted) showSuccessMessage(context, 'Lançamento atualizado.');
    } catch (_) {
      if (mounted) await _showError('Não foi possível editar o lançamento.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _delete(CashFlowEntry entry) async {
    var scope = RecurrenceScope.single;
    if (entry.recurrenceSeriesId != null) {
      final selected = await showCashFlowScopePicker(
        context,
        action: CashFlowSeriesAction.delete,
      );
      if (selected == null || !mounted) return;
      scope = selected;
    }
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir lançamento?'),
        content: Text(
          entry.recurrenceSeriesId == null
              ? '“${entry.description}” será excluído permanentemente e deixará de influenciar a Agenda e os totais.'
              : '${recurrenceScopeLabel(scope)} será excluído permanentemente.',
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

    setState(() => _isSaving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deleteCashFlowEntry(entry.id, scope);
      if (!mounted) return;
      showSuccessMessage(context, 'Lançamento excluído.');
      context.go('/app/agenda');
    } catch (_) {
      if (mounted) await _showError('Não foi possível excluir o lançamento.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _showError(String fallback) => showDialog<void>(
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
    final entry = _findEntry(finance.cashFlowEntries, widget.entryId);
    if (entry == null) {
      return const Scaffold(
        appBar: BrandAppBar(title: 'Lançamento', showBack: true),
        body: Center(child: Text('Este lançamento não está mais disponível.')),
      );
    }

    final accent = entry.isIncome ? AppColors.secondary : AppColors.primary;
    final statusColor = _statusColor(entry.status);
    return Scaffold(
      appBar: BrandAppBar(
        title: entry.isIncome ? 'Detalhes da entrada' : 'Detalhes da despesa',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Editar lançamento',
            onPressed: finance.canEdit && !_isSaving
                ? () => _edit(entry, finance.categories)
                : null,
            icon: const Icon(Icons.edit_outlined),
          ),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(financeControllerProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              AppContent(
                maxWidth: 680,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _EntrySummary(entry: entry, accent: accent),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusPill(
                          label: _entryStatusLabel(entry),
                          color: statusColor,
                        ),
                        StatusPill(
                          label: cashFlowKindLabel(entry.kind),
                          color: accent,
                        ),
                        if (entry.recurrenceSeriesId != null)
                          const StatusPill(
                            label: 'Recorrente',
                            color: AppColors.primary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _EntryInformation(entry: entry),
                    if ((entry.notes ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      _NotesCard(notes: entry.notes!.trim()),
                    ],
                    if (finance.canEdit) ...[
                      const SizedBox(height: 28),
                      if (entry.status == CashFlowStatus.scheduled)
                        FilledButton.icon(
                          onPressed: _isSaving ? null : () => _confirm(entry),
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: Text(
                            entry.isIncome
                                ? 'Confirmar recebimento'
                                : 'Confirmar pagamento',
                          ),
                        ),
                      if (entry.status == CashFlowStatus.scheduled)
                        const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: _isSaving
                            ? null
                            : () => _edit(entry, finance.categories),
                        icon: const Icon(Icons.edit_outlined),
                        label: const Text('Editar lançamento'),
                      ),
                      const SizedBox(height: 12),
                      FilledButton.icon(
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFDAD6),
                          foregroundColor: const Color(0xFF93000A),
                        ),
                        onPressed: _isSaving ? null : () => _delete(entry),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Excluir lançamento'),
                      ),
                    ],
                    const SizedBox(height: 24),
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

class _EntrySummary extends StatelessWidget {
  const _EntrySummary({required this.entry, required this.accent});

  final CashFlowEntry entry;
  final Color accent;

  @override
  Widget build(BuildContext context) => Card(
    color: accent.withValues(alpha: .08),
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: accent.withValues(alpha: .14),
            child: Icon(cashFlowKindIcon(entry.kind), color: accent, size: 30),
          ),
          const SizedBox(height: 14),
          Text(
            entry.description,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          FittedBox(
            child: Text(
              entry.amount.format(),
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(color: accent),
            ),
          ),
        ],
      ),
    ),
  );
}

class _EntryInformation extends StatelessWidget {
  const _EntryInformation({required this.entry});

  final CashFlowEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        children: [
          _InformationRow(
            icon: Icons.calendar_today_outlined,
            label: 'Data',
            value: DateFormat(
              "d 'de' MMMM 'de' y",
              'pt_BR',
            ).format(entry.occurredAt),
          ),
          const Divider(height: 1),
          _InformationRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Forma de movimentação',
            value: cashFlowPaymentMethodLabel(entry.paymentMethod),
          ),
          if (entry.categoryName != null) ...[
            const Divider(height: 1),
            _InformationRow(
              icon: Icons.category_outlined,
              label: 'Categoria',
              value: entry.categoryName!,
            ),
          ],
          if (entry.recurrenceSeriesId != null) ...[
            const Divider(height: 1),
            _InformationRow(
              icon: Icons.repeat_rounded,
              label: 'Ocorrência',
              value: entry.occurrenceIndex == null
                  ? 'Série recorrente'
                  : 'Nº ${entry.occurrenceIndex}',
            ),
          ],
        ],
      ),
    ),
  );
}

class _InformationRow extends StatelessWidget {
  const _InformationRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: AppColors.textMuted),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 3),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ],
    ),
  );
}

class _NotesCard extends StatelessWidget {
  const _NotesCard({required this.notes});

  final String notes;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Observação', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          SelectableText(notes),
        ],
      ),
    ),
  );
}

class _EditCashFlowSheet extends StatefulWidget {
  const _EditCashFlowSheet({required this.entry, required this.categories});

  final CashFlowEntry entry;
  final List<String> categories;

  @override
  State<_EditCashFlowSheet> createState() => _EditCashFlowSheetState();
}

class _EditCashFlowSheetState extends State<_EditCashFlowSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _descriptionController;
  late final TextEditingController _notesController;
  late Money _amount;
  late DateTime _occurredAt;
  late CashFlowKind _kind;
  late CashFlowPaymentMethod _paymentMethod;
  late CashFlowStatus _status;
  String? _category;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(
      text: widget.entry.description,
    );
    _notesController = TextEditingController(text: widget.entry.notes);
    _amount = widget.entry.amount;
    _occurredAt = widget.entry.occurredAt;
    _kind = widget.entry.kind;
    _paymentMethod = widget.entry.paymentMethod;
    _status = widget.entry.status;
    _category = widget.entry.categoryName;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      lastDate: DateTime(9999, 12, 31),
      locale: const Locale('pt', 'BR'),
    );
    if (date != null) setState(() => _occurredAt = date);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _CashFlowEditValues(
        description: _descriptionController.text.trim(),
        amount: _amount,
        occurredAt: _occurredAt,
        kind: _kind,
        paymentMethod: _paymentMethod,
        category: _category,
        notes: _notesController.text.trim(),
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final availableKinds = cashFlowKindsFor(widget.entry.direction).toList();
    if (!availableKinds.contains(widget.entry.kind)) {
      availableKinds.add(widget.entry.kind);
    }
    final availableCategories = widget.categories.toList();
    if (_category != null && !availableCategories.contains(_category)) {
      availableCategories.add(_category!);
    }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .9,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20, 4, 20, 24 + bottomInset),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Editar lançamento',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 20),
              CurrencyField(
                label: 'Valor',
                initialCents: widget.entry.amount.cents,
                onChanged: (value) => _amount = value,
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição'),
                validator: (value) => (value?.trim().length ?? 0) >= 3
                    ? null
                    : 'Informe uma descrição.',
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<CashFlowKind>(
                initialValue: _kind,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Tipo'),
                items: [
                  for (final kind in availableKinds)
                    DropdownMenuItem(
                      value: kind,
                      child: Text(cashFlowKindLabel(kind)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _kind = value);
                },
              ),
              if (!widget.entry.isIncome) ...[
                const SizedBox(height: 14),
                DropdownButtonFormField<String>(
                  initialValue: _category,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Categoria'),
                  items: [
                    for (final category in availableCategories)
                      DropdownMenuItem(value: category, child: Text(category)),
                  ],
                  validator: (value) =>
                      value == null ? 'Selecione uma categoria.' : null,
                  onChanged: (value) => _category = value,
                ),
              ],
              const SizedBox(height: 14),
              DropdownButtonFormField<CashFlowPaymentMethod>(
                initialValue: _paymentMethod,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Forma de movimentação',
                ),
                items: [
                  for (final method in CashFlowPaymentMethod.values)
                    DropdownMenuItem(
                      value: method,
                      child: Text(cashFlowPaymentMethodLabel(method)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) _paymentMethod = value;
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<CashFlowStatus>(
                initialValue: _status,
                isExpanded: true,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(
                    value: CashFlowStatus.scheduled,
                    child: Text(
                      widget.entry.isIncome ? 'Prevista' : 'Pendente',
                    ),
                  ),
                  DropdownMenuItem(
                    value: CashFlowStatus.confirmed,
                    child: Text(widget.entry.isIncome ? 'Recebida' : 'Paga'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _status = value);
                },
              ),
              const SizedBox(height: 14),
              InkWell(
                onTap: _selectDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                    suffixIcon: Icon(Icons.expand_more_rounded),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_occurredAt)),
                ),
              ),
              const DropdownMenuItem(
                value: CashFlowStatus.cancelled,
                child: Text('Cancelada'),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _submit,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Continuar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _CashFlowEditValues {
  const _CashFlowEditValues({
    required this.description,
    required this.amount,
    required this.occurredAt,
    required this.kind,
    required this.paymentMethod,
    required this.category,
    required this.notes,
    required this.status,
  });

  final String description;
  final Money amount;
  final DateTime occurredAt;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final String? category;
  final String? notes;
  final CashFlowStatus status;
}

CashFlowEntry? _findEntry(List<CashFlowEntry> entries, String id) {
  for (final entry in entries) {
    if (entry.id == id) return entry;
  }
  return null;
}

String _entryStatusLabel(CashFlowEntry entry) => switch (entry.status) {
  CashFlowStatus.scheduled => entry.isIncome ? 'Prevista' : 'Pendente',
  CashFlowStatus.confirmed => entry.isIncome ? 'Recebida' : 'Paga',
  CashFlowStatus.cancelled => 'Cancelada',
};

Color _statusColor(CashFlowStatus status) => switch (status) {
  CashFlowStatus.scheduled => AppColors.primary,
  CashFlowStatus.confirmed => AppColors.secondary,
  CashFlowStatus.cancelled => AppColors.error,
};

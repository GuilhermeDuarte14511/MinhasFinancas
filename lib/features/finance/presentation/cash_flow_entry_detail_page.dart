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
  const CashFlowEntryDetailPage({
    required this.entryId,
    this.initialEntry,
    super.key,
  });

  final String entryId;
  final CashFlowEntry? initialEntry;

  @override
  ConsumerState<CashFlowEntryDetailPage> createState() =>
      _CashFlowEntryDetailPageState();
}

class _CashFlowEntryDetailPageState
    extends ConsumerState<CashFlowEntryDetailPage> {
  var _saving = false;

  Future<void> _confirm(CashFlowEntry entry) async {
    setState(() => _saving = true);
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
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _edit(CashFlowEntry entry, List<String> categories) async {
    final values = await showModalBottomSheet<_EditValues>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      useSafeArea: true,
      builder: (_) => _EditSheet(entry: entry, categories: categories),
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

    setState(() => _saving = true);
    try {
      await ref.read(financeControllerProvider.notifier).updateCashFlowEntry(
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
      if (mounted) setState(() => _saving = false);
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
      builder: (_) => AlertDialog(
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

    setState(() => _saving = true);
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
      if (mounted) setState(() => _saving = false);
    }
  }

  Future<void> _showError(String fallback) => showDialog<void>(
    context: context,
    builder: (_) => AlertDialog(
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
    final stateEntry = _findEntry(finance.cashFlowEntries, widget.entryId);
    final entry = stateEntry ?? widget.initialEntry;
    if (entry == null) {
      return const Scaffold(
        appBar: BrandAppBar(title: 'Lançamento', showBack: true),
        body: Center(child: Text('Este lançamento não está mais disponível.')),
      );
    }

    final canManage = finance.canEdit && stateEntry != null;
    final accent = entry.isIncome ? AppColors.secondary : AppColors.primary;
    return Scaffold(
      appBar: BrandAppBar(
        title: entry.isIncome ? 'Detalhes da entrada' : 'Detalhes da despesa',
        showBack: true,
        actions: [
          IconButton(
            tooltip: canManage
                ? 'Editar lançamento'
                : 'Atualize os dados para editar',
            onPressed: canManage && !_saving
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
                    _Summary(entry: entry, accent: accent),
                    const SizedBox(height: 20),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        StatusPill(
                          label: _statusLabel(entry),
                          color: _statusColor(entry.status),
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
                    _Information(entry: entry),
                    if ((entry.notes ?? '').trim().isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Observação',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: 8),
                              SelectableText(entry.notes!.trim()),
                            ],
                          ),
                        ),
                      ),
                    ],
                    if (canManage) ...[
                      const SizedBox(height: 28),
                      if (entry.status == CashFlowStatus.scheduled) ...[
                        FilledButton.icon(
                          onPressed: _saving ? null : () => _confirm(entry),
                          icon: const Icon(Icons.check_circle_outline_rounded),
                          label: Text(
                            entry.isIncome
                                ? 'Confirmar recebimento'
                                : 'Confirmar pagamento',
                          ),
                        ),
                        const SizedBox(height: 12),
                      ],
                      OutlinedButton.icon(
                        onPressed: _saving
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
                        onPressed: _saving ? null : () => _delete(entry),
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

class _Summary extends StatelessWidget {
  const _Summary({required this.entry, required this.accent});

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
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: accent),
            ),
          ),
        ],
      ),
    ),
  );
}

class _Information extends StatelessWidget {
  const _Information({required this.entry});

  final CashFlowEntry entry;

  @override
  Widget build(BuildContext context) => Card(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.calendar_today_outlined,
            label: 'Data',
            value: DateFormat("d 'de' MMMM 'de' y", 'pt_BR')
                .format(entry.occurredAt),
          ),
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.account_balance_wallet_outlined,
            label: 'Forma de movimentação',
            value: cashFlowPaymentMethodLabel(entry.paymentMethod),
          ),
          if (entry.categoryName != null) ...[
            const Divider(height: 1),
            _InfoRow(
              icon: Icons.category_outlined,
              label: 'Categoria',
              value: entry.categoryName!,
            ),
          ],
          const Divider(height: 1),
          _InfoRow(
            icon: Icons.person_outline_rounded,
            label: 'Criado por',
            value: entry.createdBy.trim().isEmpty
                ? 'Usuário do espaço'
                : entry.createdBy,
          ),
          if (entry.recurrenceSeriesId != null) ...[
            const Divider(height: 1),
            _InfoRow(
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

class _InfoRow extends StatelessWidget {
  const _InfoRow({
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

class _EditSheet extends StatefulWidget {
  const _EditSheet({required this.entry, required this.categories});

  final CashFlowEntry entry;
  final List<String> categories;

  @override
  State<_EditSheet> createState() => _EditSheetState();
}

class _EditSheetState extends State<_EditSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _description;
  late final TextEditingController _notes;
  late Money _amount;
  late DateTime _date;
  late CashFlowKind _kind;
  late CashFlowPaymentMethod _method;
  late CashFlowStatus _status;
  String? _category;

  @override
  void initState() {
    super.initState();
    _description = TextEditingController(text: widget.entry.description);
    _notes = TextEditingController(text: widget.entry.notes);
    _amount = widget.entry.amount;
    _date = widget.entry.occurredAt;
    _kind = widget.entry.kind;
    _method = widget.entry.paymentMethod;
    _status = widget.entry.status;
    _category = widget.entry.categoryName;
  }

  @override
  void dispose() {
    _description.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final value = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(9999, 12, 31),
      locale: const Locale('pt', 'BR'),
    );
    if (value != null) setState(() => _date = value);
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      _EditValues(
        description: _description.text.trim(),
        amount: _amount,
        occurredAt: _date,
        kind: _kind,
        paymentMethod: _method,
        category: _category,
        notes: _notes.text.trim(),
        status: _status,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final kinds = cashFlowKindsFor(widget.entry.direction).toList();
    if (!kinds.contains(_kind)) kinds.add(_kind);
    final categories = widget.categories.toList();
    if (_category != null && !categories.contains(_category)) {
      categories.add(_category!);
    }
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .9,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          20,
          4,
          20,
          24 + MediaQuery.viewInsetsOf(context).bottom,
        ),
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
                controller: _description,
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
                  for (final kind in kinds)
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
                    for (final value in categories)
                      DropdownMenuItem(value: value, child: Text(value)),
                  ],
                  validator: (value) =>
                      value == null ? 'Selecione uma categoria.' : null,
                  onChanged: (value) => setState(() => _category = value),
                ),
              ],
              const SizedBox(height: 14),
              DropdownButtonFormField<CashFlowPaymentMethod>(
                initialValue: _method,
                isExpanded: true,
                decoration: const InputDecoration(
                  labelText: 'Forma de movimentação',
                ),
                items: [
                  for (final value in CashFlowPaymentMethod.values)
                    DropdownMenuItem(
                      value: value,
                      child: Text(cashFlowPaymentMethodLabel(value)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _method = value);
                },
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<CashFlowStatus>(
                initialValue: _status,
                decoration: const InputDecoration(labelText: 'Status'),
                items: [
                  DropdownMenuItem(
                    value: CashFlowStatus.scheduled,
                    child: Text(widget.entry.isIncome ? 'Prevista' : 'Pendente'),
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
                onTap: _pickDate,
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                ),
              ),
              const SizedBox(height: 14),
              TextFormField(
                controller: _notes,
                maxLines: 3,
                maxLength: 500,
                decoration: const InputDecoration(
                  labelText: 'Observação (opcional)',
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

final class _EditValues {
  const _EditValues({
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

String _statusLabel(CashFlowEntry entry) => switch (entry.status) {
  CashFlowStatus.scheduled => entry.isIncome ? 'Prevista' : 'Pendente',
  CashFlowStatus.confirmed => entry.isIncome ? 'Recebida' : 'Paga',
  CashFlowStatus.cancelled => 'Cancelada',
};

Color _statusColor(CashFlowStatus status) => switch (status) {
  CashFlowStatus.scheduled => AppColors.primary,
  CashFlowStatus.confirmed => AppColors.secondary,
  CashFlowStatus.cancelled => AppColors.error,
};

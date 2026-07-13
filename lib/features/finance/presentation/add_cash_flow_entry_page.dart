import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/cash_flow.dart';
import 'cash_flow_labels.dart';

class AddCashFlowEntryPage extends ConsumerStatefulWidget {
  const AddCashFlowEntryPage({required this.initialDirection, super.key});

  final CashFlowDirection initialDirection;

  @override
  ConsumerState<AddCashFlowEntryPage> createState() =>
      _AddCashFlowEntryPageState();
}

class _AddCashFlowEntryPageState extends ConsumerState<AddCashFlowEntryPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _occurrenceCountController = TextEditingController(text: '12');
  late CashFlowDirection _direction;
  late CashFlowKind _kind;
  late CashFlowPaymentMethod _paymentMethod;
  Money _amount = const Money.zero();
  DateTime _occurredAt = DateTime.now();
  CashFlowStatus _status = CashFlowStatus.confirmed;
  RecurrenceFrequency _recurrenceFrequency = RecurrenceFrequency.none;
  _RecurrenceEndMode _recurrenceEndMode = _RecurrenceEndMode.withoutEnd;
  DateTime? _recurrenceEndDate;
  int _preferredDay = DateTime.now().day;
  bool _statusWasSelected = false;
  String? _category;
  String? _accountId;
  String? _errorMessage;
  bool _saving = false;

  bool get _isIncome => _direction == CashFlowDirection.income;

  @override
  void initState() {
    super.initState();
    _setDirection(widget.initialDirection);
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _notesController.dispose();
    _occurrenceCountController.dispose();
    super.dispose();
  }

  void _setDirection(CashFlowDirection direction) {
    _direction = direction;
    _kind = cashFlowKindsFor(direction).first;
    _paymentMethod = direction == CashFlowDirection.income
        ? CashFlowPaymentMethod.bankTransfer
        : CashFlowPaymentMethod.pix;
    if (direction == CashFlowDirection.income) _category = null;
  }

  Future<void> _selectDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _occurredAt,
      firstDate: DateTime(2000),
      // DatePicker requires a finite upper bound. Keep it independent from
      // today so planned income can be registered years in advance.
      lastDate: DateTime(9999, 12, 31),
      locale: const Locale('pt', 'BR'),
    );
    if (selected == null) return;
    setState(() {
      _occurredAt = selected;
      _preferredDay = selected.day;
      if (_isIncome && !_statusWasSelected) {
        _status = _isFutureDate(selected)
            ? CashFlowStatus.scheduled
            : CashFlowStatus.confirmed;
      }
    });
  }

  Future<void> _selectRecurrenceEndDate() async {
    final initialDate = _recurrenceEndDate ?? _nextMonth(_occurredAt);
    final selected = await showDatePicker(
      context: context,
      initialDate: initialDate.isBefore(_occurredAt)
          ? _occurredAt
          : initialDate,
      firstDate: _occurredAt,
      lastDate: DateTime(9999, 12, 31),
      locale: const Locale('pt', 'BR'),
    );
    if (selected != null) setState(() => _recurrenceEndDate = selected);
  }

  RecurrenceRule? _buildRecurrenceRule() {
    if (!_isIncome || _recurrenceFrequency == RecurrenceFrequency.none) {
      return null;
    }
    return RecurrenceRule(
      frequency: _recurrenceFrequency,
      endDate: _recurrenceEndMode == _RecurrenceEndMode.endDate
          ? _recurrenceEndDate
          : null,
      occurrenceCount: _recurrenceEndMode == _RecurrenceEndMode.occurrences
          ? int.tryParse(_occurrenceCountController.text)
          : null,
      preferredDay: _preferredDay,
      withoutEnd: _recurrenceEndMode == _RecurrenceEndMode.withoutEnd,
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_isIncome &&
        _recurrenceFrequency != RecurrenceFrequency.none &&
        _recurrenceEndMode == _RecurrenceEndMode.endDate &&
        (_recurrenceEndDate == null ||
            _recurrenceEndDate!.isBefore(_occurredAt))) {
      setState(() {
        _errorMessage =
            'Selecione uma data final igual ou posterior à data inicial.';
      });
      return;
    }
    setState(() {
      _saving = true;
      _errorMessage = null;
    });
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .addCashFlowEntry(
            direction: _direction,
            kind: _kind,
            paymentMethod: _paymentMethod,
            description: _descriptionController.text.trim(),
            amount: _amount,
            occurredAt: _occurredAt,
            status: _isIncome ? _status : CashFlowStatus.confirmed,
            recurrence: _buildRecurrenceRule(),
            category: _category,
            accountId: _accountId,
            notes: _notesController.text.trim(),
          );
      if (!mounted) return;
      showSuccessMessage(
        context,
        _isIncome ? 'Entrada registrada.' : 'Saída registrada.',
      );
      context.go('/app/home');
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage =
            ref.read(financeControllerProvider).errorMessage ??
            'Não foi possível registrar esta movimentação.';
      });
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    if (!finance.canEdit) {
      return Scaffold(
        appBar: BrandAppBar(
          title: _isIncome ? 'Nova entrada' : 'Nova saída',
          showBack: true,
        ),
        body: AppContent(
          maxWidth: 520,
          padding: const EdgeInsets.fromLTRB(20, 48, 20, 48),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.visibility_outlined,
                size: 48,
                color: AppColors.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Acesso somente para leitura',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              const Text(
                'Somente proprietários e editores podem registrar movimentações neste espaço.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              OutlinedButton(
                onPressed: () => context.go('/app/home'),
                child: const Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      );
    }
    _category ??= finance.categories.isEmpty ? null : finance.categories.first;
    _accountId ??= finance.accounts.firstOrNull?.id;
    final accent = _isIncome ? AppColors.secondary : AppColors.primary;
    return Scaffold(
      appBar: BrandAppBar(
        title: _isIncome ? 'Nova entrada' : 'Nova saída',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 48),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _EntryIntroduction(isIncome: _isIncome, accent: accent),
                  const SizedBox(height: 24),
                  SegmentedButton<CashFlowDirection>(
                    segments: const [
                      ButtonSegment(
                        value: CashFlowDirection.income,
                        label: Text('Entrada'),
                        icon: Icon(Icons.south_west_rounded),
                      ),
                      ButtonSegment(
                        value: CashFlowDirection.expense,
                        label: Text('Saída'),
                        icon: Icon(Icons.north_east_rounded),
                      ),
                    ],
                    selected: {_direction},
                    onSelectionChanged: (selection) =>
                        setState(() => _setDirection(selection.first)),
                  ),
                  const SizedBox(height: 24),
                  CurrencyField(
                    label: 'Valor',
                    onChanged: (value) => _amount = value,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _descriptionController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      labelText: _isIncome
                          ? 'Descrição da entrada'
                          : 'Descrição da saída',
                      hintText: _isIncome
                          ? 'Ex: Salário de julho'
                          : 'Ex: Conta de energia',
                      prefixIcon: const Icon(Icons.edit_note_rounded),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) >= 3
                        ? null
                        : 'Informe uma descrição.',
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CashFlowKind>(
                    key: ValueKey('kind-${_direction.name}'),
                    initialValue: _kind,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: _isIncome
                          ? 'Tipo de entrada'
                          : 'Tipo de saída',
                      prefixIcon: Icon(cashFlowKindIcon(_kind)),
                    ),
                    items: [
                      for (final kind in cashFlowKindsFor(_direction))
                        DropdownMenuItem(
                          value: kind,
                          child: Text(cashFlowKindLabel(kind)),
                        ),
                    ],
                    onChanged: (value) {
                      if (value != null) setState(() => _kind = value);
                    },
                  ),
                  if (!_isIncome) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _category,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Categoria',
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: [
                        for (final category in finance.categories)
                          DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                      ],
                      validator: (value) =>
                          value == null ? 'Selecione uma categoria.' : null,
                      onChanged: (value) => _category = value,
                    ),
                  ],
                  const SizedBox(height: 16),
                  DropdownButtonFormField<CashFlowPaymentMethod>(
                    key: ValueKey('method-${_direction.name}'),
                    initialValue: _paymentMethod,
                    isExpanded: true,
                    decoration: const InputDecoration(
                      labelText: 'Como foi movimentado',
                      prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: [
                      for (final method in CashFlowPaymentMethod.values)
                        if (method != CashFlowPaymentMethod.creditCard)
                          DropdownMenuItem(
                            value: method,
                            child: Text(cashFlowPaymentMethodLabel(method)),
                          ),
                    ],
                    onChanged: (value) {
                      if (value != null) _paymentMethod = value;
                    },
                  ),
                  if (finance.accounts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _accountId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Conta',
                        prefixIcon: Icon(Icons.account_balance_outlined),
                        helperText: 'O saldo desta conta será atualizado.',
                      ),
                      items: [
                        for (final account in finance.accounts)
                          DropdownMenuItem(
                            value: account.id,
                            child: Text(account.name),
                          ),
                      ],
                      validator: (value) =>
                          value == null ? 'Selecione uma conta.' : null,
                      onChanged: (value) => _accountId = value,
                    ),
                  ],
                  const SizedBox(height: 16),
                  _DateField(date: _occurredAt, onTap: _selectDate),
                  if (_isIncome) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<CashFlowStatus>(
                      key: ValueKey('status-${_status.name}'),
                      initialValue: _status,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Status da entrada',
                        prefixIcon: Icon(Icons.fact_check_outlined),
                      ),
                      items: const [
                        DropdownMenuItem(
                          value: CashFlowStatus.scheduled,
                          child: Text('Prevista'),
                        ),
                        DropdownMenuItem(
                          value: CashFlowStatus.confirmed,
                          child: Text('Recebida'),
                        ),
                      ],
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() {
                          _status = value;
                          _statusWasSelected = true;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    _StatusExplanation(status: _status),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<RecurrenceFrequency>(
                      key: const Key('cash-flow-recurrence-field'),
                      initialValue: _recurrenceFrequency,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Recorrência',
                        prefixIcon: Icon(Icons.repeat_rounded),
                      ),
                      items: [
                        for (final frequency in RecurrenceFrequency.values)
                          DropdownMenuItem(
                            value: frequency,
                            child: Text(recurrenceFrequencyLabel(frequency)),
                          ),
                      ],
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _recurrenceFrequency = value);
                        }
                      },
                    ),
                    if (_recurrenceFrequency != RecurrenceFrequency.none) ...[
                      const SizedBox(height: 16),
                      _RecurrenceOptions(
                        frequency: _recurrenceFrequency,
                        endMode: _recurrenceEndMode,
                        endDate: _recurrenceEndDate,
                        preferredDay: _preferredDay,
                        occurrenceCountController: _occurrenceCountController,
                        onEndModeChanged: (value) =>
                            setState(() => _recurrenceEndMode = value),
                        onEndDateTap: _selectRecurrenceEndDate,
                        onPreferredDayChanged: (value) =>
                            setState(() => _preferredDay = value),
                      ),
                    ],
                  ],
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Observação (opcional)',
                      alignLabelWithHint: true,
                    ),
                  ),
                  if (_errorMessage != null) ...[
                    const SizedBox(height: 8),
                    Semantics(
                      liveRegion: true,
                      child: SelectableText(
                        _errorMessage!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : _save,
                    icon: Icon(
                      _isIncome
                          ? Icons.add_circle_outline_rounded
                          : Icons.check_circle_outline_rounded,
                    ),
                    label: Text(
                      _saving
                          ? 'Salvando...'
                          : _isIncome
                          ? 'Registrar entrada'
                          : 'Registrar saída',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EntryIntroduction extends StatelessWidget {
  const _EntryIntroduction({required this.isIncome, required this.accent});

  final bool isIncome;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: accent.withValues(alpha: .12),
          child: Icon(
            isIncome ? Icons.south_west_rounded : Icons.north_east_rounded,
            color: accent,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isIncome ? 'Dinheiro que entrou' : 'Dinheiro que saiu',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              Text(
                isIncome
                    ? 'Registre salário, 13º, férias, bônus ou reembolsos.'
                    : 'Registre contas, boletos e pagamentos por Pix, dinheiro ou débito.',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onTap});

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Data da movimentação',
      child: InkWell(
        key: const Key('cash-flow-date-field'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: InputDecorator(
          decoration: const InputDecoration(
            labelText: 'Data',
            prefixIcon: Icon(Icons.calendar_today_outlined),
            suffixIcon: Icon(Icons.expand_more_rounded),
          ),
          child: Text(DateFormat("d 'de' MMMM 'de' y", 'pt_BR').format(date)),
        ),
      ),
    );
  }
}

enum _RecurrenceEndMode { withoutEnd, endDate, occurrences }

class _StatusExplanation extends StatelessWidget {
  const _StatusExplanation({required this.status});

  final CashFlowStatus status;

  @override
  Widget build(BuildContext context) {
    final isScheduled = status == CashFlowStatus.scheduled;
    return Semantics(
      container: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isScheduled
                ? Icons.schedule_rounded
                : Icons.check_circle_outline_rounded,
            size: 18,
            color: isScheduled ? AppColors.primary : AppColors.secondary,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              isScheduled
                  ? 'Entradas previstas aparecem na Agenda, mas só entram no saldo realizado depois da confirmação.'
                  : 'Esta entrada será contabilizada imediatamente como valor recebido.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecurrenceOptions extends StatelessWidget {
  const _RecurrenceOptions({
    required this.frequency,
    required this.endMode,
    required this.endDate,
    required this.preferredDay,
    required this.occurrenceCountController,
    required this.onEndModeChanged,
    required this.onEndDateTap,
    required this.onPreferredDayChanged,
  });

  final RecurrenceFrequency frequency;
  final _RecurrenceEndMode endMode;
  final DateTime? endDate;
  final int preferredDay;
  final TextEditingController occurrenceCountController;
  final ValueChanged<_RecurrenceEndMode> onEndModeChanged;
  final VoidCallback onEndDateTap;
  final ValueChanged<int> onPreferredDayChanged;

  bool get _usesPreferredDay =>
      frequency == RecurrenceFrequency.monthly ||
      frequency == RecurrenceFrequency.yearly;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceLow,
        border: Border.all(color: AppColors.outline),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Como a entrada deve se repetir?',
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 14),
          DropdownButtonFormField<_RecurrenceEndMode>(
            initialValue: endMode,
            isExpanded: true,
            decoration: const InputDecoration(labelText: 'Término'),
            items: const [
              DropdownMenuItem(
                value: _RecurrenceEndMode.withoutEnd,
                child: Text('Sem data final'),
              ),
              DropdownMenuItem(
                value: _RecurrenceEndMode.endDate,
                child: Text('Em uma data'),
              ),
              DropdownMenuItem(
                value: _RecurrenceEndMode.occurrences,
                child: Text('Após uma quantidade'),
              ),
            ],
            onChanged: (value) {
              if (value != null) onEndModeChanged(value);
            },
          ),
          if (endMode == _RecurrenceEndMode.endDate) ...[
            const SizedBox(height: 14),
            _RecurrenceDateField(date: endDate, onTap: onEndDateTap),
          ],
          if (endMode == _RecurrenceEndMode.occurrences) ...[
            const SizedBox(height: 14),
            TextFormField(
              controller: occurrenceCountController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                labelText: 'Quantidade de ocorrências',
                prefixIcon: Icon(Icons.format_list_numbered_rounded),
              ),
              validator: (value) {
                final count = int.tryParse(value ?? '');
                if (count == null || count < 2 || count > 600) {
                  return 'Informe uma quantidade entre 2 e 600.';
                }
                return null;
              },
            ),
          ],
          if (_usesPreferredDay) ...[
            const SizedBox(height: 14),
            DropdownButtonFormField<int>(
              initialValue: preferredDay,
              decoration: const InputDecoration(
                labelText: 'Dia preferencial',
                prefixIcon: Icon(Icons.today_outlined),
              ),
              items: [
                for (var day = 1; day <= 31; day++)
                  DropdownMenuItem(value: day, child: Text('Dia $day')),
              ],
              onChanged: (value) {
                if (value != null) onPreferredDayChanged(value);
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Quando o mês não tiver esse dia, a ocorrência será criada no último dia válido.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 12),
            ),
          ],
        ],
      ),
    );
  }
}

class _RecurrenceDateField extends StatelessWidget {
  const _RecurrenceDateField({required this.date, required this.onTap});

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: InputDecorator(
      decoration: const InputDecoration(
        labelText: 'Data final',
        prefixIcon: Icon(Icons.event_outlined),
        suffixIcon: Icon(Icons.expand_more_rounded),
      ),
      child: Text(
        date == null
            ? 'Selecionar data'
            : DateFormat('dd/MM/yyyy').format(date!),
      ),
    ),
  );
}

bool _isFutureDate(DateTime value) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return DateTime(value.year, value.month, value.day).isAfter(today);
}

DateTime _nextMonth(DateTime value) {
  final targetMonth = DateTime(value.year, value.month + 1);
  final lastDay = DateUtils.getDaysInMonth(targetMonth.year, targetMonth.month);
  return DateTime(
    targetMonth.year,
    targetMonth.month,
    value.day.clamp(1, lastDay),
  );
}

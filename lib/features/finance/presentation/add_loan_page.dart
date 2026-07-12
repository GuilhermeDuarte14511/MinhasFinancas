import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/loan_installment_schedule.dart';
import '../infrastructure/sql_connect_loan_schedule_service.dart';

class AddLoanPage extends ConsumerStatefulWidget {
  const AddLoanPage({super.key});

  @override
  ConsumerState<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends ConsumerState<AddLoanPage> {
  static const _scheduleGenerator = LoanInstallmentScheduleGenerator();
  static const _loanService = SqlConnectLoanScheduleService();

  final _formKey = GlobalKey<FormState>();
  final _lenderController = TextEditingController();
  final _descriptionController = TextEditingController();
  Money _amount = const Money.zero();
  int _installmentCount = 12;
  DateTime _firstPaymentDate = _defaultFirstPaymentDate();
  int _errorShakeTrigger = 0;
  bool _saving = false;

  Future<void> _pickFirstPaymentDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(DateTime.now().year + 40, 12, 31),
      initialDate: _firstPaymentDate,
      locale: const Locale('pt', 'BR'),
      helpText: 'Selecione o primeiro pagamento',
    );
    if (selected != null) {
      setState(() => _firstPaymentDate = selected);
    }
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorShakeTrigger++);
      return;
    }
    if (_amount.cents < _installmentCount) {
      setState(() => _errorShakeTrigger++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('O valor deve permitir pelo menos R\$ 0,01 por parcela.'),
        ),
      );
      return;
    }

    final finance = ref.read(financeControllerProvider);
    final spaceId = finance.spaceId;
    if (spaceId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum espaço financeiro selecionado.')),
      );
      return;
    }
    if (!finance.canEdit) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você não tem permissão para adicionar empréstimos.'),
        ),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await _loanService.createLoan(
        spaceId: spaceId,
        lender: _lenderController.text.trim(),
        description: _descriptionController.text.trim(),
        amount: _amount,
        installmentCount: _installmentCount,
        firstDueDate: _firstPaymentDate,
      );
      await ref.read(financeControllerProvider.notifier).refresh();
      if (!mounted) return;
      showSuccessMessage(context, 'Empréstimo adicionado ao cronograma.');
      context.go('/loans');
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(_friendlyError(error))),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  void dispose() {
    _lenderController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final canPreview =
        _amount.cents > 0 && _amount.cents >= _installmentCount;
    final preview = canPreview
        ? _scheduleGenerator.generate(
            total: _amount,
            count: _installmentCount,
            firstDueDate: _firstPaymentDate,
          )
        : null;

    return Scaffold(
      appBar: const BrandAppBar(title: 'Adicionar empréstimo', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: ShakeOnError(
              trigger: _errorShakeTrigger,
              child: Form(
                key: _formKey,
                child: StaggeredColumn(
                  step: const Duration(milliseconds: 60),
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados do contrato',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Informe o valor total e monte o cronograma das parcelas.',
                    ),
                    const SizedBox(height: 24),
                    CurrencyField(
                      key: const Key('loan-amount'),
                      label: 'Valor total do empréstimo',
                      large: true,
                      onChanged: (value) => setState(() => _amount = value),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      key: const Key('loan-lender'),
                      controller: _lenderController,
                      textCapitalization: TextCapitalization.words,
                      decoration: const InputDecoration(
                        labelText: 'Instituição ou pessoa',
                        prefixIcon: Icon(Icons.account_balance_outlined),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) >= 2
                          ? null
                          : 'Informe o credor.',
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      key: const Key('loan-description'),
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex: Financiamento do carro',
                        prefixIcon: Icon(Icons.description_outlined),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) >= 3
                          ? null
                          : 'Informe uma descrição.',
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      key: const Key('loan-first-payment-date'),
                      onTap: _pickFirstPaymentDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data do primeiro pagamento',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                          suffixIcon: Icon(Icons.expand_more_rounded),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_firstPaymentDate),
                        ),
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      'Número de parcelas',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 58,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.outline),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            tooltip: 'Diminuir parcelas',
                            onPressed: _installmentCount <= 1
                                ? null
                                : () => setState(() => _installmentCount--),
                            icon: const Icon(Icons.remove_rounded),
                          ),
                          Expanded(
                            child: Text(
                              '${_installmentCount}x',
                              textAlign: TextAlign.center,
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                          ),
                          IconButton(
                            tooltip: 'Aumentar parcelas',
                            onPressed: _installmentCount >= 360
                                ? null
                                : () => setState(() => _installmentCount++),
                            icon: const Icon(Icons.add_rounded),
                          ),
                        ],
                      ),
                    ),
                    if (preview != null) ...[
                      const SizedBox(height: 20),
                      _LoanSchedulePreview(installments: preview),
                    ] else if (_amount.cents > 0) ...[
                      const SizedBox(height: 12),
                      const Text(
                        'Reduza a quantidade de parcelas para que cada uma tenha pelo menos R\$ 0,01.',
                        style: TextStyle(color: AppColors.error),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      key: const Key('loan-submit'),
                      onPressed: _saving ? null : _save,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        _saving ? 'Salvando parcelas...' : 'Salvar empréstimo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _LoanSchedulePreview extends StatelessWidget {
  const _LoanSchedulePreview({required this.installments});

  final List<LoanInstallmentPlanItem> installments;

  @override
  Widget build(BuildContext context) {
    final first = installments.first;
    final last = installments.last;
    final amountLabel = first.amount == last.amount
        ? '${installments.length} ${installments.length == 1 ? 'parcela' : 'parcelas'} de ${first.amount.format()}'
        : '${installments.length} parcelas entre ${last.amount.format()} e ${first.amount.format()}';
    final dateFormat = DateFormat("d 'de' MMMM 'de' y", 'pt_BR');

    return Card(
      color: AppColors.surfaceLow,
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              backgroundColor: AppColors.primaryContainer,
              child: Icon(Icons.event_repeat_rounded, color: Colors.white),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    amountLabel,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text('Primeiro pagamento: ${dateFormat.format(first.dueDate)}'),
                  const SizedBox(height: 4),
                  Text('Último pagamento: ${dateFormat.format(last.dueDate)}'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

DateTime _defaultFirstPaymentDate() {
  final now = DateTime.now();
  final targetMonth = DateTime(now.year, now.month + 1);
  final lastDay = DateTime(targetMonth.year, targetMonth.month + 1, 0).day;
  return DateTime(
    targetMonth.year,
    targetMonth.month,
    math.min(now.day, lastDay),
  );
}

String _friendlyError(Object error) {
  if (error is StateError) return error.message;
  if (error is ArgumentError) return error.message?.toString() ?? error.toString();
  return 'Não foi possível salvar o empréstimo. Tente novamente.';
}

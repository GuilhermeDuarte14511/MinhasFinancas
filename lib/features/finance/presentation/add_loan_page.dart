import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/loan_installment_schedule.dart';
import '../infrastructure/loan_schedule_service.dart';

class AddLoanPage extends ConsumerStatefulWidget {
  const AddLoanPage({super.key});

  @override
  ConsumerState<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends ConsumerState<AddLoanPage> {
  static const _scheduleGenerator = LoanInstallmentScheduleGenerator();
  static const _loanService = LoanScheduleService();

  final _formKey = GlobalKey<FormState>();
  final _lenderController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _installmentCountController = TextEditingController(text: '12');

  Money _amount = const Money.zero();
  late DateTime _firstDueDate;
  int _installmentCount = 12;
  int _errorShakeTrigger = 0;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _firstDueDate = DateTime(now.year, now.month + 1, 10);
  }

  Future<void> _pickFirstDueDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final selected = await showDatePicker(
      context: context,
      firstDate: today,
      lastDate: DateTime(now.year + 30, 12, 31),
      initialDate: _firstDueDate.isBefore(today) ? today : _firstDueDate,
      locale: const Locale('pt', 'BR'),
      helpText: 'Primeiro pagamento',
    );
    if (selected != null) setState(() => _firstDueDate = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorShakeTrigger++);
      return;
    }

    final finance = ref.read(financeControllerProvider);
    final spaceId = finance.spaceId;
    if (spaceId == null) {
      setState(() => _errorShakeTrigger++);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nenhum espaço financeiro selecionado.')),
      );
      return;
    }

    setState(() => _saving = true);
    try {
      await _loanService.createLoan(
        spaceId: spaceId,
        lender: _lenderController.text.trim(),
        description: _descriptionController.text.trim(),
        total: _amount,
        installmentCount: _installmentCount,
        firstDueDate: _firstDueDate,
      );
      await ref.read(financeControllerProvider.notifier).refresh();
      if (!mounted) return;
      showSuccessMessage(context, 'Empréstimo adicionado ao cronograma.');
      context.go('/loans');
    } catch (error) {
      if (mounted) {
        final message = switch (error) {
          StateError() => error.message,
          _ => ref.read(financeControllerProvider).errorMessage ??
              'Não foi possível salvar o empréstimo.',
        };
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
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
    _installmentCountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final schedule = _amount.cents > 0 &&
            _installmentCount >= 1 &&
            _installmentCount <= 360
        ? _scheduleGenerator.generate(
            total: _amount,
            count: _installmentCount,
            firstDueDate: _firstDueDate,
          )
        : null;
    final dateFormatter = DateFormat("d 'de' MMMM 'de' y", 'pt_BR');

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Dados do contrato',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Informe o valor total e o app dividirá automaticamente entre as parcelas.',
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
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
                    CurrencyField(
                      label: 'Valor total do empréstimo',
                      large: true,
                      onChanged: (value) => setState(() => _amount = value),
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      controller: _installmentCountController,
                      keyboardType: TextInputType.number,
                      inputFormatters: const [FilteringTextInputFormatter.digitsOnly],
                      decoration: const InputDecoration(
                        labelText: 'Número de parcelas',
                        hintText: 'Ex: 12',
                        prefixIcon: Icon(Icons.format_list_numbered_rounded),
                        suffixText: 'x',
                      ),
                      validator: (value) {
                        final count = int.tryParse(value ?? '');
                        if (count == null || count < 1 || count > 360) {
                          return 'Informe entre 1 e 360 parcelas.';
                        }
                        return null;
                      },
                      onChanged: (value) => setState(
                        () => _installmentCount = int.tryParse(value) ?? 0,
                      ),
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickFirstDueDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data do primeiro pagamento',
                          prefixIcon: Icon(Icons.event_available_outlined),
                          suffixIcon: Icon(Icons.expand_more_rounded),
                        ),
                        child: Text(
                          DateFormat('dd/MM/yyyy').format(_firstDueDate),
                        ),
                      ),
                    ),
                    if (schedule != null) ...[
                      const SizedBox(height: 20),
                      Card(
                        color: AppColors.surfaceLow,
                        child: Padding(
                          padding: const EdgeInsets.all(18),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const CircleAvatar(
                                backgroundColor: AppColors.primaryContainer,
                                child: Icon(
                                  Icons.calendar_month_outlined,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${schedule.length} ${schedule.length == 1 ? 'parcela' : 'parcelas'} de ${schedule.first.amount.format()}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium,
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Primeiro pagamento: ${dateFormatter.format(schedule.first.dueDate)}',
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Último pagamento: ${dateFormatter.format(schedule.last.dueDate)}',
                                    ),
                                    if (schedule.first.amount !=
                                        schedule.last.amount) ...[
                                      const SizedBox(height: 8),
                                      Text(
                                        'A última parcela será de ${schedule.last.amount.format()} por causa do arredondamento.',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 26),
                    FilledButton.icon(
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';

class AddLoanPage extends ConsumerStatefulWidget {
  const AddLoanPage({super.key});

  @override
  ConsumerState<AddLoanPage> createState() => _AddLoanPageState();
}

class _AddLoanPageState extends ConsumerState<AddLoanPage> {
  final _formKey = GlobalKey<FormState>();
  final _lenderController = TextEditingController();
  final _descriptionController = TextEditingController();
  Money _amount = const Money.zero();
  Money _installmentAmount = const Money.zero();
  int _installmentCount = 12;
  int _dueDay = 10;
  int _errorShakeTrigger = 0;
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorShakeTrigger++);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .addLoan(
            lender: _lenderController.text.trim(),
            description: _descriptionController.text.trim(),
            amount: _amount,
            installmentAmount: _installmentAmount,
            installmentCount: _installmentCount,
            dueDay: _dueDay,
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Empréstimo adicionado ao cronograma.');
      context.go('/loans');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível salvar o empréstimo.',
            ),
          ),
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
                    const Text('Cadastre o cronograma que já foi contratado.'),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _lenderController,
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
                      label: 'Valor original em centavos',
                      onChanged: (value) => _amount = value,
                    ),
                    const SizedBox(height: 16),
                    CurrencyField(
                      label: 'Valor da parcela em centavos',
                      onChanged: (value) => _installmentAmount = value,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _installmentCount,
                            decoration: const InputDecoration(
                              labelText: 'Parcelas',
                            ),
                            items: const [12, 18, 24, 36, 48, 60, 120, 240, 360]
                                .map(
                                  (count) => DropdownMenuItem(
                                    value: count,
                                    child: Text('${count}x'),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) =>
                                _installmentCount = value ?? 12,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: DropdownButtonFormField<int>(
                            initialValue: _dueDay,
                            decoration: const InputDecoration(
                              labelText: 'Vencimento',
                            ),
                            items: [
                              for (var day = 1; day <= 31; day++)
                                DropdownMenuItem(
                                  value: day,
                                  child: Text('Dia $day'),
                                ),
                            ],
                            onChanged: (value) => _dueDay = value ?? 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 26),
                    FilledButton(
                      onPressed: _saving ? null : _save,
                      child: Text(
                        _saving ? 'Salvando...' : 'Salvar empréstimo',
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

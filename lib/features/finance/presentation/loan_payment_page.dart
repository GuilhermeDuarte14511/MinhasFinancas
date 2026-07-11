import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

typedef LoanPaymentSubmit =
    Future<void> Function(String loanId, Money amount, DateTime paidAt);

class LoanPaymentPage extends ConsumerStatefulWidget {
  const LoanPaymentPage({required this.loanId, this.onSubmit, super.key});

  final String loanId;
  final LoanPaymentSubmit? onSubmit;

  @override
  ConsumerState<LoanPaymentPage> createState() => _LoanPaymentPageState();
}

class _LoanPaymentPageState extends ConsumerState<LoanPaymentPage> {
  final _formKey = GlobalKey<FormState>();
  Money _amount = const Money.zero();
  DateTime _paidAt = DateTime.now();
  bool _saving = false;

  Future<void> _save(LoanContract loan) async {
    if (_amount.isZero) _amount = loan.installmentAmount;
    if (!_formKey.currentState!.validate()) return;
    if (_amount.compareTo(loan.outstandingBalance) > 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('O valor supera o saldo devedor.')),
      );
      return;
    }
    final submit =
        widget.onSubmit ??
        (String loanId, Money amount, DateTime paidAt) => ref
            .read(financeControllerProvider.notifier)
            .payLoan(loanId: loanId, amount: amount, paidAt: paidAt);
    setState(() => _saving = true);
    try {
      await submit(widget.loanId, _amount, _paidAt);
      if (!mounted) return;
      showSuccessMessage(context, 'Pagamento do empréstimo registrado.');
      Navigator.of(context).pop();
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Não foi possível registrar o pagamento.'),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loans = ref.watch(financeControllerProvider).loans;
    final loan = loans.cast<LoanContract?>().firstWhere(
      (item) => item?.id == widget.loanId,
      orElse: () => null,
    );
    if (loan == null) {
      return const Scaffold(
        appBar: BrandAppBar(title: 'Registrar pagamento', showBack: true),
        body: AppContent(
          child: Center(child: Text('Empréstimo não encontrado.')),
        ),
      );
    }

    return Scaffold(
      appBar: const BrandAppBar(title: 'Registrar pagamento', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    color: AppColors.surfaceLow,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Color(0xFFE2DFFF),
                            child: Icon(
                              Icons.account_balance_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  loan.lender,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  'Saldo devedor: ${loan.outstandingBalance.format()}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  CurrencyField(
                    label: 'Valor pago em centavos',
                    initialCents: loan.installmentAmount.cents,
                    large: true,
                    onChanged: (value) => _amount = value,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () =>
                        setState(() => _amount = loan.installmentAmount),
                    child: Text(
                      'Usar valor da parcela (${loan.installmentAmount.format()})',
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _paidAt,
                      );
                      if (date != null) setState(() => _paidAt = date);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data do pagamento',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(_paidAt)),
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : () => _save(loan),
                    icon: const Icon(Icons.check_rounded),
                    label: Text(
                      _saving ? 'Registrando...' : 'Confirmar pagamento',
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

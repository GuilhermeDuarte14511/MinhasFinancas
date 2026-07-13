import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';

class PaymentPage extends ConsumerStatefulWidget {
  const PaymentPage({required this.invoiceId, super.key});

  final String invoiceId;

  @override
  ConsumerState<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends ConsumerState<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  Money _amount = const Money.zero();
  DateTime _paidAt = DateTime.now();
  String? _accountId;
  bool _saving = false;

  Future<void> _save(Money pending) async {
    if (_amount.isZero) _amount = pending;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .payInvoice(
            invoiceId: widget.invoiceId,
            amount: _amount,
            paidAt: _paidAt,
            accountId: _accountId,
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Pagamento registrado com sucesso.');
      context.go('/app/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível registrar o pagamento.',
            ),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final invoice = finance.invoices.firstWhere(
      (item) => item.id == widget.invoiceId,
    );
    _accountId ??= finance.accounts.firstOrNull?.id;
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
                              Icons.receipt_long_rounded,
                              color: AppColors.primary,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(invoice.cardName),
                                Text(
                                  'Saldo pendente: ${invoice.pending.format()}',
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
                    key: ValueKey('invoice-payment-${_amount.cents}'),
                    label: 'Valor pago',
                    initialCents: _amount.isZero
                        ? invoice.pending.cents
                        : _amount.cents,
                    large: true,
                    onChanged: (value) => _amount = value,
                  ),
                  const SizedBox(height: 10),
                  TextButton(
                    onPressed: () => setState(() => _amount = invoice.pending),
                    child: Text(
                      'Usar saldo total (${invoice.pending.format()})',
                    ),
                  ),
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () async {
                      final selected = await showDatePicker(
                        context: context,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now().add(const Duration(days: 365)),
                        initialDate: _paidAt,
                      );
                      if (selected != null) setState(() => _paidAt = selected);
                    },
                    child: InputDecorator(
                      decoration: const InputDecoration(
                        labelText: 'Data do pagamento',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(DateFormat('dd/MM/yyyy').format(_paidAt)),
                    ),
                  ),
                  if (finance.accounts.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _accountId,
                      isExpanded: true,
                      decoration: const InputDecoration(
                        labelText: 'Conta usada no pagamento',
                        prefixIcon: Icon(Icons.account_balance_outlined),
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
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: _saving ? null : () => _save(invoice.pending),
                    icon: const Icon(Icons.check_rounded),
                    label: Text(
                      _saving ? 'Registrando...' : 'Confirmar pagamento',
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'O pagamento é sincronizado com todos os membros e libera o limite compartilhado.',
                    textAlign: TextAlign.center,
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

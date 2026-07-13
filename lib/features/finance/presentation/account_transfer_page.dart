import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';

class AccountTransferPage extends ConsumerStatefulWidget {
  const AccountTransferPage({super.key});

  @override
  ConsumerState<AccountTransferPage> createState() =>
      _AccountTransferPageState();
}

class _AccountTransferPageState extends ConsumerState<AccountTransferPage> {
  final _formKey = GlobalKey<FormState>();
  final _notes = TextEditingController();
  String? _fromAccountId;
  String? _toAccountId;
  Money _amount = const Money.zero();
  DateTime _date = DateTime.now();
  bool _saving = false;
  String? _error;

  @override
  void dispose() {
    _notes.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(9999, 12, 31),
      locale: const Locale('pt', 'BR'),
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_amount.cents <= 0) {
      setState(() => _error = 'Informe um valor maior que zero.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .transferBetweenAccounts(
            fromAccountId: _fromAccountId!,
            toAccountId: _toAccountId!,
            amount: _amount,
            transferredAt: _date,
            notes: _notes.text.trim(),
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Transferência registrada.');
      context.go('/accounts');
    } catch (_) {
      if (mounted) {
        setState(() {
          _error =
              ref.read(financeControllerProvider).errorMessage ??
              'Não foi possível registrar a transferência.';
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    if (finance.accounts.length >= 2) {
      _fromAccountId ??= finance.accounts.first.id;
      _toAccountId ??= finance.accounts
          .firstWhere((item) => item.id != _fromAccountId)
          .id;
    }
    return Scaffold(
      appBar: const BrandAppBar(title: 'Transferir', showBack: true),
      body: SingleChildScrollView(
        child: AppContent(
          maxWidth: 620,
          child: finance.accounts.length < 2
              ? const _NotEnoughAccounts()
              : Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Transferência entre contas',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'A transferência muda onde o dinheiro está, sem ser contabilizada como receita ou despesa.',
                      ),
                      const SizedBox(height: 24),
                      DropdownButtonFormField<String>(
                        initialValue: _fromAccountId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Conta de origem',
                          prefixIcon: Icon(Icons.north_east_rounded),
                        ),
                        items: [
                          for (final account in finance.accounts)
                            DropdownMenuItem(
                              value: account.id,
                              child: Text(account.name),
                            ),
                        ],
                        onChanged: (value) => setState(() {
                          _fromAccountId = value;
                          if (_toAccountId == value) {
                            _toAccountId = finance.accounts
                                .firstWhere((item) => item.id != value)
                                .id;
                          }
                        }),
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        key: ValueKey(_toAccountId),
                        initialValue: _toAccountId,
                        isExpanded: true,
                        decoration: const InputDecoration(
                          labelText: 'Conta de destino',
                          prefixIcon: Icon(Icons.south_west_rounded),
                        ),
                        items: [
                          for (final account in finance.accounts)
                            if (account.id != _fromAccountId)
                              DropdownMenuItem(
                                value: account.id,
                                child: Text(account.name),
                              ),
                        ],
                        validator: (value) => value == null
                            ? 'Selecione a conta de destino.'
                            : null,
                        onChanged: (value) => _toAccountId = value,
                      ),
                      const SizedBox(height: 16),
                      CurrencyField(
                        label: 'Valor da transferência',
                        onChanged: (value) => _amount = value,
                      ),
                      const SizedBox(height: 16),
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
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _notes,
                        maxLines: 3,
                        maxLength: 500,
                        decoration: const InputDecoration(
                          labelText: 'Observação (opcional)',
                        ),
                      ),
                      if (_error != null)
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: AppColors.error),
                        ),
                      const SizedBox(height: 20),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.swap_horiz_rounded),
                        label: Text(_saving ? 'Transferindo...' : 'Transferir'),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _NotEnoughAccounts extends StatelessWidget {
  const _NotEnoughAccounts();

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const Icon(Icons.swap_horiz_rounded, size: 48, color: AppColors.primary),
      const SizedBox(height: 14),
      Text(
        'Cadastre pelo menos duas contas',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      const SizedBox(height: 8),
      const Text(
        'Uma transferência precisa de uma conta de origem e outra de destino.',
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 20),
      FilledButton(
        onPressed: () => context.go('/accounts/new'),
        child: const Text('Adicionar conta'),
      ),
    ],
  );
}

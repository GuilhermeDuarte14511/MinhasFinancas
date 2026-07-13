import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/financial_planning.dart';
import 'financial_planning_labels.dart';

class AddAccountPage extends ConsumerStatefulWidget {
  const AddAccountPage({super.key});

  @override
  ConsumerState<AddAccountPage> createState() => _AddAccountPageState();
}

class _AddAccountPageState extends ConsumerState<AddAccountPage> {
  static const _colors = [
    0xFF3525CD,
    0xFF006A63,
    0xFF4F46E5,
    0xFF9F1844,
    0xFF4D6770,
  ];

  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _institution = TextEditingController();
  var _type = FinancialAccountType.checking;
  var _openingBalance = const Money.zero();
  var _openingBalanceAt = DateTime.now();
  var _colorValue = _colors.first;
  var _includeInTotal = true;
  var _saving = false;
  String? _error;

  @override
  void dispose() {
    _name.dispose();
    _institution.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _openingBalanceAt,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
      locale: const Locale('pt', 'BR'),
    );
    if (selected != null) setState(() => _openingBalanceAt = selected);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .addAccount(
            name: _name.text.trim(),
            institutionName: _institution.text.trim(),
            type: _type,
            openingBalance: _openingBalance,
            openingBalanceAt: _openingBalanceAt,
            colorValue: _colorValue,
            includeInTotal: _includeInTotal,
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Conta adicionada.');
      context.go('/accounts');
    } catch (_) {
      if (mounted) {
        setState(() {
          _error =
              ref.read(financeControllerProvider).errorMessage ??
              'Não foi possível adicionar a conta.';
        });
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: const BrandAppBar(title: 'Nova conta', showBack: true),
    body: SingleChildScrollView(
      child: AppContent(
        maxWidth: 620,
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _AccountIntro(),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Nome da conta',
                  hintText: 'Ex: Conta conjunta',
                  prefixIcon: Icon(Icons.wallet_outlined),
                ),
                validator: (value) => (value?.trim().length ?? 0) >= 2
                    ? null
                    : 'Informe o nome da conta.',
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _institution,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Instituição (opcional)',
                  hintText: 'Ex: Nubank',
                  prefixIcon: Icon(Icons.account_balance_outlined),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<FinancialAccountType>(
                initialValue: _type,
                decoration: const InputDecoration(
                  labelText: 'Tipo de conta',
                  prefixIcon: Icon(Icons.category_outlined),
                ),
                items: [
                  for (final type in FinancialAccountType.values)
                    DropdownMenuItem(
                      value: type,
                      child: Text(financialAccountTypeLabel(type)),
                    ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _type = value);
                },
              ),
              const SizedBox(height: 16),
              CurrencyField(
                label: 'Saldo inicial',
                onChanged: (value) => _openingBalance = value,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data do saldo inicial',
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    DateFormat(
                      "d 'de' MMMM 'de' y",
                      'pt_BR',
                    ).format(_openingBalanceAt),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Cor da conta',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 12,
                children: [
                  for (final color in _colors)
                    Semantics(
                      selected: color == _colorValue,
                      label: 'Selecionar cor',
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () => setState(() => _colorValue = color),
                        child: CircleAvatar(
                          backgroundColor: Color(color),
                          child: color == _colorValue
                              ? const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              SwitchListTile.adaptive(
                contentPadding: EdgeInsets.zero,
                value: _includeInTotal,
                title: const Text('Incluir no saldo total'),
                subtitle: const Text(
                  'Desative para contas que você quer acompanhar separadamente.',
                ),
                onChanged: (value) => setState(() => _includeInTotal = value),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ],
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: _saving ? null : _save,
                icon: const Icon(Icons.add_rounded),
                label: Text(_saving ? 'Salvando...' : 'Adicionar conta'),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

class _AccountIntro extends StatelessWidget {
  const _AccountIntro();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: AppColors.surfaceLow,
      borderRadius: BorderRadius.circular(18),
    ),
    child: const Row(
      children: [
        CircleAvatar(
          backgroundColor: AppColors.surfaceContainer,
          child: Icon(
            Icons.account_balance_wallet_outlined,
            color: AppColors.primary,
          ),
        ),
        SizedBox(width: 14),
        Expanded(
          child: Text(
            'O saldo atual será calculado a partir deste valor, das movimentações e das transferências.',
          ),
        ),
      ],
    ),
  );
}

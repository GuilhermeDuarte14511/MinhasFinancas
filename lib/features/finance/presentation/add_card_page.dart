import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';

class AddCardPage extends ConsumerStatefulWidget {
  const AddCardPage({super.key});

  @override
  ConsumerState<AddCardPage> createState() => _AddCardPageState();
}

class _AddCardPageState extends ConsumerState<AddCardPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _digitsController = TextEditingController();
  Money _limit = const Money.zero();
  int _closingDay = 10;
  int _dueDay = 17;
  int _colorValue = 0xFF3525CD;
  bool _saving = false;

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .addCard(
            nickname: _nameController.text.trim(),
            lastFourDigits: _digitsController.text,
            limit: _limit,
            closingDay: _closingDay,
            dueDay: _dueDay,
            colorValue: _colorValue,
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Cartão adicionado com segurança.');
      context.go('/app/cards');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível salvar o cartão.',
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
    _nameController.dispose();
    _digitsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const BrandAppBar(title: 'Adicionar cartão', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 620,
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Cadastre apenas os dados necessários',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Nunca informe número completo, CVV ou senha do cartão.',
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Apelido do cartão',
                      hintText: 'Ex: Cartão Índigo',
                      prefixIcon: Icon(Icons.credit_card_outlined),
                    ),
                    validator: (value) => (value?.trim().length ?? 0) >= 3
                        ? null
                        : 'Informe um apelido.',
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _digitsController,
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(4),
                    ],
                    decoration: const InputDecoration(
                      labelText: 'Últimos 4 dígitos',
                      prefixIcon: Icon(Icons.pin_outlined),
                    ),
                    validator: (value) => value?.length == 4
                        ? null
                        : 'Informe exatamente 4 dígitos.',
                  ),
                  const SizedBox(height: 16),
                  CurrencyField(
                    label: 'Limite total',
                    onChanged: (value) => _limit = value,
                  ),
                  const SizedBox(height: 16),
                  _BillingDaysFields(
                    closingDay: _closingDay,
                    dueDay: _dueDay,
                    onClosingChanged: (value) => _closingDay = value,
                    onDueChanged: (value) => _dueDay = value,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Cor do cartão',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final color in const [
                        0xFF3525CD,
                        0xFF006A63,
                        0xFF3D37A9,
                        0xFF8C1D40,
                        0xFF4B6267,
                      ])
                        ChoiceChip(
                          label: const SizedBox(width: 24, height: 24),
                          avatar: CircleAvatar(backgroundColor: Color(color)),
                          selected: _colorValue == color,
                          onSelected: (_) =>
                              setState(() => _colorValue = color),
                        ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  FilledButton(
                    onPressed: _saving ? null : _save,
                    child: Text(_saving ? 'Salvando...' : 'Salvar cartão'),
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

class _BillingDaysFields extends StatelessWidget {
  const _BillingDaysFields({
    required this.closingDay,
    required this.dueDay,
    required this.onClosingChanged,
    required this.onDueChanged,
  });

  final int closingDay;
  final int dueDay;
  final ValueChanged<int> onClosingChanged;
  final ValueChanged<int> onDueChanged;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final closing = _DayField(
          label: 'Fechamento',
          value: closingDay,
          onChanged: onClosingChanged,
        );
        final due = _DayField(
          label: 'Vencimento',
          value: dueDay,
          onChanged: onDueChanged,
        );
        if (constraints.maxWidth < 330) {
          return Column(children: [closing, const SizedBox(height: 16), due]);
        }
        return Row(
          children: [
            Expanded(child: closing),
            const SizedBox(width: 12),
            Expanded(child: due),
          ],
        );
      },
    );
  }
}

class _DayField extends StatelessWidget {
  const _DayField({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      initialValue: value,
      isExpanded: true,
      decoration: InputDecoration(labelText: label),
      items: [
        for (var day = 1; day <= 31; day++)
          DropdownMenuItem(value: day, child: Text('Dia $day')),
      ],
      onChanged: (selected) => onChanged(selected ?? value),
    );
  }
}

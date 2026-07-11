import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class EditCardPage extends ConsumerStatefulWidget {
  const EditCardPage({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<EditCardPage> createState() => _EditCardPageState();
}

class _EditCardPageState extends ConsumerState<EditCardPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nicknameController;
  CreditCardAccount? _initialCard;
  Money _limit = const Money.zero();
  int? _closingDay;
  int? _dueDay;
  int _colorValue = 0xFF3525CD;
  var _saving = false;

  static const _colors = [
    0xFF3525CD,
    0xFF006A63,
    0xFF3D37A9,
    0xFF8C1D40,
    0xFF4B6267,
  ];

  @override
  void initState() {
    super.initState();
    _nicknameController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialCard != null) return;
    final cards = ref.read(financeControllerProvider).cards;
    for (final card in cards) {
      if (card.id != widget.cardId) continue;
      _initialCard = card;
      _nicknameController.text = card.nickname;
      _limit = card.limit;
      _closingDay = card.closingDay;
      _dueDay = card.dueDay;
      _colorValue = card.colorValue;
      break;
    }
  }

  @override
  void dispose() {
    _nicknameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final card = _initialCard;
    final canEdit =
        ref.watch(financeControllerProvider).currentRole !=
        MembershipRole.viewer;
    return Scaffold(
      appBar: const BrandAppBar(title: 'Editar cartão', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: card == null
                ? const _MissingCard()
                : Form(
                    key: _formKey,
                    child: StaggeredColumn(
                      step: const Duration(milliseconds: 65),
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Dados do cartão',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Final ${card.lastFourDigits} • as faturas e compras serão preservadas.',
                        ),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _nicknameController,
                          textInputAction: TextInputAction.next,
                          decoration: const InputDecoration(
                            labelText: 'Apelido do cartão',
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Informe um apelido'
                              : null,
                        ),
                        const SizedBox(height: 14),
                        TextFormField(
                          initialValue: card.cardholder,
                          enabled: false,
                          decoration: const InputDecoration(
                            labelText: 'Titular',
                            helperText: 'O titular não pode ser alterado.',
                          ),
                        ),
                        const SizedBox(height: 14),
                        CurrencyField(
                          key: ValueKey(card.id),
                          label: 'Limite total',
                          initialCents: card.limit.cents,
                          onChanged: (value) => _limit = value,
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: _DayField(
                                label: 'Dia de fechamento',
                                initialValue: card.closingDay,
                                onSaved: (value) => _closingDay = value,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: _DayField(
                                label: 'Dia de vencimento',
                                initialValue: card.dueDay,
                                onSaved: (value) => _dueDay = value,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        Text(
                          'Cor do cartão',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (final color in _colors)
                              Semantics(
                                button: true,
                                selected: color == _colorValue,
                                label: 'Selecionar cor do cartão',
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(99),
                                  onTap: () =>
                                      setState(() => _colorValue = color),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 180),
                                    width: 46,
                                    height: 46,
                                    decoration: BoxDecoration(
                                      color: Color(color),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: color == _colorValue
                                            ? AppColors.text
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                    ),
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
                        const SizedBox(height: 30),
                        FilledButton.icon(
                          onPressed: _saving || !canEdit ? null : _submit,
                          icon: _saving
                              ? const SizedBox.square(
                                  dimension: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Icon(Icons.save_outlined),
                          label: const Text('Salvar alterações'),
                        ),
                        if (!canEdit) ...[
                          const SizedBox(height: 10),
                          const Text(
                            'Seu acesso é somente para visualização.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .updateCard(
            cardId: widget.cardId,
            nickname: _nicknameController.text.trim(),
            limit: _limit,
            closingDay: _closingDay!,
            dueDay: _dueDay!,
            colorValue: _colorValue,
          );
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Cartão atualizado.')));
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível salvar: $error')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}

class _DayField extends StatelessWidget {
  const _DayField({
    required this.label,
    required this.initialValue,
    required this.onSaved,
  });

  final String label;
  final int initialValue;
  final ValueChanged<int> onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: '$initialValue',
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      validator: (value) {
        final day = int.tryParse(value ?? '');
        return day == null || day < 1 || day > 31
            ? 'Use um dia de 1 a 31'
            : null;
      },
      onSaved: (value) => onSaved(int.parse(value!)),
    );
  }
}

class _MissingCard extends StatelessWidget {
  const _MissingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      child: Padding(
        padding: EdgeInsets.all(28),
        child: Text(
          'Não foi possível encontrar este cartão para edição.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

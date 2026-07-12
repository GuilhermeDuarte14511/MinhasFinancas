import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../../billing/domain/card_invoice_cycle.dart';
import '../../billing/domain/installment_schedule.dart';
import '../application/finance_controller.dart';

class AddPurchasePage extends ConsumerStatefulWidget {
  const AddPurchasePage({super.key});

  @override
  ConsumerState<AddPurchasePage> createState() => _AddPurchasePageState();
}

class _AddPurchasePageState extends ConsumerState<AddPurchasePage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  Money _amount = const Money.zero();
  DateTime _date = DateTime.now();
  String? _cardId;
  String? _category;
  int _installmentCount = 1;
  int _errorShakeTrigger = 0;
  bool _saving = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final selected = await showDatePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime(DateTime.now().year + 5),
      initialDate: _date,
      locale: const Locale('pt', 'BR'),
    );
    if (selected != null) setState(() => _date = selected);
  }

  Future<void> _submit() async {
    final finance = ref.read(financeControllerProvider);
    _cardId ??= finance.cards.first.id;
    _category ??= finance.categories.first;
    if (!_formKey.currentState!.validate()) {
      setState(() => _errorShakeTrigger++);
      return;
    }
    setState(() => _saving = true);
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .addPurchase(
            description: _descriptionController.text.trim(),
            category: _category!,
            cardId: _cardId!,
            total: _amount,
            installmentCount: _installmentCount,
            purchaseDate: _date,
          );
      if (!mounted) return;
      showSuccessMessage(context, 'Compra salva e faturas atualizadas.');
      context.go('/app/home');
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível salvar a compra.',
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
    if (finance.cards.isEmpty) {
      return Scaffold(
        appBar: const BrandAppBar(title: 'Nova compra', showBack: true),
        body: SafeArea(
          child: AppContent(
            maxWidth: 560,
            child: StaggeredColumn(
              step: const Duration(milliseconds: 80),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 46,
                    backgroundColor: Color(0xFFE2DFFF),
                    child: Icon(
                      Icons.credit_card_off_outlined,
                      size: 42,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Cadastre um cartão primeiro',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                const Text(
                  'Toda compra precisa estar vinculada a um cartão do espaço financeiro.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                FilledButton.icon(
                  onPressed: () => context.go('/new-card'),
                  icon: const Icon(Icons.add_card_rounded),
                  label: const Text('Adicionar cartão'),
                ),
              ],
            ),
          ),
        ),
      );
    }
    _cardId ??= finance.cards.first.id;
    _category ??= finance.categories.first;
    final selectedCard = finance.cards.firstWhere((card) => card.id == _cardId);
    final firstCycle = const CardInvoiceCycleCalculator().calculate(
      purchaseDate: _date,
      closingDay: selectedCard.closingDay,
      dueDay: selectedCard.dueDay,
    );
    final preview = _amount.cents <= 0
        ? null
        : const InstallmentScheduleGenerator().generate(
            total: _amount,
            count: _installmentCount,
            firstReferenceMonth: firstCycle.referenceMonth,
          );
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Nova compra',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Fechar',
            onPressed: () => context.pop(),
            icon: const Icon(Icons.close_rounded, color: AppColors.primary),
          ),
        ],
      ),
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
                    CurrencyField(
                      key: const Key('purchase-amount'),
                      label: 'Valor da compra',
                      large: true,
                      onChanged: (value) => setState(() => _amount = value),
                    ),
                    const SizedBox(height: 22),
                    TextFormField(
                      key: const Key('purchase-description'),
                      controller: _descriptionController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        hintText: 'Ex: Mercado da semana',
                        prefixIcon: Icon(Icons.edit_outlined),
                      ),
                      validator: (value) => (value?.trim().length ?? 0) >= 3
                          ? null
                          : 'Descreva a compra.',
                    ),
                    const SizedBox(height: 16),
                    InkWell(
                      onTap: _pickDate,
                      borderRadius: BorderRadius.circular(12),
                      child: InputDecorator(
                        decoration: const InputDecoration(
                          labelText: 'Data',
                          prefixIcon: Icon(Icons.calendar_today_outlined),
                        ),
                        child: Text(DateFormat('dd/MM/yyyy').format(_date)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      initialValue: _cardId,
                      decoration: const InputDecoration(
                        labelText: 'Cartão utilizado',
                        prefixIcon: Icon(Icons.credit_card_outlined),
                      ),
                      items: [
                        for (final card in finance.cards)
                          DropdownMenuItem(
                            value: card.id,
                            child: Text(
                              '${card.nickname} • ${card.lastFourDigits}',
                            ),
                          ),
                      ],
                      onChanged: (value) => setState(() => _cardId = value),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Categoria',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        for (final category in finance.categories)
                          ChoiceChip(
                            label: Text(category),
                            selected: _category == category,
                            onSelected: (_) =>
                                setState(() => _category = category),
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Text(
                      'Tipo de pagamento',
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<bool>(
                      segments: const [
                        ButtonSegment(value: false, label: Text('À vista')),
                        ButtonSegment(value: true, label: Text('Parcelado')),
                      ],
                      selected: {_installmentCount > 1},
                      onSelectionChanged: (selection) => setState(
                        () => _installmentCount = selection.first ? 2 : 1,
                      ),
                    ),
                    if (_installmentCount > 1) ...[
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
                              onPressed: _installmentCount <= 2
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
                              onPressed: _installmentCount >= 24
                                  ? null
                                  : () => setState(() => _installmentCount++),
                              icon: const Icon(Icons.add_rounded),
                            ),
                          ],
                        ),
                      ),
                    ],
                    if (preview != null) ...[
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
                                  Icons.info_outline_rounded,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${preview.length} ${preview.length == 1 ? 'parcela' : 'parcelas'} de ${preview.first.amount.format()}',
                                      style: Theme.of(
                                        context,
                                      ).textTheme.titleMedium,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      'Primeira parcela em ${DateFormat('MMMM \'de\' yyyy', 'pt_BR').format(preview.first.referenceMonth)}',
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      'Limite após a compra: ${(selectedCard.available - _amount).format()}',
                                      style: const TextStyle(
                                        color: AppColors.secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 24),
                    FilledButton.icon(
                      key: const Key('purchase-submit'),
                      onPressed: _saving ? null : _submit,
                      icon: const Icon(Icons.check_rounded),
                      label: Text(
                        _saving ? 'Salvando parcelas...' : 'Salvar compra',
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

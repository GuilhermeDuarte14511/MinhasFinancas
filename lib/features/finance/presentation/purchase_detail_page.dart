import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class PurchaseDetailPage extends ConsumerWidget {
  const PurchaseDetailPage({required this.purchaseId, super.key});

  final String purchaseId;

  Future<void> _edit(
    BuildContext context,
    WidgetRef ref,
    PurchaseRecord purchase,
    List<String> categories,
  ) async {
    final descriptionController = TextEditingController(
      text: purchase.description,
    );
    var category = purchase.category;
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Padding(
          padding: EdgeInsets.fromLTRB(
            24,
            8,
            24,
            24 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Editar compra',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 18),
              TextField(
                controller: descriptionController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(labelText: 'Descrição'),
              ),
              const SizedBox(height: 14),
              DropdownButtonFormField<String>(
                initialValue: category,
                decoration: const InputDecoration(labelText: 'Categoria'),
                items: categories
                    .map(
                      (item) =>
                          DropdownMenuItem(value: item, child: Text(item)),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value != null) setModalState(() => category = value);
                },
              ),
              const SizedBox(height: 22),
              FilledButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text('Salvar alterações'),
              ),
            ],
          ),
        ),
      ),
    );
    if (result == true && context.mounted) {
      final description = descriptionController.text.trim();
      if (description.isNotEmpty) {
        try {
          await ref
              .read(financeControllerProvider.notifier)
              .updatePurchaseDetails(
                purchaseId: purchase.id,
                description: description,
                category: category,
              );
          if (context.mounted) {
            showSuccessMessage(context, 'Compra atualizada.');
          }
        } catch (_) {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  ref.read(financeControllerProvider).errorMessage ??
                      'Não foi possível atualizar a compra.',
                ),
              ),
            );
          }
        }
      }
    }
    descriptionController.dispose();
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    PurchaseRecord purchase,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Excluir compra?'),
        content: Text(
          'A compra “${purchase.description}” será cancelada e não aparecerá mais nas projeções.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await ref
          .read(financeControllerProvider.notifier)
          .deletePurchase(purchase.id);
      if (!context.mounted) return;
      showSuccessMessage(context, 'Compra cancelada.');
      context.go('/app/home');
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(financeControllerProvider).errorMessage ??
                  'Não foi possível cancelar a compra.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final matches = finance.purchases.where((item) => item.id == purchaseId);
    if (matches.isEmpty) {
      return Scaffold(
        appBar: const BrandAppBar(title: 'Detalhes', showBack: true),
        body: const Center(
          child: Text('Esta compra não está mais disponível.'),
        ),
      );
    }
    final purchase = matches.first;
    final installments =
        finance.purchaseInstallments
            .where((item) => item.purchaseId == purchase.id)
            .toList()
          ..sort((a, b) => a.number.compareTo(b.number));
    final card = finance.cards.firstWhere(
      (item) => item.id == purchase.cardId,
      orElse: () => const CreditCardAccount(
        id: 'removed',
        nickname: 'Cartão removido',
        lastFourDigits: '----',
        cardholder: '',
        limit: Money.zero(),
        committed: Money.zero(),
        closingDay: 1,
        dueDay: 1,
        colorValue: 0xFF777587,
      ),
    );
    return Scaffold(
      appBar: BrandAppBar(
        title: 'Detalhes da compra',
        showBack: true,
        actions: [
          IconButton(
            tooltip: 'Editar compra',
            onPressed: () => _edit(context, ref, purchase, finance.categories),
            icon: const Icon(Icons.edit_outlined, color: AppColors.primary),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 720,
            child: StaggeredColumn(
              step: const Duration(milliseconds: 65),
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(26),
                    child: Column(
                      children: [
                        const CircleAvatar(
                          radius: 34,
                          backgroundColor: AppColors.secondaryContainer,
                          child: Icon(
                            Icons.shopping_cart_outlined,
                            size: 34,
                            color: AppColors.secondary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          purchase.description,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 6),
                        FittedBox(
                          child: Text(
                            purchase.total.format(),
                            style: Theme.of(context).textTheme.displaySmall,
                          ),
                        ),
                        const SizedBox(height: 14),
                        StatusPill(
                          label: purchase.installmentCount == 1
                              ? 'À vista'
                              : '${purchase.installmentCount} parcelas',
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  childAspectRatio: 1.55,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  children: [
                    _InfoCard(
                      icon: Icons.calendar_month_outlined,
                      label: 'Data da compra',
                      value: DateFormat(
                        'dd MMM yyyy',
                        'pt_BR',
                      ).format(purchase.purchaseDate),
                    ),
                    _InfoCard(
                      icon: Icons.category_outlined,
                      label: 'Categoria',
                      value: purchase.category,
                    ),
                    _InfoCard(
                      icon: Icons.credit_card_outlined,
                      label: 'Cartão',
                      value: '${card.nickname} • ${card.lastFourDigits}',
                    ),
                    _InfoCard(
                      icon: Icons.person_outline_rounded,
                      label: 'Cadastrado por',
                      value: purchase.createdBy,
                    ),
                  ],
                ),
                const SizedBox(height: 26),
                const SectionHeading(title: 'Parcelas'),
                const SizedBox(height: 12),
                Card(
                  clipBehavior: Clip.antiAlias,
                  child: Column(
                    children: [
                      for (
                        var index = 0;
                        index < installments.length;
                        index++
                      ) ...[
                        _InstallmentTile(installment: installments[index]),
                        if (index < installments.length - 1)
                          const Divider(height: 1),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 30),
                FilledButton.icon(
                  style: FilledButton.styleFrom(
                    backgroundColor: const Color(0xFFFFDAD6),
                    foregroundColor: const Color(0xFF93000A),
                  ),
                  onPressed: () => _delete(context, ref, purchase),
                  icon: const Icon(Icons.delete_outline_rounded),
                  label: const Text('Excluir compra'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                Icon(icon, size: 19, color: AppColors.textMuted),
                const SizedBox(width: 7),
                Flexible(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _InstallmentTile extends StatelessWidget {
  const _InstallmentTile({required this.installment});

  final PurchaseInstallmentRecord installment;

  @override
  Widget build(BuildContext context) {
    final isPaid = installment.status == InstallmentStatus.paid;
    final isNext =
        installment.status == InstallmentStatus.open &&
        !installment.dueDate.isBefore(DateTime.now());
    final color = isPaid
        ? AppColors.secondary
        : isNext
        ? AppColors.primary
        : AppColors.textMuted;
    return Container(
      color: isNext ? AppColors.surfaceLow : Colors.transparent,
      child: ListTile(
        minTileHeight: 76,
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: .12),
          child: Text(
            '${installment.number}/${installment.count}',
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
        title: Text(DateFormat('MMMM', 'pt_BR').format(installment.dueDate)),
        subtitle: Text(DateFormat('dd/MM/yyyy').format(installment.dueDate)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              installment.amount.format(),
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 3),
            Text(switch (installment.status) {
              InstallmentStatus.paid => 'Pago',
              InstallmentStatus.cancelled => 'Cancelada',
              InstallmentStatus.planned => 'Planejada',
              InstallmentStatus.open => isNext ? 'Próxima' : 'Pendente',
            }, style: TextStyle(color: color, fontSize: 12)),
          ],
        ),
      ),
    );
  }
}

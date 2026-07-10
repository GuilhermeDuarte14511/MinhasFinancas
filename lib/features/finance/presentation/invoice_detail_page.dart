import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class InvoiceDetailPage extends ConsumerWidget {
  const InvoiceDetailPage({required this.invoiceId, super.key});

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final invoice = finance.invoices.firstWhere((item) => item.id == invoiceId);
    final purchases = finance.purchases
        .where((purchase) => purchase.cardId == invoice.cardId)
        .toList();
    final fraction = invoice.total.isZero
        ? 0.0
        : invoice.paid.cents / invoice.total.cents;
    return Scaffold(
      appBar: BrandAppBar(title: invoice.cardName, showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            maxWidth: 680,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                DateFormat(
                                  'MMMM \'de\' yyyy',
                                  'pt_BR',
                                ).format(invoice.referenceMonth),
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ),
                            StatusPill(
                              label: _statusLabel(invoice.status),
                              color: invoice.status == InvoiceStatus.paid
                                  ? AppColors.secondary
                                  : AppColors.primary,
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const Text('TOTAL DA FATURA'),
                        Text(
                          invoice.total.format(),
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                        const SizedBox(height: 18),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Pago: ${invoice.paid.format()}',
                              style: const TextStyle(
                                color: AppColors.secondary,
                              ),
                            ),
                            Text('Pendente: ${invoice.pending.format()}'),
                          ],
                        ),
                        const SizedBox(height: 8),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: fraction.clamp(0, 1),
                            minHeight: 12,
                            color: AppColors.secondary,
                            backgroundColor: AppColors.secondaryContainer,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Vencimento: ${DateFormat('dd/MM/yyyy').format(invoice.dueDate)}',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                if (!invoice.pending.isZero)
                  FilledButton.icon(
                    onPressed: () =>
                        context.push('/invoice/$invoiceId/payment'),
                    icon: const Icon(Icons.payments_rounded),
                    label: const Text('Registrar pagamento'),
                  ),
                const SizedBox(height: 28),
                const SectionHeading(title: 'Compras nesta fatura'),
                const SizedBox(height: 12),
                if (purchases.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text('Nenhuma compra vinculada a esta fatura.'),
                    ),
                  )
                else
                  Card(
                    child: Column(
                      children: [
                        for (
                          var index = 0;
                          index < purchases.length;
                          index++
                        ) ...[
                          ListTile(
                            minTileHeight: 72,
                            onTap: () => context.push(
                              '/purchase/${purchases[index].id}',
                            ),
                            leading: const CircleAvatar(
                              backgroundColor: AppColors.surfaceContainer,
                              child: Icon(Icons.shopping_bag_outlined),
                            ),
                            title: Text(purchases[index].description),
                            subtitle: Text(
                              '${purchases[index].category} • ${purchases[index].installmentCount}x • por ${purchases[index].createdBy}',
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  purchases[index].total.format(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(Icons.chevron_right_rounded),
                              ],
                            ),
                          ),
                          if (index < purchases.length - 1)
                            const Divider(height: 1),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _statusLabel(InvoiceStatus status) => switch (status) {
  InvoiceStatus.open => 'Aberta',
  InvoiceStatus.closed => 'Fechada',
  InvoiceStatus.partiallyPaid => 'Parcialmente paga',
  InvoiceStatus.paid => 'Paga',
  InvoiceStatus.overdue => 'Vencida',
  InvoiceStatus.cancelled => 'Cancelada',
};

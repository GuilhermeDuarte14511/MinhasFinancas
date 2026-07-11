import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class CardDetailPage extends ConsumerStatefulWidget {
  const CardDetailPage({required this.cardId, super.key});

  final String cardId;

  @override
  ConsumerState<CardDetailPage> createState() => _CardDetailPageState();
}

class _CardDetailPageState extends ConsumerState<CardDetailPage> {
  var _isArchiving = false;

  @override
  Widget build(BuildContext context) {
    final finance = ref.watch(financeControllerProvider);
    final canEdit = finance.currentRole != MembershipRole.viewer;
    final card = _findCard(finance.cards, widget.cardId);
    final invoices =
        finance.invoices
            .where((invoice) => invoice.cardId == widget.cardId)
            .toList()
          ..sort((a, b) => b.referenceMonth.compareTo(a.referenceMonth));

    return Scaffold(
      appBar: BrandAppBar(
        title: card?.nickname ?? 'Cartão',
        showBack: true,
        actions: card == null
            ? null
            : [
                IconButton(
                  tooltip: 'Editar cartão',
                  onPressed: canEdit
                      ? () => context.push('/card/${card.id}/edit')
                      : null,
                  icon: const Icon(Icons.edit_outlined),
                ),
              ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(financeControllerProvider.notifier).refresh(),
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              AppContent(
                child: card == null
                    ? const _CardNotFound()
                    : StaggeredColumn(
                        step: const Duration(milliseconds: 70),
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _CardPreview(card: card),
                          const SizedBox(height: 22),
                          _LimitSummary(card: card),
                          const SizedBox(height: 28),
                          Text(
                            'Faturas',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const SizedBox(height: 12),
                          if (invoices.isEmpty)
                            const Card(
                              child: Padding(
                                padding: EdgeInsets.all(22),
                                child: Text(
                                  'Este cartão ainda não possui faturas.',
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            )
                          else
                            Card(
                              clipBehavior: Clip.antiAlias,
                              child: Column(
                                children: [
                                  for (
                                    var index = 0;
                                    index < invoices.length;
                                    index++
                                  ) ...[
                                    _InvoiceTile(invoice: invoices[index]),
                                    if (index < invoices.length - 1)
                                      const Divider(height: 1),
                                  ],
                                ],
                              ),
                            ),
                          const SizedBox(height: 28),
                          OutlinedButton.icon(
                            onPressed: _isArchiving || !canEdit
                                ? null
                                : () => _archive(card),
                            icon: _isArchiving
                                ? const SizedBox.square(
                                    dimension: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                : const Icon(Icons.archive_outlined),
                            label: const Text('Arquivar cartão'),
                          ),
                          if (!canEdit) ...[
                            const SizedBox(height: 8),
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
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _archive(CreditCardAccount card) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Arquivar cartão?'),
        content: Text(
          '${card.nickname} deixará de aparecer entre os cartões ativos. O histórico financeiro será preservado.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Arquivar'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _isArchiving = true);
    try {
      await ref.read(financeControllerProvider.notifier).archiveCard(card.id);
      if (mounted) context.pop();
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Não foi possível arquivar: $error')),
      );
    } finally {
      if (mounted) setState(() => _isArchiving = false);
    }
  }
}

CreditCardAccount? _findCard(List<CreditCardAccount> cards, String id) {
  for (final card in cards) {
    if (card.id == id) return card;
  }
  return null;
}

class _CardPreview extends StatelessWidget {
  const _CardPreview({required this.card});

  final CreditCardAccount card;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: Color(card.colorValue),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x260F172A),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  card.nickname,
                  style: const TextStyle(color: Colors.white70),
                ),
              ),
              const Icon(Icons.contactless_rounded, color: Colors.white70),
            ],
          ),
          const SizedBox(height: 22),
          Text(
            '••••  ${card.lastFourDigits}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 20),
          Text(card.cardholder, style: const TextStyle(color: Colors.white70)),
        ],
      ),
    );
  }
}

class _LimitSummary extends StatelessWidget {
  const _LimitSummary({required this.card});

  final CreditCardAccount card;

  @override
  Widget build(BuildContext context) {
    final usage = card.limit.isZero
        ? 0.0
        : card.committed.cents / card.limit.cents;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(22),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(child: _Metric('Limite total', card.limit.format())),
                Expanded(
                  child: _Metric(
                    'Disponível',
                    card.available.format(),
                    alignEnd: true,
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            LinearProgressIndicator(
              value: usage.clamp(0, 1),
              minHeight: 8,
              borderRadius: BorderRadius.circular(99),
              color: Color(card.colorValue),
              backgroundColor: AppColors.surfaceContainer,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 18),
                const SizedBox(width: 7),
                Text('Fecha dia ${card.closingDay}'),
                const Spacer(),
                const Icon(Icons.event_outlined, size: 18),
                const SizedBox(width: 7),
                Text('Vence dia ${card.dueDay}'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric(
    this.label,
    this.value, {
    this.alignEnd = false,
    this.color = AppColors.text,
  });

  final String label;
  final String value;
  final bool alignEnd;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignEnd
          ? CrossAxisAlignment.end
          : CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _InvoiceTile extends StatelessWidget {
  const _InvoiceTile({required this.invoice});

  final InvoiceSummary invoice;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minTileHeight: 72,
      onTap: () => context.push('/invoice/${invoice.id}'),
      leading: const CircleAvatar(
        backgroundColor: AppColors.surfaceContainer,
        child: Icon(Icons.receipt_long_outlined, color: AppColors.primary),
      ),
      title: Text(_monthLabel(invoice.referenceMonth)),
      subtitle: Text('Vence em ${_dateLabel(invoice.dueDate)}'),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            invoice.total.format(),
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.chevron_right_rounded),
        ],
      ),
    );
  }
}

class _CardNotFound extends StatelessWidget {
  const _CardNotFound();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          children: [
            const Icon(Icons.credit_card_off_rounded, size: 48),
            const SizedBox(height: 14),
            Text(
              'Cartão não encontrado',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            const Text(
              'Ele pode ter sido arquivado ou removido deste espaço.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

String _monthLabel(DateTime date) {
  const months = [
    'Janeiro',
    'Fevereiro',
    'Março',
    'Abril',
    'Maio',
    'Junho',
    'Julho',
    'Agosto',
    'Setembro',
    'Outubro',
    'Novembro',
    'Dezembro',
  ];
  return '${months[date.month - 1]} de ${date.year}';
}

String _dateLabel(DateTime date) =>
    '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

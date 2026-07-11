import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class LoanDetailPage extends ConsumerWidget {
  const LoanDetailPage({required this.loanId, super.key});

  final String loanId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loans = ref.watch(financeControllerProvider).loans;
    final loan = loans.cast<LoanContract?>().firstWhere(
      (item) => item?.id == loanId,
      orElse: () => null,
    );

    if (loan == null) {
      return Scaffold(
        appBar: const BrandAppBar(title: 'Empréstimo', showBack: true),
        body: const AppContent(child: _LoanNotFound()),
      );
    }

    final remaining = (loan.installmentCount - loan.paidInstallments).clamp(
      0,
      loan.installmentCount,
    );
    final progress = loan.installmentCount == 0
        ? 0.0
        : loan.paidInstallments / loan.installmentCount;

    return Scaffold(
      appBar: const BrandAppBar(
        title: 'Detalhes do empréstimo',
        showBack: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: StaggeredColumn(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _LoanHero(loan: loan),
                const SizedBox(height: 24),
                const SectionHeading(title: 'Progresso do contrato'),
                const SizedBox(height: 12),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              '${loan.paidInstallments} pagas',
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Text('$remaining restantes'),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(99),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0, 1),
                            minHeight: 12,
                            color: AppColors.secondary,
                            backgroundColor: AppColors.surfaceContainer,
                          ),
                        ),
                        const SizedBox(height: 18),
                        _DetailRow(
                          label: 'Total de parcelas',
                          value: '${loan.installmentCount}',
                        ),
                        _DetailRow(
                          label: 'Valor da parcela',
                          value: loan.installmentAmount.format(),
                        ),
                        _DetailRow(
                          label: 'Vencimento',
                          value: 'Todo dia ${loan.dueDay}',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: loan.outstandingBalance.isZero
                      ? null
                      : () => context.push('/loans/$loanId/payment'),
                  icon: const Icon(Icons.payments_rounded),
                  label: const Text('Registrar pagamento'),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Pagamentos registrados ficam disponíveis para todos os membros do espaço.',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoanHero extends StatelessWidget {
  const _LoanHero({required this.loan});

  final LoanContract loan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primaryContainer, Color(0xFF30278F)],
        ),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0x33FFFFFF),
                child: Icon(Icons.account_balance_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      loan.lender,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      loan.description,
                      style: const TextStyle(color: Color(0xFFDAD7FF)),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),
          const Text(
            'SALDO DEVEDOR',
            style: TextStyle(color: Color(0xFFDAD7FF), fontSize: 12),
          ),
          const SizedBox(height: 6),
          Text(
            loan.outstandingBalance.format(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Valor contratado: ${loan.originalAmount.format()}',
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.showDivider = true,
  });

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Expanded(child: Text(label)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        if (showDivider) const Divider(height: 1),
      ],
    );
  }
}

class _LoanNotFound extends StatelessWidget {
  const _LoanNotFound();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.search_off_rounded,
            size: 56,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Empréstimo não encontrado',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          const Text('Atualize seus dados e tente novamente.'),
        ],
      ),
    );
  }
}

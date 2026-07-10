import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class LoansPage extends ConsumerWidget {
  const LoansPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final totalDebt = finance.loans.fold(
      0,
      (total, loan) => total + loan.outstandingBalance.cents,
    );
    return Scaffold(
      appBar: const BrandAppBar(title: 'Empréstimos', showBack: true),
      body: SafeArea(
        child: SingleChildScrollView(
          child: AppContent(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Seus contratos em um só lugar',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 6),
                const Text('Acompanhe parcelas, saldos e vencimentos.'),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.primaryContainer, Color(0xFF3D37A9)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'SALDO DEVEDOR TOTAL',
                        style: TextStyle(color: Color(0xFFDAD7FF)),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Money.fromCents(totalDebt).format(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 31,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),
                const SectionHeading(title: 'Contratos ativos'),
                const SizedBox(height: 12),
                for (final loan in finance.loans) ...[
                  _LoanCard(loan: loan),
                  const SizedBox(height: 14),
                ],
                OutlinedButton.icon(
                  onPressed: () => context.push('/new-loan'),
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Adicionar empréstimo'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({required this.loan});

  final LoanContract loan;

  @override
  Widget build(BuildContext context) {
    final progress = loan.paidInstallments / loan.installmentCount;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: AppColors.surfaceContainer,
                  child: Icon(
                    Icons.account_balance_rounded,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.lender,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      Text(loan.description),
                    ],
                  ),
                ),
                StatusPill(label: 'Venc. dia ${loan.dueDay}'),
              ],
            ),
            const SizedBox(height: 18),
            const Divider(),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: _LoanMetric(
                    label: 'Saldo devedor',
                    value: loan.outstandingBalance.format(),
                  ),
                ),
                Expanded(
                  child: _LoanMetric(
                    label: 'Próxima parcela',
                    value: loan.installmentAmount.format(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                const Text('Progresso'),
                const Spacer(),
                Text('${loan.paidInstallments}/${loan.installmentCount}'),
              ],
            ),
            const SizedBox(height: 7),
            ClipRRect(
              borderRadius: BorderRadius.circular(99),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 11,
                color: AppColors.secondary,
                backgroundColor: AppColors.surfaceContainer,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanMetric extends StatelessWidget {
  const _LoanMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodySmall),
        const SizedBox(height: 4),
        FittedBox(
          child: Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

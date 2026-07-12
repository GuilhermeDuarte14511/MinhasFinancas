import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../../app/widgets/app_widgets.dart';
import '../../../core/money/money.dart';
import '../application/finance_controller.dart';
import '../domain/finance_models.dart';

class LoansPage extends ConsumerWidget {
  const LoansPage({this.embedded = false, super.key});

  final bool embedded;

  Future<void> _goBack(BuildContext context) async {
    final popped = await Navigator.of(context).maybePop();
    if (!popped && context.mounted) context.go('/app/home');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final finance = ref.watch(financeControllerProvider);
    final totalDebt = finance.loans.fold(
      0,
      (total, loan) => total + loan.outstandingBalance.cents,
    );
    final content = SafeArea(
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
              if (finance.loans.isEmpty)
                Card(
                  color: AppColors.surfaceLow,
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Nenhum empréstimo cadastrado neste espaço.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                for (var index = 0; index < finance.loans.length; index++) ...[
                  _LoanCard(loan: finance.loans[index]),
                  if (index < finance.loans.length - 1)
                    const SizedBox(height: 14),
                ],
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: finance.canEdit
                    ? () => context.push('/new-loan')
                    : null,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Adicionar empréstimo'),
              ),
            ],
          ),
        ),
      ),
    );

    if (embedded) return content;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 64,
        automaticallyImplyLeading: false,
        leading: IconButton(
          tooltip: 'Voltar',
          onPressed: () => _goBack(context),
          icon: const Icon(Icons.arrow_back_rounded),
        ),
        title: const Text(
          'Empréstimos',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
          ),
        ),
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1),
        ),
      ),
      body: content,
    );
  }
}

class _LoanCard extends StatelessWidget {
  const _LoanCard({required this.loan});

  final LoanContract loan;

  @override
  Widget build(BuildContext context) {
    final progress = loan.installmentCount == 0
        ? 0.0
        : loan.paidInstallments / loan.installmentCount;
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/loans/${loan.id}'),
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

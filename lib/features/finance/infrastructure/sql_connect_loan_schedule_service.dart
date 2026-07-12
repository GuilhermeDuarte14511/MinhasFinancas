import '../../../core/money/money.dart';
import '../domain/loan_installment_schedule.dart';
import 'sql_connect_generated/client.dart' as sql;

final class SqlConnectLoanScheduleService {
  const SqlConnectLoanScheduleService();

  Future<void> createLoan({
    required String spaceId,
    required String lender,
    required String description,
    required Money amount,
    required int installmentCount,
    required DateTime firstDueDate,
  }) async {
    final installments = const LoanInstallmentScheduleGenerator().generate(
      total: amount,
      count: installmentCount,
      firstDueDate: firstDueDate,
    );
    final client = sql.ClientConnector.instance;
    final builder =
        client.createLoan(
            spaceId: spaceId,
            name: description.trim(),
            principalAmountCents: BigInt.from(amount.cents),
            monthlyInterestRateMicros: BigInt.zero,
            amortizationMethod: sql.LoanAmortizationMethod.MANUAL,
            installmentCount: installmentCount,
            firstDueDate: installments.first.dueDate,
          )
          ..lender(lender.trim())
          ..contractedAt(DateTime.now())
          ..expectedInstallmentAmountCents(
            BigInt.from(installments.first.amount.cents),
          );

    final result = await builder.execute();
    final loanId = result.data.loan.id;
    var openingBalance = amount.cents;

    try {
      for (final installment in installments) {
        await client
            .addLoanInstallment(
              spaceId: spaceId,
              loanId: loanId,
              installmentNumber: installment.number,
              dueDate: installment.dueDate,
              openingBalanceCents: BigInt.from(openingBalance),
              principalAmountCents: BigInt.from(installment.amount.cents),
              interestAmountCents: BigInt.zero,
              totalAmountCents: BigInt.from(installment.amount.cents),
            )
            .execute();
        openingBalance -= installment.amount.cents;
      }
    } catch (_) {
      await client.cancelLoan(spaceId: spaceId, loanId: loanId).execute();
      rethrow;
    }
  }

  Future<void> cancelLoan({
    required String spaceId,
    required String loanId,
  }) async {
    final result = await sql.ClientConnector.instance
        .cancelLoan(spaceId: spaceId, loanId: loanId)
        .execute();

    if (result.data.loan == null) {
      throw StateError('Empréstimo não encontrado ou já excluído.');
    }
  }
}

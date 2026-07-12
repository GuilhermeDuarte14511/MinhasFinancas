import '../../../core/money/money.dart';
import '../domain/loan_installment_schedule.dart';
import 'sql_connect_generated/client.dart' as sql;

final class LoanScheduleService {
  const LoanScheduleService({sql.ClientConnector? connector})
    : _connector = connector;

  final sql.ClientConnector? _connector;

  sql.ClientConnector get _client => _connector ?? sql.ClientConnector.instance;

  Future<void> createLoan({
    required String spaceId,
    required String lender,
    required String description,
    required Money total,
    required int installmentCount,
    required DateTime firstDueDate,
  }) async {
    final schedule = const LoanInstallmentScheduleGenerator().generate(
      total: total,
      count: installmentCount,
      firstDueDate: firstDueDate,
    );

    final normalizedFirstDueDate = schedule.first.dueDate;
    final builder = _client.createLoan(
      spaceId: spaceId,
      name: description.trim(),
      principalAmountCents: BigInt.from(total.cents),
      monthlyInterestRateMicros: BigInt.zero,
      amortizationMethod: sql.LoanAmortizationMethod.MANUAL,
      installmentCount: installmentCount,
      firstDueDate: normalizedFirstDueDate,
    )
      ..lender(lender.trim())
      ..contractedAt(DateTime.now())
      ..expectedInstallmentAmountCents(
        BigInt.from(schedule.first.amount.cents),
      );

    final result = await builder.execute();
    final loanId = result.data.loan.id;
    var openingBalance = total.cents;

    try {
      for (final installment in schedule) {
        await _client
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
      await _client.cancelLoan(spaceId: spaceId, loanId: loanId).execute();
      rethrow;
    }
  }
}

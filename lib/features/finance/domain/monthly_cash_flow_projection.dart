import '../../../core/money/money.dart';
import 'cash_flow.dart';
import 'finance_models.dart';

/// Consolidates every inflow and outflow assigned to a calendar month.
///
/// Card purchases are represented by their invoice and loan payments by their
/// installment. This keeps the monthly result complete without counting the
/// same obligation twice.
final class MonthlyCashFlowProjection {
  const MonthlyCashFlowProjection({
    required this.month,
    required this.income,
    required this.directExpenses,
    required this.invoiceExpenses,
    required this.loanExpenses,
  });

  final DateTime month;
  final Money income;
  final Money directExpenses;
  final Money invoiceExpenses;
  final Money loanExpenses;

  Money get expenses => directExpenses + invoiceExpenses + loanExpenses;
  Money get result => income - expenses;
}

final class MonthlyCashFlowProjectionCalculator {
  const MonthlyCashFlowProjectionCalculator();

  MonthlyCashFlowProjection calculate({
    required DateTime month,
    required Iterable<CashFlowEntry> entries,
    required Iterable<InvoiceSummary> invoices,
    required Iterable<LoanContract> loans,
    required Iterable<LoanInstallmentRecord> loanInstallments,
  }) {
    final referenceMonth = DateTime(month.year, month.month);
    var income = const Money.zero();
    var directExpenses = const Money.zero();
    var invoiceExpenses = const Money.zero();
    var loanExpenses = const Money.zero();

    for (final entry in entries) {
      if (entry.status == CashFlowStatus.cancelled ||
          !_sameMonth(entry.competenceMonth, referenceMonth)) {
        continue;
      }
      // Purchases made through the card flow are accounted for by the invoice.
      if (entry.kind == CashFlowKind.cardPurchase ||
          entry.paymentMethod == CashFlowPaymentMethod.creditCard) {
        continue;
      }
      if (entry.isIncome) {
        income += entry.amount;
      } else {
        directExpenses += entry.amount;
      }
    }

    for (final invoice in invoices) {
      if (invoice.status == InvoiceStatus.cancelled ||
          !_sameMonth(invoice.dueDate, referenceMonth)) {
        continue;
      }
      invoiceExpenses += invoice.total;
    }

    final loansWithSchedule = <String>{};
    for (final installment in loanInstallments) {
      if (installment.status == LoanInstallmentStatus.cancelled) continue;
      loansWithSchedule.add(installment.loanId);
      if (_sameMonth(installment.dueDate, referenceMonth)) {
        loanExpenses += installment.total;
      }
    }

    // Older contracts may not have persisted installment records. They still
    // contribute one installment to the selected month, as in the forecast.
    for (final loan in loans) {
      if (loansWithSchedule.contains(loan.id) ||
          loan.outstandingBalance.cents <= 0 ||
          loan.installmentAmount.cents <= 0) {
        continue;
      }
      loanExpenses += loan.installmentAmount.min(loan.outstandingBalance);
    }

    return MonthlyCashFlowProjection(
      month: referenceMonth,
      income: income,
      directExpenses: directExpenses,
      invoiceExpenses: invoiceExpenses,
      loanExpenses: loanExpenses,
    );
  }
}

bool _sameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

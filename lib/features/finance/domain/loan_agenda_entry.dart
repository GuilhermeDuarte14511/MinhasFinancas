import 'finance_models.dart';

final class LoanAgendaEntry {
  const LoanAgendaEntry({required this.loan, required this.installment});

  final LoanContract loan;
  final LoanInstallmentRecord installment;
}

List<LoanAgendaEntry> loanAgendaEntriesForMonth({
  required List<LoanContract> loans,
  required List<LoanInstallmentRecord> installments,
  required DateTime month,
}) {
  final loansById = <String, LoanContract>{
    for (final loan in loans) loan.id: loan,
  };
  final entries = <LoanAgendaEntry>[];

  for (final installment in installments) {
    if (installment.status == LoanInstallmentStatus.cancelled ||
        installment.dueDate.year != month.year ||
        installment.dueDate.month != month.month) {
      continue;
    }

    final loan = loansById[installment.loanId];
    if (loan == null) continue;

    entries.add(LoanAgendaEntry(loan: loan, installment: installment));
  }

  entries.sort((first, second) {
    final dateComparison = first.installment.dueDate.compareTo(
      second.installment.dueDate,
    );
    if (dateComparison != 0) return dateComparison;
    return first.installment.number.compareTo(second.installment.number);
  });
  return entries;
}

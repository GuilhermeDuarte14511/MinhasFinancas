import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/domain/loan_agenda_entry.dart';
import 'package:nossa_grana/features/finance/domain/loan_installment_schedule.dart';

void main() {
  final loan = LoanContract(
    id: 'loan-1',
    lender: 'Banco Teste',
    description: 'Empréstimo de três parcelas',
    originalAmount: Money.fromCents(30000),
    outstandingBalance: Money.fromCents(30000),
    installmentAmount: Money.fromCents(10000),
    paidInstallments: 0,
    installmentCount: 3,
    dueDay: 31,
  );
  final schedule = const LoanInstallmentScheduleGenerator().generate(
    total: Money.fromCents(30000),
    count: 3,
    firstDueDate: DateTime(2026, 7, 31),
  );
  final installments = schedule
      .map(
        (item) => LoanInstallmentRecord(
          id: 'installment-${item.number}',
          loanId: loan.id,
          number: item.number,
          dueDate: item.dueDate,
          total: item.amount,
          paid: const Money.zero(),
          status: item.number == 1
              ? LoanInstallmentStatus.open
              : LoanInstallmentStatus.planned,
        ),
      )
      .toList();

  test('shows a three-installment loan only from July through September', () {
    final july = loanAgendaEntriesForMonth(
      loans: [loan],
      installments: installments,
      month: DateTime(2026, 7),
    );
    final august = loanAgendaEntriesForMonth(
      loans: [loan],
      installments: installments,
      month: DateTime(2026, 8),
    );
    final september = loanAgendaEntriesForMonth(
      loans: [loan],
      installments: installments,
      month: DateTime(2026, 9),
    );
    final october = loanAgendaEntriesForMonth(
      loans: [loan],
      installments: installments,
      month: DateTime(2026, 10),
    );

    expect(july.single.installment.dueDate, DateTime(2026, 7, 31));
    expect(august.single.installment.dueDate, DateTime(2026, 8, 31));
    expect(september.single.installment.dueDate, DateTime(2026, 9, 30));
    expect(october, isEmpty);
  });

  test('does not show cancelled installments', () {
    final cancelled = LoanInstallmentRecord(
      id: 'cancelled-installment',
      loanId: loan.id,
      number: 4,
      dueDate: DateTime(2026, 10, 31),
      total: Money.fromCents(10000),
      paid: const Money.zero(),
      status: LoanInstallmentStatus.cancelled,
    );

    final october = loanAgendaEntriesForMonth(
      loans: [loan],
      installments: [...installments, cancelled],
      month: DateTime(2026, 10),
    );

    expect(october, isEmpty);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/domain/loan_agenda_entry.dart';

void main() {
  const loan = LoanContract(
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

  final installments = <LoanInstallmentRecord>[
    LoanInstallmentRecord(
      id: 'installment-1',
      loanId: loan.id,
      number: 1,
      dueDate: DateTime(2026, 7, 31),
      total: Money.fromCents(10000),
      paid: const Money.zero(),
      status: LoanInstallmentStatus.open,
    ),
    LoanInstallmentRecord(
      id: 'installment-2',
      loanId: loan.id,
      number: 2,
      dueDate: DateTime(2026, 8, 31),
      total: Money.fromCents(10000),
      paid: const Money.zero(),
      status: LoanInstallmentStatus.planned,
    ),
    LoanInstallmentRecord(
      id: 'installment-3',
      loanId: loan.id,
      number: 3,
      dueDate: DateTime(2026, 9, 30),
      total: Money.fromCents(10000),
      paid: const Money.zero(),
      status: LoanInstallmentStatus.planned,
    ),
  ];

  test('shows a three-installment loan only from July through September', () {
    final july = loanAgendaEntriesForMonth(
      loans: const [loan],
      installments: installments,
      month: DateTime(2026, 7),
    );
    final august = loanAgendaEntriesForMonth(
      loans: const [loan],
      installments: installments,
      month: DateTime(2026, 8),
    );
    final september = loanAgendaEntriesForMonth(
      loans: const [loan],
      installments: installments,
      month: DateTime(2026, 9),
    );
    final october = loanAgendaEntriesForMonth(
      loans: const [loan],
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
      loans: const [loan],
      installments: [...installments, cancelled],
      month: DateTime(2026, 10),
    );

    expect(october, isEmpty);
  });
}

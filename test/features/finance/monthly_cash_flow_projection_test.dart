import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/domain/monthly_cash_flow_projection.dart';

void main() {
  test(
    'monthly projection combines every source once and subtracts all expenses',
    () {
      final projection = const MonthlyCashFlowProjectionCalculator().calculate(
        month: DateTime(2026, 7),
        entries: [
          _entry(
            id: 'salary',
            cents: 500000,
            direction: CashFlowDirection.income,
            status: CashFlowStatus.confirmed,
          ),
          _entry(
            id: 'bonus',
            cents: 100000,
            direction: CashFlowDirection.income,
            status: CashFlowStatus.scheduled,
          ),
          _entry(
            id: 'rent',
            cents: 150000,
            direction: CashFlowDirection.expense,
            status: CashFlowStatus.confirmed,
          ),
          _entry(
            id: 'bill',
            cents: 50000,
            direction: CashFlowDirection.expense,
            status: CashFlowStatus.scheduled,
          ),
          _entry(
            id: 'cancelled',
            cents: 999999,
            direction: CashFlowDirection.expense,
            status: CashFlowStatus.cancelled,
          ),
          _entry(
            id: 'card-purchase',
            cents: 80000,
            direction: CashFlowDirection.expense,
            status: CashFlowStatus.confirmed,
            kind: CashFlowKind.cardPurchase,
            method: CashFlowPaymentMethod.creditCard,
          ),
          _entry(
            id: 'next-month',
            cents: 700000,
            direction: CashFlowDirection.income,
            status: CashFlowStatus.scheduled,
            competenceMonth: DateTime(2026, 8),
          ),
        ],
        invoices: [
          _invoice(
            id: 'paid-invoice',
            cents: 120000,
            status: InvoiceStatus.paid,
          ),
          _invoice(
            id: 'open-invoice',
            cents: 80000,
            status: InvoiceStatus.partiallyPaid,
          ),
          _invoice(
            id: 'cancelled-invoice',
            cents: 900000,
            status: InvoiceStatus.cancelled,
          ),
          _invoice(
            id: 'next-invoice',
            cents: 100000,
            status: InvoiceStatus.open,
            dueDate: DateTime(2026, 8, 10),
          ),
        ],
        loans: [
          _loan(id: 'scheduled-loan'),
          _loan(
            id: 'legacy-loan',
            installmentCents: 20000,
            outstandingCents: 15000,
          ),
        ],
        loanInstallments: [
          _loanInstallment(
            id: 'paid-installment',
            loanId: 'scheduled-loan',
            cents: 30000,
            status: LoanInstallmentStatus.paid,
          ),
          _loanInstallment(
            id: 'open-installment',
            loanId: 'scheduled-loan',
            cents: 40000,
            status: LoanInstallmentStatus.open,
          ),
          _loanInstallment(
            id: 'cancelled-installment',
            loanId: 'scheduled-loan',
            cents: 500000,
            status: LoanInstallmentStatus.cancelled,
          ),
          _loanInstallment(
            id: 'next-installment',
            loanId: 'scheduled-loan',
            cents: 60000,
            status: LoanInstallmentStatus.open,
            dueDate: DateTime(2026, 8, 10),
          ),
        ],
      );

      expect(projection.income.cents, 600000);
      expect(projection.directExpenses.cents, 200000);
      expect(projection.invoiceExpenses.cents, 200000);
      expect(projection.loanExpenses.cents, 85000);
      expect(projection.expenses.cents, 485000);
      expect(projection.result.cents, 115000);
    },
  );
}

CashFlowEntry _entry({
  required String id,
  required int cents,
  required CashFlowDirection direction,
  required CashFlowStatus status,
  DateTime? competenceMonth,
  CashFlowKind? kind,
  CashFlowPaymentMethod method = CashFlowPaymentMethod.pix,
}) => CashFlowEntry(
  id: id,
  direction: direction,
  kind:
      kind ??
      (direction == CashFlowDirection.income
          ? CashFlowKind.salary
          : CashFlowKind.bill),
  paymentMethod: method,
  description: id,
  amount: Money.fromCents(cents),
  occurredAt: DateTime(2026, 7, 10),
  competenceMonth: competenceMonth ?? DateTime(2026, 7),
  status: status,
  createdBy: 'Teste',
);

InvoiceSummary _invoice({
  required String id,
  required int cents,
  required InvoiceStatus status,
  DateTime? dueDate,
}) => InvoiceSummary(
  id: id,
  cardId: 'card',
  cardName: 'Principal',
  referenceMonth: DateTime(2026, 7),
  dueDate: dueDate ?? DateTime(2026, 7, 15),
  total: Money.fromCents(cents),
  paid: status == InvoiceStatus.partiallyPaid
      ? Money.fromCents(cents ~/ 2)
      : status == InvoiceStatus.paid
      ? Money.fromCents(cents)
      : const Money.zero(),
  status: status,
);

LoanContract _loan({
  required String id,
  int installmentCents = 30000,
  int outstandingCents = 90000,
}) => LoanContract(
  id: id,
  lender: 'Banco',
  description: id,
  originalAmount: Money.fromCents(100000),
  outstandingBalance: Money.fromCents(outstandingCents),
  installmentAmount: Money.fromCents(installmentCents),
  paidInstallments: 0,
  installmentCount: 3,
  dueDay: 10,
);

LoanInstallmentRecord _loanInstallment({
  required String id,
  required String loanId,
  required int cents,
  required LoanInstallmentStatus status,
  DateTime? dueDate,
}) => LoanInstallmentRecord(
  id: id,
  loanId: loanId,
  number: 1,
  dueDate: dueDate ?? DateTime(2026, 7, 10),
  total: Money.fromCents(cents),
  paid: status == LoanInstallmentStatus.paid
      ? Money.fromCents(cents)
      : const Money.zero(),
  status: status,
);

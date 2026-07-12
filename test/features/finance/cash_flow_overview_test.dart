import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';

void main() {
  group('CashFlowOverview', () {
    test('calculates month, year and lifetime without floating point', () {
      final overview = CashFlowOverview.fromEntries(
        referenceDate: DateTime(2026, 7, 11),
        entries: [
          _entry(
            id: 'salary',
            direction: CashFlowDirection.income,
            amountCents: 500000,
            date: DateTime(2026, 7, 5),
          ),
          _entry(
            id: 'bill',
            direction: CashFlowDirection.expense,
            amountCents: 125050,
            date: DateTime(2026, 7, 8),
          ),
          _entry(
            id: 'old-income',
            direction: CashFlowDirection.income,
            amountCents: 100000,
            date: DateTime(2025, 12, 20),
          ),
        ],
      );

      expect(overview.currentMonth.income.cents, 500000);
      expect(overview.currentMonth.expense.cents, 125050);
      expect(overview.currentMonth.result.cents, 374950);
      expect(overview.currentYear.result.cents, 374950);
      expect(overview.lifetime.result.cents, 474950);
      expect(overview.firstRecordMonth, DateTime(2025, 12));
    });

    test('exposes shortfall when expenses are greater than income', () {
      const totals = PeriodTotals(income: Money.zero(), expense: Money.zero());
      final negative = totals
          .add(CashFlowDirection.income, Money.fromCents(10000))
          .add(CashFlowDirection.expense, Money.fromCents(15000));

      expect(negative.result.cents, -5000);
      expect(negative.surplus.cents, 0);
      expect(negative.shortfall.cents, 5000);
    });

    test('recognizes expenses in their competence month', () {
      final overview = CashFlowOverview.fromEntries(
        entries: [
          _entry(
            id: 'installment-july',
            direction: CashFlowDirection.expense,
            amountCents: 10000,
            date: DateTime(2026, 7, 10),
          ),
          _entry(
            id: 'installment-august',
            direction: CashFlowDirection.expense,
            amountCents: 10000,
            date: DateTime(2026, 8, 10),
          ),
        ],
        referenceDate: DateTime(2026, 7, 11),
      );

      expect(overview.currentMonth.expense.cents, 10000);
      expect(overview.currentYear.expense.cents, 20000);
      expect(overview.lifetime.expense.cents, 20000);
    });
  });
}

CashFlowEntry _entry({
  required String id,
  required CashFlowDirection direction,
  required int amountCents,
  required DateTime date,
}) => CashFlowEntry(
  id: id,
  direction: direction,
  kind: direction == CashFlowDirection.income
      ? CashFlowKind.salary
      : CashFlowKind.bill,
  paymentMethod: CashFlowPaymentMethod.pix,
  description: id,
  amount: Money.fromCents(amountCents),
  occurredAt: date,
  competenceMonth: DateTime(date.year, date.month),
  status: CashFlowStatus.confirmed,
  createdBy: 'Teste',
);

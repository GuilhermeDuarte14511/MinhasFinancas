import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow_forecast.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';

void main() {
  group('CashFlowForecastCalculator', () {
    test(
      'combines pending cash, invoices and loans without double counting',
      () {
        final forecast = const CashFlowForecastCalculator().calculate(
          openingBalance: Money.fromCents(100000),
          entries: [
            _entry(
              id: 'salary',
              cents: 50000,
              direction: CashFlowDirection.income,
              date: DateTime(2026, 7, 15),
            ),
            _entry(
              id: 'rent',
              cents: 30000,
              direction: CashFlowDirection.expense,
              date: DateTime(2026, 7, 12),
            ),
            _entry(
              id: 'already-paid',
              cents: 10000,
              direction: CashFlowDirection.expense,
              date: DateTime(2026, 7, 11),
              status: CashFlowStatus.confirmed,
            ),
            _entry(
              id: 'card-purchase',
              cents: 99900,
              direction: CashFlowDirection.expense,
              date: DateTime(2026, 7, 13),
              kind: CashFlowKind.cardPurchase,
              method: CashFlowPaymentMethod.creditCard,
            ),
          ],
          invoices: [
            InvoiceSummary(
              id: 'invoice',
              cardId: 'card',
              cardName: 'Principal',
              referenceMonth: DateTime(2026, 7),
              dueDate: DateTime(2026, 7, 20),
              total: Money.fromCents(50000),
              paid: Money.fromCents(10000),
              status: InvoiceStatus.partiallyPaid,
            ),
          ],
          loans: [
            LoanContract(
              id: 'loan',
              lender: 'Banco',
              description: 'Empréstimo pessoal',
              originalAmount: Money.fromCents(100000),
              outstandingBalance: Money.fromCents(60000),
              installmentAmount: Money.fromCents(20000),
              paidInstallments: 0,
              installmentCount: 3,
              dueDay: 18,
            ),
          ],
          loanInstallments: [
            LoanInstallmentRecord(
              id: 'loan-1',
              loanId: 'loan',
              number: 1,
              dueDate: DateTime(2026, 7, 18),
              total: Money.fromCents(20000),
              paid: Money.fromCents(5000),
              status: LoanInstallmentStatus.partiallyPaid,
            ),
          ],
          referenceDate: DateTime(2026, 7, 10),
          throughDate: DateTime(2026, 7, 31),
        );

        expect(forecast.lines, hasLength(4));
        expect(forecast.expectedIncome.cents, 50000);
        expect(forecast.expectedExpenses.cents, 85000);
        expect(forecast.closingBalance.cents, 65000);
        expect(forecast.lowestBalance.cents, 65000);
        expect(
          forecast.lines.map((line) => line.event.id),
          containsAll(<String>[
            'cash-flow:salary',
            'cash-flow:rent',
            'invoice:invoice',
            'loan-installment:loan-1',
          ]),
        );
        expect(
          forecast.lines.map((line) => line.event.id),
          isNot(contains('cash-flow:card-purchase')),
        );
      },
    );

    test('applies overdue expenses immediately and exposes negative risk', () {
      final forecast = const CashFlowForecastCalculator().calculate(
        openingBalance: Money.fromCents(10000),
        entries: [
          _entry(
            id: 'late-bill',
            cents: 15000,
            direction: CashFlowDirection.expense,
            date: DateTime(2026, 7, 8),
          ),
          _entry(
            id: 'income-today',
            cents: 30000,
            direction: CashFlowDirection.income,
            date: DateTime(2026, 7, 10),
          ),
        ],
        invoices: const [],
        loans: const [],
        loanInstallments: const [],
        referenceDate: DateTime(2026, 7, 10, 14),
        throughDate: DateTime(2026, 7, 20),
      );

      expect(forecast.overdueCount, 1);
      expect(forecast.hasNegativeBalanceRisk, isTrue);
      expect(forecast.lowestBalance.cents, -5000);
      expect(forecast.lowestBalanceDate, DateTime(2026, 7, 10));
      expect(forecast.closingBalance.cents, 25000);
    });

    test('projects legacy loans that do not have installment records', () {
      final forecast = const CashFlowForecastCalculator().calculate(
        openingBalance: Money.fromCents(100000),
        entries: const [],
        invoices: const [],
        loans: [
          LoanContract(
            id: 'legacy',
            lender: 'Pessoa',
            description: 'Acordo antigo',
            originalAmount: Money.fromCents(50000),
            outstandingBalance: Money.fromCents(25000),
            installmentAmount: Money.fromCents(10000),
            paidInstallments: 0,
            installmentCount: 3,
            dueDay: 31,
          ),
        ],
        loanInstallments: const [],
        referenceDate: DateTime(2026, 7, 13),
        throughDate: DateTime(2026, 9, 30),
      );

      expect(forecast.lines, hasLength(3));
      expect(forecast.expectedExpenses.cents, 25000);
      expect(forecast.lines.first.event.date, DateTime(2026, 7, 31));
      expect(forecast.lines.last.event.amount.cents, 5000);
    });
  });
}

CashFlowEntry _entry({
  required String id,
  required int cents,
  required CashFlowDirection direction,
  required DateTime date,
  CashFlowStatus status = CashFlowStatus.scheduled,
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
  occurredAt: date,
  competenceMonth: DateTime(date.year, date.month),
  status: status,
  createdBy: 'Pessoa',
);

import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/cash_flow.dart';
import 'package:nossa_grana/features/finance/domain/finance_models.dart';
import 'package:nossa_grana/features/finance/domain/financial_planning.dart';

void main() {
  group('AccountBalanceCalculator', () {
    test(
      'separates current and projected balances without counting transfers as flow',
      () {
        final accounts = [
          FinancialAccount(
            id: 'main',
            name: 'Conta principal',
            type: FinancialAccountType.checking,
            openingBalance: Money.fromCents(100000),
            openingBalanceAt: DateTime(2026, 7, 1),
            colorValue: 0xFF3525CD,
            includeInTotal: true,
          ),
          FinancialAccount(
            id: 'cash',
            name: 'Carteira',
            type: FinancialAccountType.cash,
            openingBalance: const Money.zero(),
            openingBalanceAt: DateTime(2026, 7, 1),
            colorValue: 0xFF006A63,
            includeInTotal: true,
          ),
        ];
        final entries = [
          _entry(
            'income',
            'main',
            50000,
            CashFlowDirection.income,
            CashFlowStatus.confirmed,
            DateTime(2026, 7, 5),
          ),
          _entry(
            'expense',
            'main',
            20000,
            CashFlowDirection.expense,
            CashFlowStatus.confirmed,
            DateTime(2026, 7, 6),
          ),
          _entry(
            'planned',
            'main',
            10000,
            CashFlowDirection.expense,
            CashFlowStatus.scheduled,
            DateTime(2026, 7, 20),
          ),
          _entry(
            'unassigned',
            null,
            99900,
            CashFlowDirection.income,
            CashFlowStatus.confirmed,
            DateTime(2026, 7, 7),
          ),
        ];
        final position = const AccountBalanceCalculator().calculate(
          accounts: accounts,
          entries: entries,
          transfers: [
            AccountTransfer(
              id: 'transfer',
              fromAccountId: 'main',
              toAccountId: 'cash',
              amount: Money.fromCents(5000),
              transferredAt: DateTime(2026, 7, 8),
            ),
          ],
          settlements: [
            AccountSettlement(
              id: 'invoice-payment',
              accountId: 'main',
              amount: Money.fromCents(10000),
              paidAt: DateTime(2026, 7, 9),
            ),
          ],
          asOf: DateTime(2026, 7, 10),
        );

        expect(position.accounts[0].currentBalance.cents, 115000);
        expect(position.accounts[0].projectedBalance.cents, 105000);
        expect(position.accounts[1].currentBalance.cents, 5000);
        expect(position.currentBalance.cents, 120000);
        expect(position.projectedBalance.cents, 110000);
      },
    );
  });

  group('MonthlyBudgetCalculator', () {
    test('combines cash expenses and card installments by category', () {
      final budget = MonthlyBudget(
        id: 'budget-market',
        categoryId: 'market',
        categoryName: 'Mercado',
        referenceMonth: DateTime(2026, 7),
        limit: Money.fromCents(100000),
      );
      final result = const MonthlyBudgetCalculator().calculate(
        budgets: [budget],
        entries: [
          _entry(
            'market-expense',
            null,
            20000,
            CashFlowDirection.expense,
            CashFlowStatus.confirmed,
            DateTime(2026, 7, 5),
            category: 'Mercado',
          ),
          _entry(
            'cancelled',
            null,
            90000,
            CashFlowDirection.expense,
            CashFlowStatus.cancelled,
            DateTime(2026, 7, 6),
            category: 'Mercado',
          ),
        ],
        purchases: [
          PurchaseRecord(
            id: 'purchase',
            description: 'Supermercado',
            category: 'Mercado',
            cardId: 'card',
            total: Money.fromCents(60000),
            installmentCount: 2,
            purchaseDate: DateTime(2026, 6, 20),
            createdBy: 'Pessoa',
          ),
        ],
        installments: [
          PurchaseInstallmentRecord(
            id: 'installment',
            purchaseId: 'purchase',
            invoiceId: 'invoice',
            number: 1,
            count: 2,
            amount: Money.fromCents(30000),
            dueDate: DateTime(2026, 7, 10),
            status: InstallmentStatus.open,
          ),
        ],
        referenceMonth: DateTime(2026, 7),
      );

      expect(result.single.committed.cents, 50000);
      expect(result.single.remaining.cents, 50000);
      expect(result.single.usage, .5);
    });
  });
}

CashFlowEntry _entry(
  String id,
  String? accountId,
  int cents,
  CashFlowDirection direction,
  CashFlowStatus status,
  DateTime date, {
  String? category,
}) => CashFlowEntry(
  id: id,
  direction: direction,
  kind: direction == CashFlowDirection.income
      ? CashFlowKind.salary
      : CashFlowKind.bill,
  paymentMethod: CashFlowPaymentMethod.pix,
  description: id,
  amount: Money.fromCents(cents),
  occurredAt: date,
  competenceMonth: DateTime(date.year, date.month),
  status: status,
  createdBy: 'Pessoa',
  accountId: accountId,
  categoryName: category,
);

import '../../../core/money/money.dart';
import 'cash_flow.dart';
import 'finance_models.dart';

enum FinancialAccountType { checking, savings, cash, investment, other }

final class FinancialAccount {
  const FinancialAccount({
    required this.id,
    required this.name,
    required this.type,
    required this.openingBalance,
    required this.openingBalanceAt,
    required this.colorValue,
    required this.includeInTotal,
    this.institutionName,
  });

  final String id;
  final String name;
  final String? institutionName;
  final FinancialAccountType type;
  final Money openingBalance;
  final DateTime openingBalanceAt;
  final int colorValue;
  final bool includeInTotal;
}

final class AccountTransfer {
  const AccountTransfer({
    required this.id,
    required this.fromAccountId,
    required this.toAccountId,
    required this.amount,
    required this.transferredAt,
    this.notes,
  });

  final String id;
  final String fromAccountId;
  final String toAccountId;
  final Money amount;
  final DateTime transferredAt;
  final String? notes;
}

final class MonthlyBudget {
  const MonthlyBudget({
    required this.id,
    required this.categoryId,
    required this.categoryName,
    required this.referenceMonth,
    required this.limit,
  });

  final String id;
  final String categoryId;
  final String categoryName;
  final DateTime referenceMonth;
  final Money limit;
}

final class AccountSettlement {
  const AccountSettlement({
    required this.id,
    required this.accountId,
    required this.amount,
    required this.paidAt,
  });

  final String id;
  final String accountId;
  final Money amount;
  final DateTime paidAt;
}

final class AccountPosition {
  const AccountPosition({
    required this.account,
    required this.currentBalance,
    required this.projectedBalance,
  });

  final FinancialAccount account;
  final Money currentBalance;
  final Money projectedBalance;
}

final class FinancialPosition {
  const FinancialPosition({required this.accounts});

  final List<AccountPosition> accounts;

  Money get currentBalance => accounts
      .where((item) => item.account.includeInTotal)
      .fold(const Money.zero(), (total, item) => total + item.currentBalance);

  Money get projectedBalance => accounts
      .where((item) => item.account.includeInTotal)
      .fold(const Money.zero(), (total, item) => total + item.projectedBalance);
}

final class AccountBalanceCalculator {
  const AccountBalanceCalculator();

  FinancialPosition calculate({
    required Iterable<FinancialAccount> accounts,
    required Iterable<CashFlowEntry> entries,
    required Iterable<AccountTransfer> transfers,
    Iterable<AccountSettlement> settlements = const [],
    required DateTime asOf,
  }) {
    final positions = <AccountPosition>[];
    for (final account in accounts) {
      var current = account.openingBalance;
      var projected = account.openingBalance;
      for (final entry in entries) {
        if (entry.accountId != account.id ||
            entry.status == CashFlowStatus.cancelled ||
            entry.occurredAt.isBefore(account.openingBalanceAt)) {
          continue;
        }
        final signed = entry.isIncome
            ? entry.amount
            : Money.fromCents(-entry.amount.cents);
        projected += signed;
        if (entry.status == CashFlowStatus.confirmed &&
            !entry.occurredAt.isAfter(asOf)) {
          current += signed;
        }
      }
      for (final transfer in transfers) {
        if (transfer.transferredAt.isBefore(account.openingBalanceAt)) {
          continue;
        }
        final signed = transfer.toAccountId == account.id
            ? transfer.amount
            : transfer.fromAccountId == account.id
            ? Money.fromCents(-transfer.amount.cents)
            : const Money.zero();
        projected += signed;
        if (!transfer.transferredAt.isAfter(asOf)) current += signed;
      }
      for (final settlement in settlements) {
        if (settlement.accountId != account.id ||
            settlement.paidAt.isBefore(account.openingBalanceAt)) {
          continue;
        }
        final debit = Money.fromCents(-settlement.amount.cents);
        projected += debit;
        if (!settlement.paidAt.isAfter(asOf)) current += debit;
      }
      positions.add(
        AccountPosition(
          account: account,
          currentBalance: current,
          projectedBalance: projected,
        ),
      );
    }
    return FinancialPosition(accounts: positions);
  }
}

final class BudgetProgress {
  const BudgetProgress({required this.budget, required this.committed});

  final MonthlyBudget budget;
  final Money committed;

  Money get remaining => budget.limit - committed;
  bool get isExceeded => remaining.isNegative;
  double get usage {
    if (budget.limit.cents <= 0) return committed.cents > 0 ? 1 : 0;
    return committed.cents / budget.limit.cents;
  }
}

final class MonthlyBudgetCalculator {
  const MonthlyBudgetCalculator();

  List<BudgetProgress> calculate({
    required Iterable<MonthlyBudget> budgets,
    required Iterable<CashFlowEntry> entries,
    required Iterable<PurchaseRecord> purchases,
    required Iterable<PurchaseInstallmentRecord> installments,
    required DateTime referenceMonth,
  }) {
    final month = DateTime(referenceMonth.year, referenceMonth.month);
    final purchaseById = {for (final item in purchases) item.id: item};
    final committedByCategory = <String, Money>{};
    void add(String category, Money amount) {
      committedByCategory[category] =
          (committedByCategory[category] ?? const Money.zero()) + amount;
    }

    for (final entry in entries) {
      if (entry.isIncome ||
          entry.status == CashFlowStatus.cancelled ||
          !_sameMonth(entry.competenceMonth, month)) {
        continue;
      }
      final category = entry.categoryName;
      if (category != null) add(category, entry.amount);
    }
    for (final installment in installments) {
      if (installment.status == InstallmentStatus.cancelled ||
          !_sameMonth(installment.dueDate, month)) {
        continue;
      }
      final purchase = purchaseById[installment.purchaseId];
      if (purchase != null) add(purchase.category, installment.amount);
    }

    return [
      for (final budget in budgets)
        if (_sameMonth(budget.referenceMonth, month))
          BudgetProgress(
            budget: budget,
            committed:
                committedByCategory[budget.categoryName] ?? const Money.zero(),
          ),
    ]..sort((a, b) => b.usage.compareTo(a.usage));
  }
}

bool _sameMonth(DateTime first, DateTime second) =>
    first.year == second.year && first.month == second.month;

import '../../../core/money/money.dart';

enum CashFlowDirection { income, expense }

enum CashFlowKind {
  salary,
  thirteenthSalary,
  vacationPay,
  bonus,
  refund,
  bill,
  cashPurchase,
  cardPurchase,
  subscription,
  tax,
  loanPayment,
  otherIncome,
  otherExpense,
}

enum CashFlowPaymentMethod {
  pix,
  cash,
  bankTransfer,
  debitCard,
  creditCard,
  other,
}

enum CashFlowStatus { scheduled, confirmed, cancelled }

enum RecurrenceFrequency { none, weekly, biweekly, monthly, yearly }

enum RecurrenceScope { single, thisAndFuture, entireSeries }

final class RecurrenceRule {
  const RecurrenceRule({
    required this.frequency,
    this.endDate,
    this.occurrenceCount,
    this.preferredDay,
    this.withoutEnd = false,
  });

  final RecurrenceFrequency frequency;
  final DateTime? endDate;
  final int? occurrenceCount;
  final int? preferredDay;
  final bool withoutEnd;

  bool get isRecurring => frequency != RecurrenceFrequency.none;
}

final class CashFlowEntry {
  const CashFlowEntry({
    required this.id,
    required this.direction,
    required this.kind,
    required this.paymentMethod,
    required this.description,
    required this.amount,
    required this.occurredAt,
    required this.competenceMonth,
    required this.status,
    required this.createdBy,
    this.categoryId,
    this.categoryName,
    this.notes,
    this.sourceType,
    this.sourceEntityId,
    this.recurrenceSeriesId,
    this.occurrenceIndex,
    this.isRecurrenceException = false,
    this.receivedAt,
    this.paidAt,
  });

  final String id;
  final CashFlowDirection direction;
  final CashFlowKind kind;
  final CashFlowPaymentMethod paymentMethod;
  final String description;
  final Money amount;
  final DateTime occurredAt;
  final DateTime competenceMonth;
  final CashFlowStatus status;
  final String createdBy;
  final String? categoryId;
  final String? categoryName;
  final String? notes;
  final String? sourceType;
  final String? sourceEntityId;
  final String? recurrenceSeriesId;
  final int? occurrenceIndex;
  final bool isRecurrenceException;
  final DateTime? receivedAt;
  final DateTime? paidAt;

  bool get isIncome => direction == CashFlowDirection.income;
  bool get isScheduled => status == CashFlowStatus.scheduled;
  bool get isRecurring => recurrenceSeriesId != null;
}

final class PeriodTotals {
  const PeriodTotals({required this.income, required this.expense});

  const PeriodTotals.zero()
    : income = const Money.zero(),
      expense = const Money.zero();

  final Money income;
  final Money expense;

  Money get result => income - expense;
  Money get surplus => result.isNegative ? const Money.zero() : result;
  Money get shortfall => result.isNegative
      ? Money.fromCents(result.cents.abs())
      : const Money.zero();

  PeriodTotals add(CashFlowDirection direction, Money amount) =>
      switch (direction) {
        CashFlowDirection.income => PeriodTotals(
          income: income + amount,
          expense: expense,
        ),
        CashFlowDirection.expense => PeriodTotals(
          income: income,
          expense: expense + amount,
        ),
      };

  PeriodTotals addExpense(Money amount) =>
      PeriodTotals(income: income, expense: expense + amount);

  PeriodTotals merge(PeriodTotals other) => PeriodTotals(
    income: income + other.income,
    expense: expense + other.expense,
  );
}

final class MonthlyCashFlow {
  const MonthlyCashFlow({required this.month, required this.totals});

  final DateTime month;
  final PeriodTotals totals;

  MonthlyCashFlow addExpense(Money amount) =>
      MonthlyCashFlow(month: month, totals: totals.addExpense(amount));
}

final class CashFlowOverview {
  const CashFlowOverview({
    required this.referenceMonth,
    required this.currentMonth,
    required this.currentYear,
    required this.lifetime,
    required this.yearSeries,
    this.currentMonthPlanned = const PeriodTotals.zero(),
    this.currentYearPlanned = const PeriodTotals.zero(),
    this.firstRecordMonth,
    this.lastRecordMonth,
  });

  factory CashFlowOverview.fromEntries({
    required Iterable<CashFlowEntry> entries,
    required DateTime referenceDate,
  }) {
    final referenceMonth = _monthOf(referenceDate);
    final yearSeries = _emptyYear(referenceDate.year);
    var month = const PeriodTotals.zero();
    var year = const PeriodTotals.zero();
    var plannedMonth = const PeriodTotals.zero();
    var plannedYear = const PeriodTotals.zero();
    var lifetime = const PeriodTotals.zero();
    DateTime? firstRecord;
    DateTime? lastRecord;

    for (final entry in entries) {
      final competence = _monthOf(entry.competenceMonth);
      if (entry.status == CashFlowStatus.scheduled) {
        if (competence.year == referenceDate.year) {
          plannedYear = plannedYear.add(entry.direction, entry.amount);
          if (competence == referenceMonth) {
            plannedMonth = plannedMonth.add(entry.direction, entry.amount);
          }
        }
        continue;
      }
      if (entry.status != CashFlowStatus.confirmed) continue;
      lifetime = lifetime.add(entry.direction, entry.amount);
      firstRecord = _earlier(firstRecord, competence);
      lastRecord = _later(lastRecord, competence);
      if (competence.year != referenceDate.year) continue;
      year = year.add(entry.direction, entry.amount);
      final index = competence.month - 1;
      yearSeries[index] = MonthlyCashFlow(
        month: yearSeries[index].month,
        totals: yearSeries[index].totals.add(entry.direction, entry.amount),
      );
      if (competence == referenceMonth) {
        month = month.add(entry.direction, entry.amount);
      }
    }

    return CashFlowOverview(
      referenceMonth: referenceMonth,
      currentMonth: month,
      currentYear: year,
      lifetime: lifetime,
      yearSeries: yearSeries,
      currentMonthPlanned: plannedMonth,
      currentYearPlanned: plannedYear,
      firstRecordMonth: firstRecord,
      lastRecordMonth: lastRecord,
    );
  }

  factory CashFlowOverview.empty(DateTime referenceDate) => CashFlowOverview(
    referenceMonth: _monthOf(referenceDate),
    currentMonth: const PeriodTotals.zero(),
    currentYear: const PeriodTotals.zero(),
    lifetime: const PeriodTotals.zero(),
    yearSeries: _emptyYear(referenceDate.year),
    currentMonthPlanned: const PeriodTotals.zero(),
    currentYearPlanned: const PeriodTotals.zero(),
  );

  final DateTime referenceMonth;
  final PeriodTotals currentMonth;
  final PeriodTotals currentYear;
  final PeriodTotals lifetime;
  final List<MonthlyCashFlow> yearSeries;
  final PeriodTotals currentMonthPlanned;
  final PeriodTotals currentYearPlanned;
  final DateTime? firstRecordMonth;
  final DateTime? lastRecordMonth;

  PeriodTotals get projectedMonth => currentMonth.merge(currentMonthPlanned);
  PeriodTotals get projectedYear => currentYear.merge(currentYearPlanned);

  static List<MonthlyCashFlow> _emptyYear(int year) => [
    for (var month = 1; month <= 12; month++)
      MonthlyCashFlow(
        month: DateTime(year, month),
        totals: const PeriodTotals.zero(),
      ),
  ];
}

DateTime _monthOf(DateTime value) => DateTime(value.year, value.month);

DateTime? _earlier(DateTime? current, DateTime candidate) {
  if (current == null || candidate.isBefore(current)) return candidate;
  return current;
}

DateTime? _later(DateTime? current, DateTime candidate) {
  if (current == null || candidate.isAfter(current)) return candidate;
  return current;
}

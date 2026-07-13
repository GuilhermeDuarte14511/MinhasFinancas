import '../../../core/money/money.dart';
import 'cash_flow.dart';
import 'finance_models.dart';

enum CashForecastSource { cashFlow, invoice, loanInstallment }

enum CashForecastEventStatus { planned, overdue }

final class CashForecastEvent {
  const CashForecastEvent({
    required this.id,
    required this.sourceId,
    required this.source,
    required this.title,
    required this.date,
    required this.direction,
    required this.amount,
    required this.status,
  });

  final String id;
  final String sourceId;
  final CashForecastSource source;
  final String title;
  final DateTime date;
  final CashFlowDirection direction;
  final Money amount;
  final CashForecastEventStatus status;

  bool get isIncome => direction == CashFlowDirection.income;
  bool get isOverdue => status == CashForecastEventStatus.overdue;
  Money get signedAmount => isIncome ? amount : Money.fromCents(-amount.cents);
}

final class CashForecastLine {
  const CashForecastLine({
    required this.event,
    required this.projectedAt,
    required this.balanceAfter,
  });

  final CashForecastEvent event;
  final DateTime projectedAt;
  final Money balanceAfter;
}

final class CashFlowForecast {
  const CashFlowForecast({
    required this.referenceDate,
    required this.throughDate,
    required this.openingBalance,
    required this.expectedIncome,
    required this.expectedExpenses,
    required this.closingBalance,
    required this.lowestBalance,
    required this.lowestBalanceDate,
    required this.lines,
  });

  final DateTime referenceDate;
  final DateTime throughDate;
  final Money openingBalance;
  final Money expectedIncome;
  final Money expectedExpenses;
  final Money closingBalance;
  final Money lowestBalance;
  final DateTime lowestBalanceDate;
  final List<CashForecastLine> lines;

  int get overdueCount => lines.where((line) => line.event.isOverdue).length;
  bool get hasNegativeBalanceRisk => lowestBalance.isNegative;
}

/// Builds a cash forecast from obligations that have not affected an account
/// balance yet. Confirmed entries and registered payments are already reflected
/// in [openingBalance], so only pending events are applied here.
final class CashFlowForecastCalculator {
  const CashFlowForecastCalculator();

  CashFlowForecast calculate({
    required Money openingBalance,
    required Iterable<CashFlowEntry> entries,
    required Iterable<InvoiceSummary> invoices,
    required Iterable<LoanContract> loans,
    required Iterable<LoanInstallmentRecord> loanInstallments,
    required DateTime referenceDate,
    required DateTime throughDate,
  }) {
    final start = _dateOnly(referenceDate);
    final end = _dateOnly(throughDate);
    if (end.isBefore(start)) {
      return CashFlowForecast(
        referenceDate: start,
        throughDate: end,
        openingBalance: openingBalance,
        expectedIncome: const Money.zero(),
        expectedExpenses: const Money.zero(),
        closingBalance: openingBalance,
        lowestBalance: openingBalance,
        lowestBalanceDate: start,
        lines: const [],
      );
    }

    final events = <CashForecastEvent>[];
    for (final entry in entries) {
      if (entry.status != CashFlowStatus.scheduled ||
          _dateOnly(entry.occurredAt).isAfter(end)) {
        continue;
      }
      // A card purchase affects cash only through its invoice.
      if (entry.kind == CashFlowKind.cardPurchase ||
          entry.paymentMethod == CashFlowPaymentMethod.creditCard) {
        continue;
      }
      events.add(
        CashForecastEvent(
          id: 'cash-flow:${entry.id}',
          sourceId: entry.id,
          source: CashForecastSource.cashFlow,
          title: entry.description,
          date: _dateOnly(entry.occurredAt),
          direction: entry.direction,
          amount: entry.amount,
          status: _statusFor(_dateOnly(entry.occurredAt), start),
        ),
      );
    }

    for (final invoice in invoices) {
      if (invoice.status == InvoiceStatus.cancelled ||
          invoice.status == InvoiceStatus.paid ||
          invoice.pending.cents <= 0 ||
          _dateOnly(invoice.dueDate).isAfter(end)) {
        continue;
      }
      events.add(
        CashForecastEvent(
          id: 'invoice:${invoice.id}',
          sourceId: invoice.id,
          source: CashForecastSource.invoice,
          title: 'Fatura ${invoice.cardName}',
          date: _dateOnly(invoice.dueDate),
          direction: CashFlowDirection.expense,
          amount: invoice.pending,
          status:
              invoice.status == InvoiceStatus.overdue ||
                  _dateOnly(invoice.dueDate).isBefore(start)
              ? CashForecastEventStatus.overdue
              : CashForecastEventStatus.planned,
        ),
      );
    }

    final loansById = {for (final loan in loans) loan.id: loan};
    final loansWithSchedule = <String>{};
    for (final installment in loanInstallments) {
      if (installment.status == LoanInstallmentStatus.cancelled) continue;
      loansWithSchedule.add(installment.loanId);
      if (installment.status == LoanInstallmentStatus.paid ||
          installment.pending.cents <= 0 ||
          _dateOnly(installment.dueDate).isAfter(end)) {
        continue;
      }
      final loan = loansById[installment.loanId];
      events.add(
        CashForecastEvent(
          id: 'loan-installment:${installment.id}',
          sourceId: installment.loanId,
          source: CashForecastSource.loanInstallment,
          title: loan?.description ?? 'Parcela de empréstimo',
          date: _dateOnly(installment.dueDate),
          direction: CashFlowDirection.expense,
          amount: installment.pending,
          status:
              installment.status == LoanInstallmentStatus.overdue ||
                  _dateOnly(installment.dueDate).isBefore(start)
              ? CashForecastEventStatus.overdue
              : CashForecastEventStatus.planned,
        ),
      );
    }

    for (final loan in loans) {
      if (loansWithSchedule.contains(loan.id) ||
          loan.outstandingBalance.cents <= 0 ||
          loan.installmentAmount.cents <= 0) {
        continue;
      }
      _addLegacyLoanEvents(events, loan, start, end);
    }

    events.sort((first, second) {
      final firstProjection = first.date.isBefore(start) ? start : first.date;
      final secondProjection = second.date.isBefore(start)
          ? start
          : second.date;
      final byDate = firstProjection.compareTo(secondProjection);
      if (byDate != 0) return byDate;
      if (first.isIncome != second.isIncome) return first.isIncome ? 1 : -1;
      return first.title.compareTo(second.title);
    });

    var balance = openingBalance;
    var lowest = openingBalance;
    var lowestDate = start;
    var income = const Money.zero();
    var expenses = const Money.zero();
    final lines = <CashForecastLine>[];
    for (final event in events) {
      balance += event.signedAmount;
      if (event.isIncome) {
        income += event.amount;
      } else {
        expenses += event.amount;
      }
      final projectedAt = event.date.isBefore(start) ? start : event.date;
      if (balance.cents < lowest.cents) {
        lowest = balance;
        lowestDate = projectedAt;
      }
      lines.add(
        CashForecastLine(
          event: event,
          projectedAt: projectedAt,
          balanceAfter: balance,
        ),
      );
    }

    return CashFlowForecast(
      referenceDate: start,
      throughDate: end,
      openingBalance: openingBalance,
      expectedIncome: income,
      expectedExpenses: expenses,
      closingBalance: balance,
      lowestBalance: lowest,
      lowestBalanceDate: lowestDate,
      lines: List.unmodifiable(lines),
    );
  }

  void _addLegacyLoanEvents(
    List<CashForecastEvent> events,
    LoanContract loan,
    DateTime start,
    DateTime end,
  ) {
    var remaining = loan.outstandingBalance;
    var month = DateTime(start.year, start.month);
    while (!month.isAfter(DateTime(end.year, end.month)) &&
        remaining.cents > 0) {
      final dueDate = _safeDate(month.year, month.month, loan.dueDay);
      if (!dueDate.isAfter(end)) {
        final amount = loan.installmentAmount.min(remaining);
        events.add(
          CashForecastEvent(
            id: 'legacy-loan:${loan.id}:${month.year}-${month.month}',
            sourceId: loan.id,
            source: CashForecastSource.loanInstallment,
            title: loan.description,
            date: dueDate,
            direction: CashFlowDirection.expense,
            amount: amount,
            status: _statusFor(dueDate, start),
          ),
        );
        remaining -= amount;
      }
      month = DateTime(month.year, month.month + 1);
    }
  }
}

CashForecastEventStatus _statusFor(DateTime dueDate, DateTime referenceDate) =>
    dueDate.isBefore(referenceDate)
    ? CashForecastEventStatus.overdue
    : CashForecastEventStatus.planned;

DateTime _safeDate(int year, int month, int preferredDay) {
  final lastDay = DateTime(year, month + 1, 0).day;
  return DateTime(year, month, preferredDay.clamp(1, lastDay));
}

DateTime _dateOnly(DateTime value) =>
    DateTime(value.year, value.month, value.day);

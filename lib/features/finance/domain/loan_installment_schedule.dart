import '../../../core/money/money.dart';

final class LoanInstallmentPlanItem {
  const LoanInstallmentPlanItem({
    required this.number,
    required this.amount,
    required this.dueDate,
  });

  final int number;
  final Money amount;
  final DateTime dueDate;
}

final class LoanInstallmentScheduleGenerator {
  const LoanInstallmentScheduleGenerator();

  List<LoanInstallmentPlanItem> generate({
    required Money total,
    required int count,
    required DateTime firstDueDate,
  }) {
    if (total.cents <= 0) {
      throw ArgumentError.value(total, 'total', 'Deve ser maior que zero.');
    }
    if (count < 1 || count > 360) {
      throw RangeError.range(count, 1, 360, 'count');
    }

    final normalizedFirstDate = DateTime(
      firstDueDate.year,
      firstDueDate.month,
      firstDueDate.day,
    );
    final preferredDay = normalizedFirstDate.day;
    final baseAmount = total.cents ~/ count;
    final remainder = total.cents % count;

    return List.generate(count, (index) {
      final extraCent = index < remainder ? 1 : 0;
      return LoanInstallmentPlanItem(
        number: index + 1,
        amount: Money.fromCents(baseAmount + extraCent),
        dueDate: _safeDate(
          normalizedFirstDate.year,
          normalizedFirstDate.month + index,
          preferredDay,
        ),
      );
    });
  }
}

DateTime _safeDate(int year, int month, int preferredDay) {
  final firstDayOfMonth = DateTime(year, month);
  final lastDay = DateTime(
    firstDayOfMonth.year,
    firstDayOfMonth.month + 1,
    0,
  ).day;
  final resolvedDay = preferredDay > lastDay ? lastDay : preferredDay;
  return DateTime(firstDayOfMonth.year, firstDayOfMonth.month, resolvedDay);
}

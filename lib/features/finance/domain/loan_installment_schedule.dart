import 'dart:math' as math;

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
    if (count > total.cents) {
      throw ArgumentError.value(
        count,
        'count',
        'Cada parcela precisa ter pelo menos um centavo.',
      );
    }

    final normalizedFirstDueDate = DateTime(
      firstDueDate.year,
      firstDueDate.month,
      firstDueDate.day,
    );
    final baseAmount = total.cents ~/ count;
    final remainder = total.cents % count;

    return List.generate(count, (index) {
      final extraCent = index < remainder ? 1 : 0;
      return LoanInstallmentPlanItem(
        number: index + 1,
        amount: Money.fromCents(baseAmount + extraCent),
        dueDate: _addMonthsClamped(normalizedFirstDueDate, index),
      );
    });
  }

  DateTime _addMonthsClamped(DateTime date, int monthsToAdd) {
    final targetMonth = DateTime(date.year, date.month + monthsToAdd);
    final lastDayOfTargetMonth = DateTime(
      targetMonth.year,
      targetMonth.month + 1,
      0,
    ).day;
    return DateTime(
      targetMonth.year,
      targetMonth.month,
      math.min(date.day, lastDayOfTargetMonth),
    );
  }
}

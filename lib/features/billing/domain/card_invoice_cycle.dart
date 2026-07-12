final class CardInvoiceCycle {
  const CardInvoiceCycle({
    required this.referenceMonth,
    required this.closingDate,
    required this.dueDate,
  });

  final DateTime referenceMonth;
  final DateTime closingDate;
  final DateTime dueDate;
}

final class CardInvoiceCycleCalculator {
  const CardInvoiceCycleCalculator();

  CardInvoiceCycle calculate({
    required DateTime purchaseDate,
    required int closingDay,
    required int dueDay,
  }) {
    _validateCardDay(closingDay, 'closingDay');
    _validateCardDay(dueDay, 'dueDay');

    final purchaseDay = _dateOnly(purchaseDate);
    final closingDate = _clampedDate(
      purchaseDay.year,
      purchaseDay.month,
      closingDay,
      isUtc: purchaseDay.isUtc,
    );
    final monthOffset = purchaseDay.isAfter(closingDate) ? 1 : 0;
    final referenceMonth = _calendarDate(
      purchaseDay.year,
      purchaseDay.month + monthOffset,
      1,
      isUtc: purchaseDay.isUtc,
    );
    final dueDate = _clampedDate(
      referenceMonth.year,
      referenceMonth.month,
      dueDay,
      isUtc: referenceMonth.isUtc,
    );

    return CardInvoiceCycle(
      referenceMonth: referenceMonth,
      closingDate: closingDate,
      dueDate: dueDate,
    );
  }
}

void _validateCardDay(int value, String name) {
  if (value < 1 || value > 31) {
    throw RangeError.range(value, 1, 31, name);
  }
}

DateTime _dateOnly(DateTime value) =>
    _calendarDate(value.year, value.month, value.day, isUtc: value.isUtc);

DateTime _clampedDate(
  int year,
  int month,
  int preferredDay, {
  required bool isUtc,
}) {
  final lastDay = _calendarDate(year, month + 1, 0, isUtc: isUtc).day;
  final day = preferredDay > lastDay ? lastDay : preferredDay;
  return _calendarDate(year, month, day, isUtc: isUtc);
}

DateTime _calendarDate(int year, int month, int day, {required bool isUtc}) =>
    isUtc ? DateTime.utc(year, month, day) : DateTime(year, month, day);

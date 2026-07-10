import '../../../core/money/money.dart';

final class Installment {
  const Installment({
    required this.number,
    required this.amount,
    required this.referenceMonth,
  });

  final int number;
  final Money amount;
  final DateTime referenceMonth;
}

final class InstallmentScheduleGenerator {
  const InstallmentScheduleGenerator();

  List<Installment> generate({
    required Money total,
    required int count,
    required DateTime firstReferenceMonth,
  }) {
    if (total.cents <= 0) {
      throw ArgumentError.value(total, 'total', 'Deve ser maior que zero.');
    }
    if (count < 1 || count > 24) {
      throw RangeError.range(count, 1, 24, 'count');
    }

    final normalizedMonth = DateTime(
      firstReferenceMonth.year,
      firstReferenceMonth.month,
    );
    final base = total.cents ~/ count;
    final remainder = total.cents % count;

    return List.generate(count, (index) {
      final extraCent = index < remainder ? 1 : 0;
      return Installment(
        number: index + 1,
        amount: Money.fromCents(base + extraCent),
        referenceMonth: DateTime(
          normalizedMonth.year,
          normalizedMonth.month + index,
        ),
      );
    });
  }
}

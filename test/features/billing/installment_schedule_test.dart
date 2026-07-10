import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/billing/domain/installment_schedule.dart';

void main() {
  const generator = InstallmentScheduleGenerator();

  test('single payment keeps the complete amount', () {
    final schedule = generator.generate(
      total: Money.fromCents(129900),
      count: 1,
      firstReferenceMonth: DateTime(2026, 8),
    );

    expect(schedule, hasLength(1));
    expect(schedule.single.amount.cents, 129900);
  });

  test('three installments distribute remainder deterministically', () {
    final schedule = generator.generate(
      total: Money.fromCents(1000),
      count: 3,
      firstReferenceMonth: DateTime(2026, 12),
    );

    expect(schedule.map((item) => item.amount.cents), [334, 333, 333]);
    expect(schedule.fold(0, (total, item) => total + item.amount.cents), 1000);
    expect(schedule[1].referenceMonth, DateTime(2027));
  });

  test('supports 24 installments and a leap-year February', () {
    final schedule = generator.generate(
      total: Money.fromCents(240001),
      count: 24,
      firstReferenceMonth: DateTime(2028, 2, 29),
    );

    expect(schedule, hasLength(24));
    expect(schedule.first.referenceMonth, DateTime(2028, 2));
    expect(schedule.last.referenceMonth, DateTime(2030, 1));
    expect(
      schedule.fold(0, (total, item) => total + item.amount.cents),
      240001,
    );
  });

  test('rejects invalid installment counts', () {
    expect(
      () => generator.generate(
        total: Money.fromCents(100),
        count: 25,
        firstReferenceMonth: DateTime(2026, 1),
      ),
      throwsRangeError,
    );
  });
}

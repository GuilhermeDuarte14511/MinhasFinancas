import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/loan_installment_schedule.dart';

void main() {
  const generator = LoanInstallmentScheduleGenerator();

  test('distributes the total and preserves the selected first due date', () {
    final schedule = generator.generate(
      total: Money.fromCents(1000),
      count: 3,
      firstDueDate: DateTime(2026, 7, 30),
    );

    expect(schedule.map((item) => item.amount.cents), [334, 333, 333]);
    expect(schedule.first.dueDate, DateTime(2026, 7, 30));
    expect(schedule.last.dueDate, DateTime(2026, 9, 30));
    expect(
      schedule.fold(0, (total, item) => total + item.amount.cents),
      1000,
    );
  });

  test('clamps day 31 in shorter months and restores it when possible', () {
    final schedule = generator.generate(
      total: Money.fromCents(30000),
      count: 3,
      firstDueDate: DateTime(2027, 1, 31),
    );

    expect(schedule[0].dueDate, DateTime(2027, 1, 31));
    expect(schedule[1].dueDate, DateTime(2027, 2, 28));
    expect(schedule[2].dueDate, DateTime(2027, 3, 31));
  });

  test('supports long financing schedules', () {
    final schedule = generator.generate(
      total: Money.fromCents(3600000),
      count: 360,
      firstDueDate: DateTime(2026, 8, 15),
    );

    expect(schedule, hasLength(360));
    expect(schedule.first.amount.cents, 10000);
    expect(schedule.last.dueDate, DateTime(2056, 7, 15));
  });

  test('rejects a schedule with installments below one cent', () {
    expect(
      () => generator.generate(
        total: Money.fromCents(2),
        count: 3,
        firstDueDate: DateTime(2026, 8, 15),
      ),
      throwsArgumentError,
    );
  });
}

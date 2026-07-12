import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';
import 'package:nossa_grana/features/finance/domain/loan_installment_schedule.dart';

void main() {
  const generator = LoanInstallmentScheduleGenerator();

  test('divide o valor total sem perder centavos', () {
    final schedule = generator.generate(
      total: Money.fromCents(10000),
      count: 3,
      firstDueDate: DateTime(2026, 8, 10),
    );

    expect(schedule.map((item) => item.amount.cents), [3334, 3333, 3333]);
    expect(
      schedule.fold<int>(0, (total, item) => total + item.amount.cents),
      10000,
    );
  });

  test('preserva o dia preferido depois de um mês mais curto', () {
    final schedule = generator.generate(
      total: Money.fromCents(30000),
      count: 3,
      firstDueDate: DateTime(2026, 1, 31),
    );

    expect(schedule[0].dueDate, DateTime(2026, 1, 31));
    expect(schedule[1].dueDate, DateTime(2026, 2, 28));
    expect(schedule[2].dueDate, DateTime(2026, 3, 31));
  });

  test('calcula corretamente a data da última parcela', () {
    final schedule = generator.generate(
      total: Money.fromCents(120000),
      count: 12,
      firstDueDate: DateTime(2026, 8, 15),
    );

    expect(schedule.first.dueDate, DateTime(2026, 8, 15));
    expect(schedule.last.dueDate, DateTime(2027, 7, 15));
  });
}

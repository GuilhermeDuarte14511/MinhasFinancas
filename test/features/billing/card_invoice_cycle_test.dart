import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/features/billing/domain/card_invoice_cycle.dart';

void main() {
  const calculator = CardInvoiceCycleCalculator();

  group('CardInvoiceCycleCalculator', () {
    test('keeps a purchase before closing in the current invoice', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 7, 12),
        closingDay: 15,
        dueDay: 31,
      );

      expect(cycle.referenceMonth, DateTime(2026, 7));
      expect(cycle.dueDate, DateTime(2026, 7, 31));
    });

    test('keeps a purchase made on closing day in current invoice', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 7, 15, 23, 59),
        closingDay: 15,
        dueDay: 31,
      );

      expect(cycle.referenceMonth, DateTime(2026, 7));
    });

    test('moves a purchase after closing to the next invoice', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 7, 16),
        closingDay: 15,
        dueDay: 20,
      );

      expect(cycle.referenceMonth, DateTime(2026, 8));
      expect(cycle.dueDate, DateTime(2026, 8, 20));
    });

    test('moves a December purchase to January of the next year', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 12, 20),
        closingDay: 15,
        dueDay: 10,
      );

      expect(cycle.referenceMonth, DateTime(2027));
      expect(cycle.dueDate, DateTime(2027, 1, 10));
    });

    test('clamps due day 31 to the last day of a 30-day month', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 4, 10),
        closingDay: 15,
        dueDay: 31,
      );

      expect(cycle.dueDate, DateTime(2026, 4, 30));
    });

    test('clamps due day 31 in common and leap-year February', () {
      final commonYear = calculator.calculate(
        purchaseDate: DateTime(2026, 2, 10),
        closingDay: 15,
        dueDay: 31,
      );
      final leapYear = calculator.calculate(
        purchaseDate: DateTime(2028, 2, 10),
        closingDay: 15,
        dueDay: 31,
      );

      expect(commonYear.dueDate, DateTime(2026, 2, 28));
      expect(leapYear.dueDate, DateTime(2028, 2, 29));
    });

    test('clamps closing day and treats the last valid day as closing', () {
      final cycle = calculator.calculate(
        purchaseDate: DateTime(2026, 2, 28),
        closingDay: 31,
        dueDay: 30,
      );

      expect(cycle.closingDate, DateTime(2026, 2, 28));
      expect(cycle.referenceMonth, DateTime(2026, 2));
      expect(cycle.dueDate, DateTime(2026, 2, 28));
    });

    test('rejects card days outside the supported range', () {
      expect(
        () => calculator.calculate(
          purchaseDate: DateTime(2026, 7, 10),
          closingDay: 0,
          dueDay: 10,
        ),
        throwsRangeError,
      );
      expect(
        () => calculator.calculate(
          purchaseDate: DateTime(2026, 7, 10),
          closingDay: 10,
          dueDay: 32,
        ),
        throwsRangeError,
      );
    });
  });
}

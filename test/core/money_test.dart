import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/core/money/money.dart';

void main() {
  group('Money', () {
    test('keeps exact cents when adding and subtracting', () {
      final total = Money.fromCents(1001) + Money.fromCents(299);

      expect(total, Money.fromCents(1300));
      expect(total - Money.fromCents(1), Money.fromCents(1299));
    });

    test('parses Brazilian decimal strings without floating point', () {
      expect(Money.fromDecimalString('R\$ 1.250,90').cents, 125090);
      expect(Money.fromDecimalString('-0,50').cents, -50);
    });

    test('formats Brazilian currency', () {
      expect(Money.fromCents(125090).format(), 'R\$ 1.250,90');
    });

    test('compares large integer amounts', () {
      final larger = Money.fromCents(9000000000000000);
      final smaller = Money.fromCents(8999999999999999);

      expect(larger.compareTo(smaller), greaterThan(0));
    });
  });
}

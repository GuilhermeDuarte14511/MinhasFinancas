import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/app/widgets/app_widgets.dart';

void main() {
  group('CurrencyInputFormatter', () {
    const formatter = CurrencyInputFormatter();

    test('formats digits as Brazilian currency', () {
      final formatted = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '123456'),
      );

      expect(formatted.text, '1.234,56');
      expect(formatted.selection.baseOffset, formatted.text.length);
    });

    test('keeps cents exact while the user types', () {
      expect(CurrencyInputFormatter.centsFromText('0,01'), 1);
      expect(CurrencyInputFormatter.centsFromText('12,34'), 1234);
      expect(CurrencyInputFormatter.formatCents(1234), '12,34');
    });

    test('formats pasted BRL values and large amounts', () {
      expect(CurrencyInputFormatter.centsFromText('R\$ 1.234,56'), 123456);

      final formatted = formatter.formatEditUpdate(
        TextEditingValue.empty,
        const TextEditingValue(text: '232131231231212'),
      );

      expect(formatted.text, '2.321.312.312.312,12');
    });

    test('clears the value after deleting all digits', () {
      final formatted = formatter.formatEditUpdate(
        const TextEditingValue(text: '0,01'),
        TextEditingValue.empty,
      );

      expect(formatted.text, isEmpty);
      expect(CurrencyInputFormatter.centsFromText(formatted.text), 0);
    });
  });
}

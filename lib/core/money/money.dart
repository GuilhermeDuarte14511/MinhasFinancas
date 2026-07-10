final class Money implements Comparable<Money> {
  const Money._(this.cents);

  const Money.zero() : cents = 0;

  factory Money.fromCents(int cents) => Money._(cents);

  factory Money.fromDecimalString(String value) {
    var normalized = value
        .replaceAll('R\$', '')
        .replaceAll(RegExp(r'\s'), '')
        .trim();
    if (normalized.contains(',')) {
      normalized = normalized.replaceAll('.', '').replaceAll(',', '.');
    }
    final parts = normalized.split('.');
    if (parts.length > 2 || parts.first.isEmpty) {
      throw const FormatException('Valor monetário inválido.');
    }
    final isNegative = normalized.startsWith('-');
    final whole = int.parse(parts.first);
    final decimal = parts.length == 1
        ? 0
        : int.parse(parts.last.padRight(2, '0').substring(0, 2));
    final absoluteWhole = whole.abs();
    final cents = absoluteWhole * 100 + decimal;
    return Money._(isNegative ? -cents : cents);
  }

  final int cents;

  bool get isNegative => cents < 0;
  bool get isZero => cents == 0;

  Money operator +(Money other) => Money._(cents + other.cents);
  Money operator -(Money other) => Money._(cents - other.cents);

  Money min(Money other) => cents <= other.cents ? this : other;

  String format({String locale = 'pt_BR'}) {
    if (locale != 'pt_BR') {
      throw ArgumentError.value(locale, 'locale', 'Somente pt_BR é suportado.');
    }
    final absoluteCents = cents.abs();
    final wholeDigits = (absoluteCents ~/ 100).toString();
    final groups = <String>[];
    for (var end = wholeDigits.length; end > 0; end -= 3) {
      final start = (end - 3).clamp(0, end);
      groups.add(wholeDigits.substring(start, end));
    }
    final whole = groups.reversed.join('.');
    final decimal = (absoluteCents % 100).toString().padLeft(2, '0');
    final sign = isNegative ? '-' : '';
    return '${sign}R\$\u00A0$whole,$decimal';
  }

  @override
  int compareTo(Money other) => cents.compareTo(other.cents);

  @override
  bool operator ==(Object other) => other is Money && other.cents == cents;

  @override
  int get hashCode => cents.hashCode;

  @override
  String toString() => format();
}

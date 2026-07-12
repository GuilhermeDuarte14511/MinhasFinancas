enum RecurrenceFrequency { weekly, biweekly, monthly, yearly }

final class RecurrenceOccurrenceKey {
  const RecurrenceOccurrenceKey._({
    required this.seriesId,
    required this.year,
    required this.month,
    required this.day,
  });

  factory RecurrenceOccurrenceKey({
    required String seriesId,
    required DateTime scheduledDate,
  }) => RecurrenceOccurrenceKey._(
    seriesId: seriesId,
    year: scheduledDate.year,
    month: scheduledDate.month,
    day: scheduledDate.day,
  );

  final String seriesId;
  final int year;
  final int month;
  final int day;

  String get value {
    final formattedMonth = month.toString().padLeft(2, '0');
    final formattedDay = day.toString().padLeft(2, '0');
    return '$seriesId:$year-$formattedMonth-$formattedDay';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecurrenceOccurrenceKey &&
          seriesId == other.seriesId &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => Object.hash(seriesId, year, month, day);
}

final class RecurrenceOccurrence {
  const RecurrenceOccurrence({
    required this.seriesId,
    required this.sequence,
    required this.scheduledDate,
  });

  final String seriesId;
  final int sequence;
  final DateTime scheduledDate;

  RecurrenceOccurrenceKey get key =>
      RecurrenceOccurrenceKey(seriesId: seriesId, scheduledDate: scheduledDate);
}

final class RecurrenceScheduleGenerator {
  const RecurrenceScheduleGenerator();

  List<RecurrenceOccurrence> generate({
    required String seriesId,
    required DateTime startsOn,
    required RecurrenceFrequency frequency,
    DateTime? endsOn,
    int? occurrenceCount,
    int? preferredDay,
    Iterable<RecurrenceOccurrenceKey> existingKeys = const [],
  }) {
    _validateRule(
      seriesId: seriesId,
      startsOn: startsOn,
      endsOn: endsOn,
      occurrenceCount: occurrenceCount,
      preferredDay: preferredDay,
    );

    final start = _dateOnly(startsOn);
    final end = endsOn == null ? null : _dateOnly(endsOn);
    final anchorDay = preferredDay ?? start.day;
    final knownKeys = existingKeys.toSet();
    final generatedKeys = <RecurrenceOccurrenceKey>{};
    final occurrences = <RecurrenceOccurrence>[];

    for (var index = 0; _isWithinCount(index, occurrenceCount); index++) {
      final scheduledDate = _occurrenceDate(
        start: start,
        frequency: frequency,
        index: index,
        anchorDay: anchorDay,
      );
      if (end != null && scheduledDate.isAfter(end)) break;

      final occurrence = RecurrenceOccurrence(
        seriesId: seriesId,
        sequence: index + 1,
        scheduledDate: scheduledDate,
      );
      if (knownKeys.contains(occurrence.key)) continue;
      if (!generatedKeys.add(occurrence.key)) continue;
      occurrences.add(occurrence);
    }

    return List.unmodifiable(occurrences);
  }
}

void _validateRule({
  required String seriesId,
  required DateTime startsOn,
  required DateTime? endsOn,
  required int? occurrenceCount,
  required int? preferredDay,
}) {
  if (seriesId.trim().isEmpty) {
    throw ArgumentError.value(seriesId, 'seriesId', 'Não pode ser vazio.');
  }
  if (endsOn == null && occurrenceCount == null) {
    throw ArgumentError(
      'Informe endsOn ou occurrenceCount para limitar a geração.',
    );
  }
  if (occurrenceCount != null && occurrenceCount < 1) {
    throw RangeError.range(occurrenceCount, 1, null, 'occurrenceCount');
  }
  if (preferredDay != null && (preferredDay < 1 || preferredDay > 31)) {
    throw RangeError.range(preferredDay, 1, 31, 'preferredDay');
  }
  if (endsOn != null && _dateOnly(endsOn).isBefore(_dateOnly(startsOn))) {
    throw ArgumentError.value(endsOn, 'endsOn', 'Deve ser igual ou posterior.');
  }
}

bool _isWithinCount(int index, int? occurrenceCount) =>
    occurrenceCount == null || index < occurrenceCount;

DateTime _occurrenceDate({
  required DateTime start,
  required RecurrenceFrequency frequency,
  required int index,
  required int anchorDay,
}) => switch (frequency) {
  RecurrenceFrequency.weekly => _calendarDate(
    start.year,
    start.month,
    start.day + (index * 7),
    isUtc: start.isUtc,
  ),
  RecurrenceFrequency.biweekly => _calendarDate(
    start.year,
    start.month,
    start.day + (index * 14),
    isUtc: start.isUtc,
  ),
  RecurrenceFrequency.monthly when index == 0 => start,
  RecurrenceFrequency.monthly => _clampedDate(
    start.year,
    start.month + index,
    anchorDay,
    isUtc: start.isUtc,
  ),
  RecurrenceFrequency.yearly when index == 0 => start,
  RecurrenceFrequency.yearly => _clampedDate(
    start.year + index,
    start.month,
    anchorDay,
    isUtc: start.isUtc,
  ),
};

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

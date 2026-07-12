import 'package:flutter_test/flutter_test.dart';
import 'package:nossa_grana/features/billing/domain/recurrence_schedule.dart';

void main() {
  const generator = RecurrenceScheduleGenerator();

  group('RecurrenceScheduleGenerator', () {
    test('generates weekly and biweekly occurrences', () {
      final weekly = generator.generate(
        seriesId: 'weekly-income',
        startsOn: DateTime(2026, 7, 1),
        frequency: RecurrenceFrequency.weekly,
        occurrenceCount: 3,
      );
      final biweekly = generator.generate(
        seriesId: 'biweekly-income',
        startsOn: DateTime(2026, 7, 1),
        frequency: RecurrenceFrequency.biweekly,
        occurrenceCount: 3,
      );

      expect(weekly.map((item) => item.scheduledDate), [
        DateTime(2026, 7, 1),
        DateTime(2026, 7, 8),
        DateTime(2026, 7, 15),
      ]);
      expect(biweekly.map((item) => item.scheduledDate), [
        DateTime(2026, 7, 1),
        DateTime(2026, 7, 15),
        DateTime(2026, 7, 29),
      ]);
    });

    test('monthly day 30 clamps in February and restores the anchor', () {
      final occurrences = generator.generate(
        seriesId: 'salary-30',
        startsOn: DateTime(2026, 1, 30),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 4,
        preferredDay: 30,
      );

      expect(occurrences.map((item) => item.scheduledDate), [
        DateTime(2026, 1, 30),
        DateTime(2026, 2, 28),
        DateTime(2026, 3, 30),
        DateTime(2026, 4, 30),
      ]);
    });

    test('monthly day 31 clamps short months and crosses the year', () {
      final occurrences = generator.generate(
        seriesId: 'salary-31',
        startsOn: DateTime(2026, 10, 31),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 5,
      );

      expect(occurrences.map((item) => item.scheduledDate), [
        DateTime(2026, 10, 31),
        DateTime(2026, 11, 30),
        DateTime(2026, 12, 31),
        DateTime(2027, 1, 31),
        DateTime(2027, 2, 28),
      ]);
    });

    test('yearly recurrence restores leap day in the next leap year', () {
      final occurrences = generator.generate(
        seriesId: 'leap-income',
        startsOn: DateTime(2028, 2, 29),
        frequency: RecurrenceFrequency.yearly,
        occurrenceCount: 5,
      );

      expect(occurrences.map((item) => item.scheduledDate), [
        DateTime(2028, 2, 29),
        DateTime(2029, 2, 28),
        DateTime(2030, 2, 28),
        DateTime(2031, 2, 28),
        DateTime(2032, 2, 29),
      ]);
    });

    test('end date is inclusive', () {
      final occurrences = generator.generate(
        seriesId: 'weekly-until',
        startsOn: DateTime(2026, 7, 1),
        frequency: RecurrenceFrequency.weekly,
        endsOn: DateTime(2026, 7, 15),
      );

      expect(occurrences, hasLength(3));
      expect(occurrences.last.scheduledDate, DateTime(2026, 7, 15));
    });

    test('stops at whichever limit is reached first', () {
      final countFirst = generator.generate(
        seriesId: 'count-first',
        startsOn: DateTime(2026, 7, 1),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 2,
        endsOn: DateTime(2027, 7, 1),
      );
      final endFirst = generator.generate(
        seriesId: 'end-first',
        startsOn: DateTime(2026, 7, 1),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 12,
        endsOn: DateTime(2026, 8, 1),
      );

      expect(countFirst, hasLength(2));
      expect(endFirst, hasLength(2));
    });

    test('does not duplicate existing logical keys or extend count', () {
      final existing = RecurrenceOccurrenceKey(
        seriesId: 'salary',
        scheduledDate: DateTime.utc(2026, 7, 31, 20),
      );
      final occurrences = generator.generate(
        seriesId: 'salary',
        startsOn: DateTime(2026, 7, 31),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 3,
        existingKeys: [existing, existing],
      );

      expect(occurrences, hasLength(2));
      expect(occurrences.first.sequence, 2);
      expect(occurrences.first.scheduledDate, DateTime(2026, 8, 31));
      expect(occurrences.last.scheduledDate, DateTime(2026, 9, 30));
      expect(occurrences.map((item) => item.key).toSet(), hasLength(2));
      expect(existing.value, 'salary:2026-07-31');
    });

    test('the same date in a different series is not a duplicate', () {
      final occurrences = generator.generate(
        seriesId: 'salary-b',
        startsOn: DateTime(2026, 7, 31),
        frequency: RecurrenceFrequency.monthly,
        occurrenceCount: 1,
        existingKeys: [
          RecurrenceOccurrenceKey(
            seriesId: 'salary-a',
            scheduledDate: DateTime(2026, 7, 31),
          ),
        ],
      );

      expect(occurrences, hasLength(1));
    });

    test('rejects an unbounded or otherwise invalid rule', () {
      expect(
        () => generator.generate(
          seriesId: 'salary',
          startsOn: DateTime(2026, 7, 1),
          frequency: RecurrenceFrequency.monthly,
        ),
        throwsArgumentError,
      );
      expect(
        () => generator.generate(
          seriesId: 'salary',
          startsOn: DateTime(2026, 7, 1),
          frequency: RecurrenceFrequency.monthly,
          occurrenceCount: 1,
          preferredDay: 32,
        ),
        throwsRangeError,
      );
    });
  });
}

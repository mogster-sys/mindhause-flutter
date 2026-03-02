import 'package:flutter_test/flutter_test.dart';

import 'package:mindhause/shared/services/recurrence_service.dart';

void main() {
  group('RecurrenceRule.nextDate', () {
    test('daily adds 1 day', () {
      final from = DateTime(2025, 3, 15);
      final next = RecurrenceRule.nextDate('daily', from);
      expect(next, DateTime(2025, 3, 16));
    });

    test('weekly adds 7 days', () {
      final from = DateTime(2025, 3, 15);
      final next = RecurrenceRule.nextDate('weekly', from);
      expect(next, DateTime(2025, 3, 22));
    });

    test('biweekly adds 14 days', () {
      final from = DateTime(2025, 3, 15);
      final next = RecurrenceRule.nextDate('biweekly', from);
      expect(next, DateTime(2025, 3, 29));
    });

    test('monthly advances month', () {
      final from = DateTime(2025, 3, 15);
      final next = RecurrenceRule.nextDate('monthly', from);
      expect(next, DateTime(2025, 4, 15));
    });

    test('monthly clamps day for short months (Jan 31 → Feb 28)', () {
      final from = DateTime(2025, 1, 31);
      final next = RecurrenceRule.nextDate('monthly', from);
      expect(next, DateTime(2025, 2, 28));
    });

    test('monthly clamps for leap year (Jan 31 → Feb 29)', () {
      final from = DateTime(2024, 1, 31);
      final next = RecurrenceRule.nextDate('monthly', from);
      expect(next, DateTime(2024, 2, 29));
    });

    test('monthly wraps year (Dec → Jan)', () {
      final from = DateTime(2025, 12, 15);
      final next = RecurrenceRule.nextDate('monthly', from);
      expect(next, DateTime(2026, 1, 15));
    });

    test('yearly advances year', () {
      final from = DateTime(2025, 6, 1);
      final next = RecurrenceRule.nextDate('yearly', from);
      expect(next, DateTime(2026, 6, 1));
    });

    test('yearly clamps leap day (Feb 29 → Feb 28)', () {
      final from = DateTime(2024, 2, 29);
      final next = RecurrenceRule.nextDate('yearly', from);
      expect(next, DateTime(2025, 2, 28));
    });

    test('unknown rule returns null', () {
      final next = RecurrenceRule.nextDate('quarterly', DateTime.now());
      expect(next, isNull);
    });
  });

  group('RecurrenceRule.label', () {
    test('all rules have labels', () {
      for (final rule in RecurrenceRule.all) {
        expect(RecurrenceRule.label(rule), isNotEmpty);
      }
    });

    test('daily label is Daily', () {
      expect(RecurrenceRule.label('daily'), 'Daily');
    });

    test('biweekly label is Every 2 Weeks', () {
      expect(RecurrenceRule.label('biweekly'), 'Every 2 Weeks');
    });

    test('unknown rule returns itself', () {
      expect(RecurrenceRule.label('custom'), 'custom');
    });
  });
}

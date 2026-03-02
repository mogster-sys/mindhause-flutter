import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../database/app_database.dart';
import '../database/daos/items_dao.dart';

/// Simple recurrence rules stored as pipe-separated strings:
///   "daily", "weekly", "biweekly", "monthly", "yearly"
class RecurrenceRule {
  static const daily = 'daily';
  static const weekly = 'weekly';
  static const biweekly = 'biweekly';
  static const monthly = 'monthly';
  static const yearly = 'yearly';

  static const all = [daily, weekly, biweekly, monthly, yearly];

  static String label(String rule) {
    switch (rule) {
      case daily:
        return 'Daily';
      case weekly:
        return 'Weekly';
      case biweekly:
        return 'Every 2 Weeks';
      case monthly:
        return 'Monthly';
      case yearly:
        return 'Yearly';
      default:
        return rule;
    }
  }

  /// Calculate the next due date from the current one.
  static DateTime? nextDate(String rule, DateTime from) {
    switch (rule) {
      case daily:
        return from.add(const Duration(days: 1));
      case weekly:
        return from.add(const Duration(days: 7));
      case biweekly:
        return from.add(const Duration(days: 14));
      case monthly:
        // Clamp day to avoid overflow (e.g. Jan 31 → Feb 28)
        final nextMonth = from.month + 1;
        final yr = nextMonth > 12 ? from.year + 1 : from.year;
        final mo = nextMonth > 12 ? nextMonth - 12 : nextMonth;
        final maxDay = DateTime(yr, mo + 1, 0).day;
        return DateTime(yr, mo, from.day.clamp(1, maxDay));
      case yearly:
        final maxDay = DateTime(from.year + 1, from.month + 1, 0).day;
        return DateTime(from.year + 1, from.month, from.day.clamp(1, maxDay));
      default:
        return null;
    }
  }
}

final recurrenceServiceProvider = Provider<RecurrenceService>((ref) {
  return RecurrenceService();
});

class RecurrenceService {
  /// When a recurring task is completed, create the next occurrence.
  /// Returns the new item's ID if created, null otherwise.
  Future<String?> createNextOccurrence(ItemsDao dao, Item completedTask) async {
    final rule = completedTask.recurrenceRule;
    if (rule == null || rule.isEmpty) return null;

    final baseDueDate = completedTask.dueDate ?? completedTask.completedAt ?? DateTime.now();
    final nextDue = RecurrenceRule.nextDate(rule, baseDueDate);
    if (nextDue == null) return null;

    final now = DateTime.now();
    final newId = const Uuid().v4();

    await dao.createItem(ItemsCompanion.insert(
      id: newId,
      title: completedTask.title,
      description: Value(completedTask.description),
      type: completedTask.type,
      priority: Value(completedTask.priority),
      status: const Value('todo'),
      dueDate: Value(nextDue),
      createdAt: now,
      updatedAt: now,
      lastInteraction: now,
      room: Value(completedTask.room),
      objectType: Value(completedTask.objectType),
      projectId: Value(completedTask.projectId),
      goalId: Value(completedTask.goalId),
      recurrenceRule: Value(rule),
    ));

    return newId;
  }
}

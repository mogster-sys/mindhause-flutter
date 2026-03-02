import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

import '../app_database.dart';
import '../tables/habits_table.dart';

part 'habits_dao.g.dart';

@DriftAccessor(tables: [Habits, HabitLog])
class HabitsDao extends DatabaseAccessor<AppDatabase> with _$HabitsDaoMixin {
  HabitsDao(super.db);

  // ── Habits ──────────────────────────────────────────────

  /// Watch habit metadata by its linked item ID.
  Stream<Habit?> watchByItemId(String itemId) {
    return (select(habits)..where((t) => t.itemId.equals(itemId)))
        .watchSingleOrNull();
  }

  /// Get habit metadata by its linked item ID.
  Future<Habit?> getByItemId(String itemId) {
    return (select(habits)..where((t) => t.itemId.equals(itemId)))
        .getSingleOrNull();
  }

  /// Create a new habit row.
  Future<void> createHabit(HabitsCompanion companion) {
    return into(habits).insert(companion);
  }

  /// Update a habit row by its primary key.
  Future<bool> updateHabit(String id, HabitsCompanion companion) {
    return (update(habits)..where((t) => t.id.equals(id)))
        .write(companion)
        .then((rows) => rows > 0);
  }

  /// Reset streak to zero.
  Future<void> resetStreak(String id) {
    return (update(habits)..where((t) => t.id.equals(id)))
        .write(const HabitsCompanion(currentStreak: Value(0)));
  }

  /// Delete a habit and all its log entries.
  Future<void> deleteHabit(String id) async {
    await (delete(habitLog)..where((t) => t.habitId.equals(id))).go();
    await (delete(habits)..where((t) => t.id.equals(id))).go();
  }

  // ── Habit Log ───────────────────────────────────────────

  /// Insert a check-in entry.
  Future<void> logCompletion(HabitLogCompanion entry) {
    return into(habitLog).insert(entry);
  }

  /// Watch log entries for a habit, newest first.
  Stream<List<HabitLogData>> watchLog(String habitId) {
    return (select(habitLog)
          ..where((t) => t.habitId.equals(habitId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.completedAt, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  /// Watch today's completions for a habit.
  Stream<List<HabitLogData>> watchTodayCompletions(String habitId) {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(habitLog)
          ..where((t) =>
              t.habitId.equals(habitId) &
              t.completedAt.isBiggerOrEqualValue(startOfDay) &
              t.completedAt.isSmallerThanValue(endOfDay)))
        .watch();
  }

  /// Watch all habit log entries within a date range (for calendar).
  Stream<List<HabitLogData>> watchLogRange(DateTime from, DateTime to) {
    return (select(habitLog)
          ..where((t) =>
              t.completedAt.isBiggerOrEqualValue(from) &
              t.completedAt.isSmallerThanValue(to))
          ..orderBy([
            (t) => OrderingTerm(expression: t.completedAt),
          ]))
        .watch();
  }

  /// Record a check-in: log entry + bump streak + update lastCompleted.
  Future<void> checkIn(
      String habitId, int currentStreak, int bestStreak) async {
    final now = DateTime.now();
    final newStreak = currentStreak + 1;

    await into(habitLog).insert(HabitLogCompanion.insert(
      id: const Uuid().v4(),
      habitId: habitId,
      completedAt: now,
    ));

    await (update(habits)..where((t) => t.id.equals(habitId))).write(
      HabitsCompanion(
        currentStreak: Value(newStreak),
        bestStreak: Value(newStreak > bestStreak ? newStreak : bestStreak),
        lastCompleted: Value(now),
      ),
    );
  }
}

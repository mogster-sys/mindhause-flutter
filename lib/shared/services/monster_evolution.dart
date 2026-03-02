import 'package:drift/drift.dart';

import '../database/app_database.dart';

/// Evaluate all active tasks and update their monster state based on neglect.
///
/// Uses hours since last interaction (matching Godot's monster_system.gd):
///   gentle → 168h (7d) / 336h (14d) / 672h (28d)
///   normal →  72h (3d) / 168h (7d)  / 336h (14d)
///   strict →  24h (1d) /  72h (3d)  / 168h (7d)
Future<void> evaluateMonsterStates(
  AppDatabase db, {
  required bool enabled,
  required String sensitivity,
}) async {
  // If monsters are disabled, reset any existing monster states and return
  if (!enabled) {
    await (db.update(db.items)
          ..where((t) => t.monsterState.isNotIn(const ['none'])))
        .write(const ItemsCompanion(monsterState: Value('none')));
    return;
  }

  final now = DateTime.now();

  // Thresholds in hours — aligned with Godot's GameState.monster_thresholds
  final (int neglectedHours, int corruptingHours, int monsterHours) =
      switch (sensitivity) {
    'gentle' => (168, 336, 672),
    'strict' => (24, 72, 168),
    _ => (72, 168, 336), // normal
  };

  // Get all tasks that aren't done/archived
  final activeTasks = await (db.select(db.items)
        ..where((t) =>
            t.type.equals('task') &
            t.status.isNotIn(const ['done', 'archived'])))
      .get();

  for (final task in activeTasks) {
    final hoursSinceInteraction =
        now.difference(task.lastInteraction).inHours;

    final String newState;
    if (hoursSinceInteraction >= monsterHours) {
      newState = 'monster';
    } else if (hoursSinceInteraction >= corruptingHours) {
      newState = 'corrupting';
    } else if (hoursSinceInteraction >= neglectedHours) {
      newState = 'neglected';
    } else {
      newState = 'none';
    }

    if (newState != task.monsterState) {
      await (db.update(db.items)..where((t) => t.id.equals(task.id))).write(
        ItemsCompanion(
          monsterState: Value(newState),
          monsterEvolvedAt: Value(now),
        ),
      );
    }
  }

  // Reset completed tasks back to healthy
  await (db.update(db.items)
        ..where((t) =>
            t.status.equals('done') &
            t.monsterState.isNotIn(const ['none'])))
      .write(const ItemsCompanion(monsterState: Value('none')));
}

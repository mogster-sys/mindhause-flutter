import 'dart:ffi';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/open.dart';

import 'package:mindhause/shared/database/app_database.dart';
import 'package:mindhause/shared/services/monster_evolution.dart';

void main() {
  setUpAll(() {
    open.overrideFor(OperatingSystem.linux, () {
      return DynamicLibrary.open('libsqlite3.so.0');
    });
  });

  late AppDatabase db;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> insertTask(
    String id, {
    DateTime? lastInteraction,
    String status = 'todo',
    String monsterState = 'none',
  }) async {
    final now = DateTime.now();
    await db.into(db.items).insert(ItemsCompanion.insert(
          id: id,
          title: 'Task $id',
          type: 'task',
          status: Value(status),
          monsterState: Value(monsterState),
          createdAt: now,
          updatedAt: now,
          lastInteraction: lastInteraction ?? now,
        ));
  }

  group('evaluateMonsterStates', () {
    test('does nothing when monsters are disabled', () async {
      await insertTask('t1',
          lastInteraction: DateTime.now().subtract(const Duration(days: 30)),
          monsterState: 'monster');

      await evaluateMonsterStates(db,
          enabled: false, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'none');
    });

    test('recently interacted task stays healthy (normal)', () async {
      await insertTask('t1',
          lastInteraction: DateTime.now().subtract(const Duration(hours: 1)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'none');
    });

    test('neglected task evolves to neglected (normal: 72h)', () async {
      await insertTask('t1',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 73)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'neglected');
    });

    test('very neglected task evolves to corrupting (normal: 168h)', () async {
      await insertTask('t1',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 170)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'corrupting');
    });

    test('extremely neglected task becomes monster (normal: 336h)', () async {
      await insertTask('t1',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 340)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'monster');
    });

    test('strict sensitivity has lower thresholds', () async {
      // 25 hours with strict → should be neglected (threshold: 24h)
      await insertTask('t1',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 25)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'strict');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'neglected');
    });

    test('gentle sensitivity has higher thresholds', () async {
      // 100 hours with gentle → still healthy (threshold: 168h)
      await insertTask('t1',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 100)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'gentle');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'none');
    });

    test('completed tasks are reset to healthy', () async {
      await insertTask('t1',
          status: 'done', monsterState: 'monster');

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'none');
    });

    test('does not evolve done tasks', () async {
      await insertTask('t1',
          status: 'done',
          lastInteraction:
              DateTime.now().subtract(const Duration(hours: 500)));

      await evaluateMonsterStates(db,
          enabled: true, sensitivity: 'normal');

      final task = await (db.select(db.items)
            ..where((t) => t.id.equals('t1')))
          .getSingle();
      expect(task.monsterState, 'none');
    });
  });
}

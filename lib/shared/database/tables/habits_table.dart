import 'package:drift/drift.dart';

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get frequency => text()(); // 'daily', 'weekly', 'custom'
  IntColumn get currentStreak => integer().withDefault(const Constant(0))();
  IntColumn get bestStreak => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastCompleted => dateTime().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class HabitLog extends Table {
  TextColumn get id => text()();
  TextColumn get habitId => text()();
  DateTimeColumn get completedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

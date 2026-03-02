import 'package:drift/drift.dart';

class Subtasks extends Table {
  TextColumn get id => text()();
  TextColumn get itemId => text()();
  TextColumn get title => text()();
  BoolColumn get done => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

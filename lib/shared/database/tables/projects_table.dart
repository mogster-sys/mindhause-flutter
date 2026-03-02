import 'package:drift/drift.dart';

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get color => text().withDefault(const Constant('#8B7355'))();
  TextColumn get room => text().nullable()();
  TextColumn get wing => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}

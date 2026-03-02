import 'package:drift/drift.dart';

class Goals extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  DateTimeColumn get targetDate => dateTime().nullable()();
  TextColumn get status => text().withDefault(const Constant('active'))(); // 'active', 'achieved', 'abandoned'
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

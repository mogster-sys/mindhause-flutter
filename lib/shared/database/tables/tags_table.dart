import 'package:drift/drift.dart';

class Tags extends Table {
  TextColumn get id => text()();
  TextColumn get name => text().unique()();
  TextColumn get color => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class ItemTags extends Table {
  TextColumn get itemId => text()();
  TextColumn get tagId => text()();

  @override
  Set<Column> get primaryKey => {itemId, tagId};
}

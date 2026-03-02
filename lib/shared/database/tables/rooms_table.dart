import 'package:drift/drift.dart';

class Rooms extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get displayName => text()();
  TextColumn get category => text().nullable()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get floor => text().withDefault(const Constant('ground'))(); // 'basement', 'ground', 'upper'
  BoolColumn get unlocked => boolean().withDefault(const Constant(true))();
  BoolColumn get isCustom => boolean().withDefault(const Constant(false))();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}

class Surfaces extends Table {
  TextColumn get id => text()();
  TextColumn get roomId => text()();
  TextColumn get name => text()();
  TextColumn get type => text()(); // 'desk', 'shelf', 'wall', 'pedestal', 'notice_board', 'picture_frame', 'chalkboard', 'floor'
  IntColumn get capacity => integer().withDefault(const Constant(10))();
  RealColumn get positionX => real().withDefault(const Constant(0.0))();
  RealColumn get positionY => real().withDefault(const Constant(0.0))();
  RealColumn get positionZ => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

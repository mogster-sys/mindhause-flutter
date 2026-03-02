import 'package:drift/drift.dart';

class Items extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get description => text().withDefault(const Constant(''))();
  TextColumn get type => text()(); // 'task', 'note', 'event', 'habit'
  TextColumn get priority => text().withDefault(const Constant('normal'))(); // 'low', 'normal', 'high'
  TextColumn get status => text().withDefault(const Constant('todo'))(); // 'todo', 'in_progress', 'done', 'archived'
  DateTimeColumn get dueDate => dateTime().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastInteraction => dateTime()();
  DateTimeColumn get completedAt => dateTime().nullable()();
  TextColumn get room => text().nullable()();
  TextColumn get surface => text().nullable()();
  TextColumn get objectType => text().withDefault(const Constant('scroll'))();
  RealColumn get positionX => real().withDefault(const Constant(0.0))();
  RealColumn get positionY => real().withDefault(const Constant(0.0))();
  RealColumn get positionZ => real().withDefault(const Constant(0.0))();
  TextColumn get projectId => text().nullable()();
  TextColumn get goalId => text().nullable()();
  TextColumn get monsterState => text().withDefault(const Constant('none'))(); // 'none', 'neglected', 'corrupting', 'monster'
  DateTimeColumn get monsterEvolvedAt => dateTime().nullable()();
  TextColumn get recurrenceRule => text().nullable()();
  RealColumn get locationLat => real().nullable()();
  RealColumn get locationLng => real().nullable()();
  TextColumn get locationName => text().nullable()();
  TextColumn get notes => text().withDefault(const Constant(''))();

  @override
  Set<Column> get primaryKey => {id};
}

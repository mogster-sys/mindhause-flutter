import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/items_table.dart';
import 'tables/subtasks_table.dart';
import 'tables/projects_table.dart';
import 'tables/goals_table.dart';
import 'tables/tags_table.dart';
import 'tables/rooms_table.dart';
import 'tables/habits_table.dart';
import 'tables/settings_table.dart';
import 'daos/habits_dao.dart';
import 'daos/items_dao.dart';
import 'daos/projects_dao.dart';
import 'daos/settings_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Items,
    Subtasks,
    Projects,
    Goals,
    Tags,
    ItemTags,
    Rooms,
    Surfaces,
    Habits,
    HabitLog,
    Settings,
  ],
  daos: [ItemsDao, ProjectsDao, SettingsDao, HabitsDao],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.e);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedDefaultData();
        },
      );

  Future<void> _seedDefaultData() async {
    // Seed default rooms
    final defaultRooms = [
      RoomsCompanion.insert(
        id: 'foyer',
        name: 'foyer',
        displayName: 'Foyer / Atrium',
        category: const Value('dashboard'),
        description: const Value("Today's overview and urgent items"),
        floor: const Value('ground'),
        sortOrder: const Value(0),
      ),
      RoomsCompanion.insert(
        id: 'study',
        name: 'study',
        displayName: 'Study',
        category: const Value('work'),
        description: const Value('Work tasks and professional projects'),
        floor: const Value('ground'),
        sortOrder: const Value(1),
      ),
      RoomsCompanion.insert(
        id: 'library',
        name: 'library',
        displayName: 'Library',
        category: const Value('reference'),
        description: const Value('Notes, reference material, and ideas'),
        floor: const Value('ground'),
        sortOrder: const Value(2),
      ),
      RoomsCompanion.insert(
        id: 'kitchen',
        name: 'kitchen',
        displayName: 'Kitchen / Pantry',
        category: const Value('nutrition'),
        description: const Value('Shopping lists, meal plans, nutrition'),
        floor: const Value('ground'),
        sortOrder: const Value(3),
      ),
      RoomsCompanion.insert(
        id: 'workshop',
        name: 'workshop',
        displayName: 'Workshop',
        category: const Value('creative'),
        description: const Value('Creative projects, DIY, builds'),
        floor: const Value('ground'),
        sortOrder: const Value(4),
      ),
      RoomsCompanion.insert(
        id: 'garden',
        name: 'garden',
        displayName: 'Garden / Courtyard',
        category: const Value('growth'),
        description: const Value('Long-term goals, growth, habits'),
        floor: const Value('ground'),
        sortOrder: const Value(5),
      ),
      RoomsCompanion.insert(
        id: 'bedroom',
        name: 'bedroom',
        displayName: 'Bedroom',
        category: const Value('personal'),
        description: const Value('Personal tasks, self-care, rest'),
        floor: const Value('upper'),
        sortOrder: const Value(6),
      ),
      RoomsCompanion.insert(
        id: 'gymnasium',
        name: 'gymnasium',
        displayName: 'Gymnasium',
        category: const Value('health'),
        description: const Value('Fitness goals, health tracking, exercise'),
        floor: const Value('upper'),
        sortOrder: const Value(7),
      ),
      RoomsCompanion.insert(
        id: 'treasury',
        name: 'treasury',
        displayName: 'Treasury / Vault',
        category: const Value('archive'),
        description: const Value('Completed and archived items, achievements'),
        floor: const Value('basement'),
        sortOrder: const Value(8),
      ),
      RoomsCompanion.insert(
        id: 'cellar',
        name: 'cellar',
        displayName: 'Cellar',
        category: const Value('deferred'),
        description: const Value('Deferred and someday items'),
        floor: const Value('basement'),
        sortOrder: const Value(9),
      ),
    ];

    for (final room in defaultRooms) {
      await into(rooms).insert(room);
    }

    // Seed default settings
    final defaultSettings = {
      'monsters_enabled': 'true',
      'monster_sensitivity': 'normal',
      'monster_chasing': 'true',
      'cat_enabled': 'true',
      'focus_duration': '25',
      'theme': 'greco_roman',
      'default_room': 'foyer',
      'quick_capture_room': 'foyer',
      'audio_enabled': 'true',
      'notifications_enabled': 'false',
    };

    for (final entry in defaultSettings.entries) {
      await into(settings).insert(SettingsCompanion.insert(
        key: entry.key,
        value: entry.value,
      ));
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'mindhause.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

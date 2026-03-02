import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app_database.dart';
import 'daos/habits_dao.dart';
import 'daos/items_dao.dart';
import 'daos/projects_dao.dart';
import 'daos/settings_dao.dart';

/// Single database instance for the entire app
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

/// DAO providers
final itemsDaoProvider = Provider<ItemsDao>((ref) {
  return ref.watch(databaseProvider).itemsDao;
});

final projectsDaoProvider = Provider<ProjectsDao>((ref) {
  return ref.watch(databaseProvider).projectsDao;
});

final settingsDaoProvider = Provider<SettingsDao>((ref) {
  return ref.watch(databaseProvider).settingsDao;
});

final habitsDaoProvider = Provider<HabitsDao>((ref) {
  return ref.watch(databaseProvider).habitsDao;
});

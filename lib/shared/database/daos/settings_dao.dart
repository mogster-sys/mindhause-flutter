import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/settings_table.dart';
import '../tables/rooms_table.dart';

part 'settings_dao.g.dart';

@DriftAccessor(tables: [Settings, Rooms, Surfaces])
class SettingsDao extends DatabaseAccessor<AppDatabase>
    with _$SettingsDaoMixin {
  SettingsDao(super.db);

  // Get a setting value
  Future<String?> getSetting(String key) async {
    final row = await (select(settings)..where((t) => t.key.equals(key)))
        .getSingleOrNull();
    return row?.value;
  }

  // Watch a setting
  Stream<String?> watchSetting(String key) {
    return (select(settings)..where((t) => t.key.equals(key)))
        .watchSingleOrNull()
        .map((row) => row?.value);
  }

  // Set a setting value (upsert)
  Future<void> setSetting(String key, String value) {
    return into(settings).insertOnConflictUpdate(
      SettingsCompanion.insert(key: key, value: value),
    );
  }

  // Watch all rooms ordered by floor and sort order
  Stream<List<Room>> watchAllRooms() {
    return (select(rooms)
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  // Watch rooms by floor
  Stream<List<Room>> watchRoomsByFloor(String floor) {
    return (select(rooms)
          ..where((t) => t.floor.equals(floor))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  // Create a custom room
  Future<void> createRoom(RoomsCompanion room) {
    return into(rooms).insert(room);
  }

  // Delete a custom room (only if isCustom)
  Future<void> deleteCustomRoom(String id) {
    return (delete(rooms)
          ..where((t) => t.id.equals(id) & t.isCustom.equals(true)))
        .go();
  }

  // Get surfaces for a room
  Stream<List<Surface>> watchSurfaces(String roomId) {
    return (select(surfaces)..where((t) => t.roomId.equals(roomId))).watch();
  }
}

import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/items_table.dart';
import '../tables/subtasks_table.dart';

part 'items_dao.g.dart';

@DriftAccessor(tables: [Items, Subtasks])
class ItemsDao extends DatabaseAccessor<AppDatabase> with _$ItemsDaoMixin {
  ItemsDao(super.db);

  // Watch all items of a given type, ordered by priority then due date
  Stream<List<Item>> watchItemsByType(String type) {
    return (select(items)
          ..where((t) => t.type.equals(type))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.dueDate),
            (t) => OrderingTerm(expression: t.createdAt),
          ]))
        .watch();
  }

  // Watch items filtered by status
  Stream<List<Item>> watchItemsByStatus(String type, String status) {
    return (select(items)
          ..where((t) => t.type.equals(type) & t.status.equals(status))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.dueDate),
          ]))
        .watch();
  }

  // Watch items for a specific room
  Stream<List<Item>> watchItemsByRoom(String roomId) {
    return (select(items)
          ..where((t) => t.room.equals(roomId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.priority, mode: OrderingMode.desc),
          ]))
        .watch();
  }

  // Watch items for a specific project
  Stream<List<Item>> watchItemsByProject(String projectId) {
    return (select(items)
          ..where((t) => t.projectId.equals(projectId))
          ..orderBy([
            (t) => OrderingTerm(expression: t.dueDate),
          ]))
        .watch();
  }

  // Watch all items with a due date (any type)
  Stream<List<Item>> watchItemsWithDueDate() {
    return (select(items)
          ..where((t) =>
              t.dueDate.isNotNull() & t.status.isNotIn(['archived']))
          ..orderBy([
            (t) => OrderingTerm(expression: t.dueDate),
          ]))
        .watch();
  }

  // Get a single item by ID
  Future<Item?> getItemById(String id) {
    return (select(items)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  // Watch a single item
  Stream<Item?> watchItem(String id) {
    return (select(items)..where((t) => t.id.equals(id)))
        .watchSingleOrNull();
  }

  // Create a new item
  Future<void> createItem(ItemsCompanion item) {
    return into(items).insert(item);
  }

  // Update an item
  Future<bool> updateItem(ItemsCompanion item) {
    return (update(items)..where((t) => t.id.equals(item.id.value)))
        .write(item)
        .then((rows) => rows > 0);
  }

  // Delete an item and its subtasks
  Future<void> deleteItem(String id) async {
    await (delete(subtasks)..where((t) => t.itemId.equals(id))).go();
    await (delete(items)..where((t) => t.id.equals(id))).go();
  }

  // Mark item complete
  Future<void> completeItem(String id) {
    final now = DateTime.now();
    return (update(items)..where((t) => t.id.equals(id))).write(
      ItemsCompanion(
        status: const Value('done'),
        completedAt: Value(now),
        updatedAt: Value(now),
        lastInteraction: Value(now),
      ),
    );
  }

  // Watch subtasks for an item
  Stream<List<Subtask>> watchSubtasks(String itemId) {
    return (select(subtasks)
          ..where((t) => t.itemId.equals(itemId))
          ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]))
        .watch();
  }

  // Add a subtask
  Future<void> addSubtask(SubtasksCompanion subtask) {
    return into(subtasks).insert(subtask);
  }

  // Toggle subtask done
  Future<void> toggleSubtask(String id, bool done) {
    return (update(subtasks)..where((t) => t.id.equals(id)))
        .write(SubtasksCompanion(done: Value(done)));
  }

  // Delete a subtask
  Future<void> deleteSubtask(String id) {
    return (delete(subtasks)..where((t) => t.id.equals(id))).go();
  }

  // Watch items for a specific goal
  Stream<List<Item>> watchItemsByGoal(String goalId) {
    return (select(items)
          ..where((t) => t.goalId.equals(goalId))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.priority, mode: OrderingMode.desc),
            (t) => OrderingTerm(expression: t.dueDate),
          ]))
        .watch();
  }

  // Search items by title/description
  Stream<List<Item>> searchItems(String query) {
    final pattern = '%$query%';
    return (select(items)
          ..where(
              (t) => t.title.like(pattern) | t.description.like(pattern))
          ..orderBy([(t) => OrderingTerm(expression: t.updatedAt, mode: OrderingMode.desc)]))
        .watch();
  }

  // Count items by status
  Stream<int> watchCountByStatus(String type, String status) {
    final count = items.id.count();
    final query = selectOnly(items)
      ..addColumns([count])
      ..where(items.type.equals(type) & items.status.equals(status));
    return query.map((row) => row.read(count)!).watchSingle();
  }

  // Items due today
  Stream<List<Item>> watchDueToday() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    return (select(items)
          ..where((t) =>
              t.dueDate.isBiggerOrEqualValue(startOfDay) &
              t.dueDate.isSmallerThanValue(endOfDay) &
              t.status.isNotIn(['done', 'archived']))
          ..orderBy([
            (t) => OrderingTerm(
                expression: t.priority, mode: OrderingMode.desc),
          ]))
        .watch();
  }
}

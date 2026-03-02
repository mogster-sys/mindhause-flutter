import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';

/// Watch all tags
final allTagsProvider = StreamProvider<List<Tag>>((ref) {
  final db = ref.watch(databaseProvider);
  return (db.select(db.tags)
        ..orderBy([(t) => OrderingTerm(expression: t.name)]))
      .watch();
});

/// Watch tags for a specific item
final itemTagsProvider =
    StreamProvider.family<List<Tag>, String>((ref, itemId) {
  final db = ref.watch(databaseProvider);
  final query = db.select(db.tags).join([
    innerJoin(db.itemTags, db.itemTags.tagId.equalsExp(db.tags.id)),
  ]);
  query.where(db.itemTags.itemId.equals(itemId));
  return query.map((row) => row.readTable(db.tags)).watch();
});

/// Create a new tag, returns its ID. Ignores if name already exists.
Future<String> createTag(AppDatabase db, String name,
    {String? color}) async {
  final id = const Uuid().v4();
  await db.into(db.tags).insert(
        TagsCompanion.insert(id: id, name: name, color: Value(color)),
        mode: InsertMode.insertOrIgnore,
      );
  // Return the existing tag's ID if insert was ignored
  final existing = await (db.select(db.tags)
        ..where((t) => t.name.equals(name)))
      .getSingleOrNull();
  return existing?.id ?? id;
}

/// Tag an item
Future<void> tagItem(AppDatabase db, String itemId, String tagId) {
  return db.into(db.itemTags).insert(
        ItemTagsCompanion.insert(itemId: itemId, tagId: tagId),
        mode: InsertMode.insertOrIgnore,
      );
}

/// Remove a tag from an item
Future<void> untagItem(AppDatabase db, String itemId, String tagId) {
  return (db.delete(db.itemTags)
        ..where(
            (t) => t.itemId.equals(itemId) & t.tagId.equals(tagId)))
      .go();
}

/// Delete a tag entirely (removes from all items too)
Future<void> deleteTag(AppDatabase db, String tagId) async {
  await (db.delete(db.itemTags)..where((t) => t.tagId.equals(tagId))).go();
  await (db.delete(db.tags)..where((t) => t.id.equals(tagId))).go();
}

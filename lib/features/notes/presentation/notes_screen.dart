import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../data/note_providers.dart';

class NotesScreen extends ConsumerWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notesAsync = ref.watch(notesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notes'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearch(context, ref),
          ),
        ],
      ),
      body: notesAsync.when(
        data: (notes) {
          if (notes.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.menu_book_outlined,
                      size: 64, color: MindHauseTheme.warmStone),
                  const SizedBox(height: 16),
                  Text(
                    'Your library is empty.\nTap + to write your first note.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 16, color: MindHauseTheme.slateBlue),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: notes.length,
            itemBuilder: (context, index) => _NoteCard(
              note: notes[index],
              onTap: () => _showNoteEditor(context, ref, notes[index]),
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteEditor(context, ref, null),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showNoteEditor(BuildContext context, WidgetRef ref, Item? note) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final bodyController = TextEditingController(text: note?.description ?? '');
    final isNew = note == null;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: MindHauseTheme.warmStone,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      isNew ? 'New Note' : 'Edit Note',
                      style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: MindHauseTheme.inkDark),
                    ),
                  ),
                  if (!isNew)
                    IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red),
                      onPressed: () async {
                        await ref
                            .read(itemsDaoProvider)
                            .deleteItem(note.id);
                        if (ctx.mounted) Navigator.pop(ctx);
                      },
                    ),
                ],
              ),
              const SizedBox(height: 16),
              TextField(
                controller: titleController,
                autofocus: isNew,
                textCapitalization: TextCapitalization.sentences,
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w500),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const Divider(),
              TextField(
                controller: bodyController,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 12,
                minLines: 6,
                decoration: const InputDecoration(
                  hintText: 'Write your thoughts...',
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                ),
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () async {
                  final title = titleController.text.trim();
                  if (title.isEmpty) return;
                  final now = DateTime.now();
                  final dao = ref.read(itemsDaoProvider);

                  if (isNew) {
                    await dao.createItem(ItemsCompanion.insert(
                      id: const Uuid().v4(),
                      title: title,
                      description: Value(bodyController.text.trim()),
                      type: 'note',
                      createdAt: now,
                      updatedAt: now,
                      lastInteraction: now,
                      room: const Value('library'),
                      objectType: const Value('book'),
                    ));
                  } else {
                    await dao.updateItem(ItemsCompanion(
                      id: Value(note.id),
                      title: Value(title),
                      description: Value(bodyController.text.trim()),
                      updatedAt: Value(now),
                      lastInteraction: Value(now),
                    ));
                  }
                  if (ctx.mounted) Navigator.pop(ctx);
                },
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(isNew ? 'Create Note' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _showSearch(BuildContext context, WidgetRef ref) async {
    final noteId = await showSearch<String?>(
      context: context,
      delegate: _NoteSearchDelegate(),
    );
    if (noteId != null && context.mounted) {
      final note = await ref.read(itemsDaoProvider).getItemById(noteId);
      if (note != null && context.mounted) {
        _showNoteEditor(context, ref, note);
      }
    }
  }
}

class _NoteCard extends StatelessWidget {
  final Item note;
  final VoidCallback onTap;

  const _NoteCard({required this.note, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(note.title,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500)),
              if (note.description.isNotEmpty) ...[
                const SizedBox(height: 6),
                Text(
                  note.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      fontSize: 14,
                      color: MindHauseTheme.slateBlue,
                      height: 1.4),
                ),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.access_time,
                      size: 14, color: MindHauseTheme.warmStone),
                  const SizedBox(width: 4),
                  Text(
                    DateFormat.yMMMd().format(note.updatedAt),
                    style: TextStyle(
                        fontSize: 12, color: MindHauseTheme.warmStone),
                  ),
                  if (note.room != null) ...[
                    const SizedBox(width: 12),
                    Icon(MindHauseTheme.roomIcon(note.room!),
                        size: 14, color: MindHauseTheme.warmStone),
                    const SizedBox(width: 4),
                    Text(note.room!,
                        style: TextStyle(
                            fontSize: 12, color: MindHauseTheme.warmStone)),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NoteSearchDelegate extends SearchDelegate<String?> {
  _NoteSearchDelegate();

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            icon: const Icon(Icons.clear), onPressed: () => query = ''),
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, null));

  @override
  Widget buildResults(BuildContext context) => _build(context);

  @override
  Widget buildSuggestions(BuildContext context) => _build(context);

  Widget _build(BuildContext context) {
    if (query.length < 2) {
      return const Center(child: Text('Type at least 2 characters'));
    }
    return Consumer(
      builder: (context, ref, _) {
        final results = ref.watch(noteSearchProvider(query));
        return results.when(
          data: (items) {
            final notes = items.where((i) => i.type == 'note').toList();
            if (notes.isEmpty) {
              return const Center(child: Text('No notes found'));
            }
            return ListView.builder(
              itemCount: notes.length,
              padding: const EdgeInsets.all(16),
              itemBuilder: (_, i) => _NoteCard(
                note: notes[i],
                onTap: () => close(context, notes[i].id),
              ),
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
        );
      },
    );
  }
}

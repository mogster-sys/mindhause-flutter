import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../../tasks/data/tag_providers.dart';

/// Filter state for search
class SearchFilters {
  final String query;
  final String? type; // null = all, 'task', 'note', 'habit'
  final String? room;
  final String? priority;
  final String? status;
  final String? tagId;

  const SearchFilters({
    this.query = '',
    this.type,
    this.room,
    this.priority,
    this.status,
    this.tagId,
  });

  SearchFilters copyWith({
    String? query,
    String? Function()? type,
    String? Function()? room,
    String? Function()? priority,
    String? Function()? status,
    String? Function()? tagId,
  }) {
    return SearchFilters(
      query: query ?? this.query,
      type: type != null ? type() : this.type,
      room: room != null ? room() : this.room,
      priority: priority != null ? priority() : this.priority,
      status: status != null ? status() : this.status,
      tagId: tagId != null ? tagId() : this.tagId,
    );
  }
}

final _searchFiltersProvider =
    StateProvider<SearchFilters>((ref) => const SearchFilters());

final _searchResultsProvider = StreamProvider((ref) {
  final filters = ref.watch(_searchFiltersProvider);
  final dao = ref.watch(itemsDaoProvider);

  if (filters.query.length < 2 &&
      filters.type == null &&
      filters.room == null &&
      filters.priority == null &&
      filters.status == null &&
      filters.tagId == null) {
    return Stream.value(<Item>[]);
  }

  // If filtering by tag, get item IDs for that tag first
  if (filters.tagId != null) {
    final db = ref.watch(databaseProvider);
    final tagItemsQuery = db.select(db.itemTags)
      ..where((t) => t.tagId.equals(filters.tagId!));
    return tagItemsQuery.watch().asyncMap((rows) async {
      final itemIds = rows.map((r) => r.itemId).toSet();
      if (itemIds.isEmpty) return <Item>[];
      final allItems = await (db.select(db.items)
            ..where((t) => t.id.isIn(itemIds)))
          .get();
      return _applyFilters(allItems, filters);
    });
  }

  // Use search if there's a query, otherwise get all items
  return filters.query.length >= 2
      ? dao.searchItems(filters.query).map((items) => _applyFilters(items, filters))
      : dao.watchItemsByType(filters.type ?? 'task').map((items) => _applyFilters(items, filters));
});

List<Item> _applyFilters(List<Item> items, SearchFilters filters) {
  return items.where((item) {
    if (filters.type != null && item.type != filters.type) return false;
    if (filters.room != null && item.room != filters.room) return false;
    if (filters.priority != null && item.priority != filters.priority) {
      return false;
    }
    if (filters.status != null && item.status != filters.status) return false;
    return true;
  }).toList();
}

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _searchController = TextEditingController();
  bool _showFilters = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(_searchFiltersProvider);
    final resultsAsync = ref.watch(_searchResultsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Search'),
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: TextField(
              controller: _searchController,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'Search tasks, notes, habits...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (_searchController.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          ref.read(_searchFiltersProvider.notifier).state =
                              filters.copyWith(query: '');
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        Icons.tune,
                        color: _hasActiveFilters(filters)
                            ? MindHauseTheme.terracotta
                            : null,
                      ),
                      onPressed: () =>
                          setState(() => _showFilters = !_showFilters),
                    ),
                  ],
                ),
              ),
              onChanged: (v) {
                ref.read(_searchFiltersProvider.notifier).state =
                    filters.copyWith(query: v.trim());
              },
            ),
          ),

          // Filter chips
          if (_showFilters) _FilterBar(filters: filters, ref: ref),

          // Results
          Expanded(
            child: resultsAsync.when(
              data: (items) {
                if (filters.query.isEmpty && !_hasActiveFilters(filters)) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search,
                            size: 64, color: MindHauseTheme.warmStone),
                        const SizedBox(height: 16),
                        Text(
                          'Search across all your items.\nUse filters to narrow results.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 16, color: MindHauseTheme.slateBlue),
                        ),
                      ],
                    ),
                  );
                }
                if (items.isEmpty) {
                  return Center(
                    child: Text('No results found',
                        style: TextStyle(color: MindHauseTheme.slateBlue)),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: items.length,
                  itemBuilder: (_, i) => _SearchResultCard(
                    item: items[i],
                    onTap: () => _navigateToItem(context, ref, items[i]),
                  ),
                );
              },
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Error: $e')),
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToItem(BuildContext context, WidgetRef ref, Item item) {
    switch (item.type) {
      case 'task':
        context.push('/task/${item.id}');
      case 'note':
        // Open the note editor sheet
        final titleController = TextEditingController(text: item.title);
        final bodyController = TextEditingController(text: item.description);
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(
              left: 24, right: 24, top: 16,
              bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    decoration: const InputDecoration(
                      hintText: 'Title', border: InputBorder.none,
                    ),
                  ),
                  const Divider(),
                  TextField(
                    controller: bodyController,
                    maxLines: 10, minLines: 4,
                    decoration: const InputDecoration(
                      hintText: 'Write...', border: InputBorder.none,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: () async {
                      final now = DateTime.now();
                      await ref.read(itemsDaoProvider).updateItem(ItemsCompanion(
                        id: Value(item.id),
                        title: Value(titleController.text.trim()),
                        description: Value(bodyController.text.trim()),
                        updatedAt: Value(now),
                        lastInteraction: Value(now),
                      ));
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ),
        );
      case 'habit':
        // Show a simple habit detail sheet
        showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          builder: (ctx) => Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title,
                    style: Theme.of(ctx).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Text('Tap this habit on the Habits screen to check in or view details.',
                    style: TextStyle(color: MindHauseTheme.slateBlue)),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    context.push('/habits');
                  },
                  child: const Text('Go to Habits'),
                ),
              ],
            ),
          ),
        );
    }
  }

  bool _hasActiveFilters(SearchFilters f) {
    return f.type != null ||
        f.room != null ||
        f.priority != null ||
        f.status != null ||
        f.tagId != null;
  }
}

class _FilterBar extends StatelessWidget {
  final SearchFilters filters;
  final WidgetRef ref;

  const _FilterBar({required this.filters, required this.ref});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Type filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildChip('All', filters.type == null, () {
                  ref.read(_searchFiltersProvider.notifier).state =
                      filters.copyWith(type: () => null);
                }),
                _buildChip('Tasks', filters.type == 'task', () {
                  ref.read(_searchFiltersProvider.notifier).state =
                      filters.copyWith(type: () => 'task');
                }),
                _buildChip('Notes', filters.type == 'note', () {
                  ref.read(_searchFiltersProvider.notifier).state =
                      filters.copyWith(type: () => 'note');
                }),
                _buildChip('Habits', filters.type == 'habit', () {
                  ref.read(_searchFiltersProvider.notifier).state =
                      filters.copyWith(type: () => 'habit');
                }),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Priority + Status
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Priority
                ...['low', 'normal', 'high'].map((p) => _buildChip(
                      p[0].toUpperCase() + p.substring(1),
                      filters.priority == p,
                      () {
                        ref.read(_searchFiltersProvider.notifier).state =
                            filters.copyWith(
                                priority: () =>
                                    filters.priority == p ? null : p);
                      },
                      color: MindHauseTheme.priorityColor(p),
                    )),
                const SizedBox(width: 8),
                // Status
                ...['todo', 'in_progress', 'done'].map((s) => _buildChip(
                      _statusLabel(s),
                      filters.status == s,
                      () {
                        ref.read(_searchFiltersProvider.notifier).state =
                            filters.copyWith(
                                status: () =>
                                    filters.status == s ? null : s);
                      },
                    )),
              ],
            ),
          ),
          const SizedBox(height: 4),
          // Room filter
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ...['foyer', 'study', 'library', 'kitchen', 'workshop',
                    'garden', 'bedroom', 'gymnasium', 'treasury', 'cellar']
                    .map((r) => _buildChip(
                          r[0].toUpperCase() + r.substring(1),
                          filters.room == r,
                          () {
                            ref.read(_searchFiltersProvider.notifier).state =
                                filters.copyWith(
                                    room: () =>
                                        filters.room == r ? null : r);
                          },
                          icon: MindHauseTheme.roomIcon(r),
                        )),
              ],
            ),
          ),
          // Tags filter
          Consumer(builder: (context, ref, _) {
            final tagsAsync = ref.watch(allTagsProvider);
            return tagsAsync.when(
              data: (tags) {
                if (tags.isEmpty) return const SizedBox.shrink();
                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: tags.map((tag) => _buildChip(
                          tag.name,
                          filters.tagId == tag.id,
                          () {
                            ref.read(_searchFiltersProvider.notifier).state =
                                filters.copyWith(
                                    tagId: () => filters.tagId == tag.id
                                        ? null
                                        : tag.id);
                          },
                          icon: Icons.label_outline,
                        )).toList(),
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            );
          }),
          // Clear all
          if (filters.type != null ||
              filters.room != null ||
              filters.priority != null ||
              filters.status != null ||
              filters.tagId != null)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  ref.read(_searchFiltersProvider.notifier).state =
                      SearchFilters(query: filters.query);
                },
                child: const Text('Clear filters'),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildChip(String label, bool selected, VoidCallback onTap,
      {Color? color, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: FilterChip(
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14),
              const SizedBox(width: 4),
            ],
            Text(label, style: const TextStyle(fontSize: 12)),
          ],
        ),
        selected: selected,
        onSelected: (_) => onTap(),
        selectedColor: (color ?? MindHauseTheme.terracotta).withValues(alpha: 0.2),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  String _statusLabel(String s) {
    switch (s) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'Active';
      case 'done':
        return 'Done';
      default:
        return s;
    }
  }
}

class _SearchResultCard extends StatelessWidget {
  final Item item;
  final VoidCallback onTap;

  const _SearchResultCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Type icon
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: _typeColor(item.type).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(_typeIcon(item.type),
                    size: 20, color: _typeColor(item.type)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.title,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Text(
                          item.type[0].toUpperCase() + item.type.substring(1),
                          style: TextStyle(
                              fontSize: 12, color: MindHauseTheme.slateBlue),
                        ),
                        if (item.room != null) ...[
                          Text(' \u2022 ',
                              style: TextStyle(
                                  color: MindHauseTheme.warmStone)),
                          Icon(MindHauseTheme.roomIcon(item.room!),
                              size: 12, color: MindHauseTheme.warmStone),
                          const SizedBox(width: 2),
                          Text(item.room!,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: MindHauseTheme.warmStone)),
                        ],
                        if (item.dueDate != null) ...[
                          Text(' \u2022 ',
                              style: TextStyle(
                                  color: MindHauseTheme.warmStone)),
                          Text(DateFormat.MMMd().format(item.dueDate!),
                              style: TextStyle(
                                  fontSize: 12,
                                  color: MindHauseTheme.warmStone)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MindHauseTheme.priorityColor(item.priority),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _typeIcon(String type) {
    switch (type) {
      case 'task':
        return Icons.task_alt;
      case 'note':
        return Icons.menu_book;
      case 'habit':
        return Icons.eco;
      case 'event':
        return Icons.event;
      default:
        return Icons.article;
    }
  }

  Color _typeColor(String type) {
    switch (type) {
      case 'task':
        return MindHauseTheme.terracotta;
      case 'note':
        return MindHauseTheme.slateBlue;
      case 'habit':
        return MindHauseTheme.deepOlive;
      case 'event':
        return MindHauseTheme.bronzeGold;
      default:
        return MindHauseTheme.warmStone;
    }
  }
}

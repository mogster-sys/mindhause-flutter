import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../../app/theme.dart';
import '../../../../shared/database/app_database.dart';
import '../../../../shared/database/providers.dart';
import '../../../../shared/services/notification_service.dart';
import '../../../../shared/services/recurrence_service.dart';
import '../../../settings/data/settings_providers.dart';
import '../../../goals/data/goal_providers.dart';
import '../../data/tag_providers.dart';

class CreateTaskSheet extends ConsumerStatefulWidget {
  const CreateTaskSheet({super.key});

  @override
  ConsumerState<CreateTaskSheet> createState() => _CreateTaskSheetState();
}

class _CreateTaskSheetState extends ConsumerState<CreateTaskSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  String _priority = 'normal';
  DateTime? _dueDate;
  String? _selectedRoom;
  String? _recurrenceRule;
  String? _selectedGoalId;
  final List<String> _selectedTagIds = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final rooms = ref.watch(roomsProvider);
    final goalsAsync = ref.watch(activeGoalsProvider);

    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Handle
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

            // Title
            Text(
              'New Task',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MindHauseTheme.inkDark,
                  ),
            ),
            const SizedBox(height: 16),

            // Title field
            TextField(
              controller: _titleController,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              decoration: const InputDecoration(
                hintText: 'What needs doing?',
                labelText: 'Title',
              ),
            ),
            const SizedBox(height: 12),

            // Description
            TextField(
              controller: _descriptionController,
              textCapitalization: TextCapitalization.sentences,
              maxLines: 3,
              minLines: 1,
              decoration: const InputDecoration(
                hintText: 'Details (optional)',
                labelText: 'Description',
              ),
            ),
            const SizedBox(height: 16),

            // Priority selector
            Row(
              children: [
                const Text('Priority: ',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                const SizedBox(width: 8),
                _PriorityChip(
                  label: 'Low',
                  value: 'low',
                  selected: _priority == 'low',
                  onSelected: () => setState(() => _priority = 'low'),
                ),
                const SizedBox(width: 8),
                _PriorityChip(
                  label: 'Normal',
                  value: 'normal',
                  selected: _priority == 'normal',
                  onSelected: () => setState(() => _priority = 'normal'),
                ),
                const SizedBox(width: 8),
                _PriorityChip(
                  label: 'High',
                  value: 'high',
                  selected: _priority == 'high',
                  onSelected: () => setState(() => _priority = 'high'),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Due date
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.calendar_today),
              title: Text(
                _dueDate != null
                    ? DateFormat.yMMMd().format(_dueDate!)
                    : 'No due date',
              ),
              trailing: _dueDate != null
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () => setState(() => _dueDate = null),
                    )
                  : null,
              onTap: _pickDate,
            ),

            // Room selector
            rooms.when(
              data: (roomList) => DropdownButtonFormField<String?>(
                initialValue: _selectedRoom,
                decoration: const InputDecoration(
                  labelText: 'Room',
                  prefixIcon: Icon(Icons.room),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No room')),
                  ...roomList.map((r) => DropdownMenuItem(
                        value: r.id,
                        child: Row(
                          children: [
                            Icon(MindHauseTheme.roomIcon(r.name), size: 18),
                            const SizedBox(width: 8),
                            Text(r.displayName),
                          ],
                        ),
                      )),
                ],
                onChanged: (v) => setState(() => _selectedRoom = v),
              ),
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // Recurrence
            DropdownButtonFormField<String?>(
              initialValue: _recurrenceRule,
              decoration: const InputDecoration(
                labelText: 'Repeat',
                prefixIcon: Icon(Icons.repeat),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('No repeat')),
                ...RecurrenceRule.all.map((r) => DropdownMenuItem(
                      value: r,
                      child: Text(RecurrenceRule.label(r)),
                    )),
              ],
              onChanged: (v) => setState(() => _recurrenceRule = v),
            ),
            const SizedBox(height: 12),

            // Goal
            goalsAsync.when(
              data: (goals) => DropdownButtonFormField<String?>(
                initialValue: _selectedGoalId,
                decoration: const InputDecoration(
                  labelText: 'Goal',
                  prefixIcon: Icon(Icons.emoji_events),
                ),
                items: [
                  const DropdownMenuItem(value: null, child: Text('No goal')),
                  ...goals.map((g) => DropdownMenuItem(
                        value: g.id,
                        child: Text(g.name),
                      )),
                ],
                onChanged: (v) => setState(() => _selectedGoalId = v),
              ),
              loading: () => const SizedBox.shrink(),
              error: (_, _) => const SizedBox.shrink(),
            ),
            const SizedBox(height: 12),

            // Tags
            _TagSelector(
              selectedTagIds: _selectedTagIds,
              onChanged: () => setState(() {}),
            ),
            const SizedBox(height: 24),

            // Create button
            FilledButton.icon(
              onPressed: _create,
              icon: const Icon(Icons.add),
              label: const Text('Create Task'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365 * 5)),
    );
    if (picked != null) {
      setState(() => _dueDate = picked);
    }
  }

  Future<void> _create() async {
    final title = _titleController.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final dao = ref.read(itemsDaoProvider);

    final itemId = const Uuid().v4();
    await dao.createItem(ItemsCompanion.insert(
      id: itemId,
      title: title,
      description: Value(_descriptionController.text.trim()),
      type: 'task',
      priority: Value(_priority),
      status: const Value('todo'),
      dueDate: Value(_dueDate),
      createdAt: now,
      updatedAt: now,
      lastInteraction: now,
      room: Value(_selectedRoom),
      recurrenceRule: Value(_recurrenceRule),
      goalId: Value(_selectedGoalId),
    ));

    // Apply tags
    final db = ref.read(databaseProvider);
    for (final tagId in _selectedTagIds) {
      await tagItem(db, itemId, tagId);
    }

    // Schedule notification if due date set and notifications enabled
    if (_dueDate != null) {
      final notificationsOn =
          ref.read(notificationsEnabledProvider).valueOrNull ?? false;
      if (notificationsOn) {
        final item = await dao.getItemById(itemId);
        if (item != null) {
          await ref.read(notificationServiceProvider).scheduleTaskDue(item);
        }
      }
    }

    if (mounted) Navigator.of(context).pop();
  }
}

class _PriorityChip extends StatelessWidget {
  final String label;
  final String value;
  final bool selected;
  final VoidCallback onSelected;

  const _PriorityChip({
    required this.label,
    required this.value,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
      selectedColor: MindHauseTheme.priorityColor(value).withValues(alpha: 0.2),
      side: BorderSide(
        color: selected
            ? MindHauseTheme.priorityColor(value)
            : MindHauseTheme.warmStone,
      ),
    );
  }
}

class _TagSelector extends ConsumerWidget {
  final List<String> selectedTagIds;
  final VoidCallback onChanged;

  const _TagSelector({
    required this.selectedTagIds,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allTags = ref.watch(allTagsProvider);

    return allTags.when(
      data: (tags) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tags:', style: TextStyle(fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                ...tags.map((tag) {
                  final selected = selectedTagIds.contains(tag.id);
                  return FilterChip(
                    label: Text(tag.name,
                        style: const TextStyle(fontSize: 12)),
                    selected: selected,
                    onSelected: (_) {
                      if (selected) {
                        selectedTagIds.remove(tag.id);
                      } else {
                        selectedTagIds.add(tag.id);
                      }
                      onChanged();
                    },
                    selectedColor:
                        MindHauseTheme.terracotta.withValues(alpha: 0.2),
                    visualDensity: VisualDensity.compact,
                  );
                }),
                ActionChip(
                  avatar: const Icon(Icons.add, size: 16),
                  label: const Text('New', style: TextStyle(fontSize: 12)),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _createTag(context, ref),
                ),
              ],
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Future<void> _createTag(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('New Tag'),
        content: TextField(
          controller: controller,
          autofocus: true,
          textCapitalization: TextCapitalization.words,
          decoration: const InputDecoration(hintText: 'Tag name'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Create')),
        ],
      ),
    );
    controller.dispose();
    if (name != null && name.trim().isNotEmpty) {
      final db = ref.read(databaseProvider);
      final tagId = await createTag(db, name.trim());
      selectedTagIds.add(tagId);
      onChanged();
    }
  }
}

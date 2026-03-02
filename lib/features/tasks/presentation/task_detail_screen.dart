import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/notification_service.dart';
import '../../../shared/services/recurrence_service.dart';
import '../../settings/data/settings_providers.dart';
import '../data/tag_providers.dart';
import '../data/task_providers.dart';

class TaskDetailScreen extends ConsumerStatefulWidget {
  final String taskId;

  const TaskDetailScreen({super.key, required this.taskId});

  @override
  ConsumerState<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends ConsumerState<TaskDetailScreen> {
  bool _editing = false;
  late TextEditingController _titleController;
  late TextEditingController _descriptionController;
  late TextEditingController _notesController;
  String _priority = 'normal';
  String _status = 'todo';
  DateTime? _dueDate;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _descriptionController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _loadFromTask(Item task) {
    _titleController.text = task.title;
    _descriptionController.text = task.description;
    _notesController.text = task.notes;
    _priority = task.priority;
    _status = task.status;
    _dueDate = task.dueDate;
  }

  @override
  Widget build(BuildContext context) {
    final taskAsync = ref.watch(taskDetailProvider(widget.taskId));
    final subtasksAsync = ref.watch(subtasksProvider(widget.taskId));

    return taskAsync.when(
      data: (task) {
        if (task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Task')),
            body: const Center(child: Text('Task not found')),
          );
        }

        if (!_editing) {
          return _buildViewMode(context, task, subtasksAsync);
        }
        return _buildEditMode(context, task);
      },
      loading: () => Scaffold(
        appBar: AppBar(),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildViewMode(
    BuildContext context,
    Item task,
    AsyncValue<List<Subtask>> subtasksAsync,
  ) {
    final isDone = task.status == 'done';
    final isOverdue =
        task.dueDate != null && task.dueDate!.isBefore(DateTime.now()) && !isDone;

    return Scaffold(
      appBar: AppBar(
        title: Text(task.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _loadFromTask(task);
              setState(() => _editing = true);
            },
          ),
          PopupMenuButton<String>(
            onSelected: (action) => _handleAction(action, task),
            itemBuilder: (_) => [
              if (!isDone)
                const PopupMenuItem(
                    value: 'complete', child: Text('Mark Complete')),
              if (isDone)
                const PopupMenuItem(
                    value: 'reopen', child: Text('Reopen')),
              const PopupMenuItem(
                  value: 'delete',
                  child: Text('Delete', style: TextStyle(color: Colors.red))),
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Status & Priority row
          Row(
            children: [
              _StatusChip(status: task.status),
              const SizedBox(width: 8),
              _PriorityBadge(priority: task.priority),
              const Spacer(),
              if (task.monsterState != 'none')
                _MonsterBadge(state: task.monsterState),
            ],
          ),
          const SizedBox(height: 12),

          // Tags
          _TagsRow(taskId: task.id),
          const SizedBox(height: 12),

          // Description
          if (task.description.isNotEmpty) ...[
            Text(
              task.description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
          ],

          // Due date
          if (task.dueDate != null)
            _InfoRow(
              icon: Icons.calendar_today,
              label: 'Due',
              value: DateFormat.yMMMd().format(task.dueDate!),
              color: isOverdue ? MindHauseTheme.urgentRed : null,
            ),

          // Room
          if (task.room != null)
            _InfoRow(
              icon: MindHauseTheme.roomIcon(task.room!),
              label: 'Room',
              value: task.room!,
            ),

          // Object type
          _InfoRow(
            icon: Icons.category,
            label: 'Object',
            value: task.objectType,
          ),

          // Recurrence
          if (task.recurrenceRule != null && task.recurrenceRule!.isNotEmpty)
            _InfoRow(
              icon: Icons.repeat,
              label: 'Repeats',
              value: RecurrenceRule.label(task.recurrenceRule!),
            ),

          // Created / Updated
          _InfoRow(
            icon: Icons.access_time,
            label: 'Created',
            value: DateFormat.yMMMd().add_jm().format(task.createdAt),
          ),

          // Focus button
          if (!isDone)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: FilledButton.icon(
                onPressed: () => context.push(
                  '/focus?taskId=${task.id}&taskTitle=${Uri.encodeComponent(task.title)}',
                ),
                icon: const Icon(Icons.timer),
                label: const Text('Focus'),
              ),
            ),

          const Divider(height: 32),

          // Subtasks
          Row(
            children: [
              const Text('Subtasks',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => _addSubtask(context),
              ),
            ],
          ),
          subtasksAsync.when(
            data: (subtasks) {
              if (subtasks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'No subtasks yet',
                    style: TextStyle(color: MindHauseTheme.slateBlue),
                  ),
                );
              }
              return Column(
                children: subtasks.map((st) => _SubtaskTile(
                      subtask: st,
                      onToggle: () => ref
                          .read(itemsDaoProvider)
                          .toggleSubtask(st.id, !st.done),
                      onDelete: () =>
                          ref.read(itemsDaoProvider).deleteSubtask(st.id),
                    )).toList(),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('Error: $e'),
          ),

          // Notes
          if (task.notes.isNotEmpty) ...[
            const Divider(height: 32),
            const Text('Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            Text(task.notes, style: const TextStyle(height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _buildEditMode(BuildContext context, Item task) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Task'),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => setState(() => _editing = false),
        ),
        actions: [
          TextButton(
            onPressed: () => _saveEdits(task),
            child: const Text('Save'),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _descriptionController,
            maxLines: 4,
            minLines: 2,
            decoration: const InputDecoration(labelText: 'Description'),
          ),
          const SizedBox(height: 16),

          // Priority
          Row(
            children: [
              const Text('Priority: ',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              ...['low', 'normal', 'high'].map((p) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(p[0].toUpperCase() + p.substring(1)),
                      selected: _priority == p,
                      onSelected: (_) => setState(() => _priority = p),
                      selectedColor:
                          MindHauseTheme.priorityColor(p).withValues(alpha: 0.2),
                    ),
                  )),
            ],
          ),
          const SizedBox(height: 12),

          // Status
          Row(
            children: [
              const Text('Status: ',
                  style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(width: 8),
              ...['todo', 'in_progress', 'done'].map((s) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(_statusLabel(s)),
                      selected: _status == s,
                      onSelected: (_) => setState(() => _status = s),
                    ),
                  )),
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
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: _dueDate ?? DateTime.now(),
                firstDate: DateTime(2020),
                lastDate: DateTime(2035),
              );
              if (picked != null) setState(() => _dueDate = picked);
            },
          ),
          const SizedBox(height: 12),

          // Notes
          TextField(
            controller: _notesController,
            maxLines: 6,
            minLines: 3,
            decoration: const InputDecoration(labelText: 'Notes'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEdits(Item task) async {
    final now = DateTime.now();
    final dao = ref.read(itemsDaoProvider);
    await dao.updateItem(ItemsCompanion(
          id: Value(task.id),
          title: Value(_titleController.text.trim()),
          description: Value(_descriptionController.text.trim()),
          priority: Value(_priority),
          status: Value(_status),
          dueDate: Value(_dueDate),
          updatedAt: Value(now),
          lastInteraction: Value(now),
          notes: Value(_notesController.text.trim()),
          completedAt:
              _status == 'done' && task.status != 'done' ? Value(now) : const Value.absent(),
        ));

    // Reschedule or cancel notification
    final notifService = ref.read(notificationServiceProvider);
    final notificationsOn =
        ref.read(notificationsEnabledProvider).valueOrNull ?? false;
    if (_status == 'done' || _dueDate == null || !notificationsOn) {
      await notifService.cancelTaskNotification(task.id);
    } else {
      final updated = await dao.getItemById(task.id);
      if (updated != null) await notifService.scheduleTaskDue(updated);
    }

    if (mounted) setState(() => _editing = false);
  }

  void _handleAction(String action, Item task) async {
    switch (action) {
      case 'complete':
        await ref.read(itemsDaoProvider).completeItem(task.id);
        // Auto-create next occurrence for recurring tasks
        if (task.recurrenceRule != null && task.recurrenceRule!.isNotEmpty) {
          final updated = await ref.read(itemsDaoProvider).getItemById(task.id);
          if (updated != null) {
            await ref.read(recurrenceServiceProvider).createNextOccurrence(
                  ref.read(itemsDaoProvider),
                  updated,
                );
          }
        }
      case 'reopen':
        await ref.read(itemsDaoProvider).updateItem(ItemsCompanion(
              id: Value(task.id),
              status: const Value('todo'),
              completedAt: const Value(null),
              updatedAt: Value(DateTime.now()),
            ));
      case 'delete':
        final confirm = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: const Text('Delete Task?'),
            content: const Text('This cannot be undone.'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(ctx, false),
                  child: const Text('Cancel')),
              TextButton(
                  onPressed: () => Navigator.pop(ctx, true),
                  child: const Text('Delete',
                      style: TextStyle(color: Colors.red))),
            ],
          ),
        );
        if (confirm == true && mounted) {
          await ref.read(itemsDaoProvider).deleteItem(task.id);
          if (mounted) Navigator.of(context).pop();
        }
    }
  }

  Future<void> _addSubtask(BuildContext context) async {
    final controller = TextEditingController();
    final title = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Add Subtask'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Subtask title'),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel')),
          TextButton(
              onPressed: () => Navigator.pop(ctx, controller.text),
              child: const Text('Add')),
        ],
      ),
    );
    controller.dispose();
    if (title != null && title.trim().isNotEmpty) {
      await ref.read(itemsDaoProvider).addSubtask(SubtasksCompanion.insert(
            id: const Uuid().v4(),
            itemId: widget.taskId,
            title: title.trim(),
            sortOrder: Value(DateTime.now().millisecondsSinceEpoch),
          ));
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'todo':
        return 'To Do';
      case 'in_progress':
        return 'In Progress';
      case 'done':
        return 'Done';
      default:
        return status;
    }
  }
}

class _StatusChip extends StatelessWidget {
  final String status;
  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    String label;
    switch (status) {
      case 'todo':
        color = MindHauseTheme.slateBlue;
        label = 'To Do';
      case 'in_progress':
        color = MindHauseTheme.terracotta;
        label = 'In Progress';
      case 'done':
        color = MindHauseTheme.deepOlive;
        label = 'Done';
      default:
        color = MindHauseTheme.slateBlue;
        label = status;
    }
    return Chip(
      label: Text(label, style: TextStyle(color: color, fontSize: 12)),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _PriorityBadge extends StatelessWidget {
  final String priority;
  const _PriorityBadge({required this.priority});

  @override
  Widget build(BuildContext context) {
    final color = MindHauseTheme.priorityColor(priority);
    return Chip(
      label: Text(
        priority[0].toUpperCase() + priority.substring(1),
        style: TextStyle(color: color, fontSize: 12),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.3)),
      visualDensity: VisualDensity.compact,
    );
  }
}

class _MonsterBadge extends StatelessWidget {
  final String state;
  const _MonsterBadge({required this.state});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: MindHauseTheme.urgentRed.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: MindHauseTheme.urgentRed.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.pest_control, size: 14, color: MindHauseTheme.urgentRed),
          const SizedBox(width: 4),
          Text(
            state[0].toUpperCase() + state.substring(1),
            style: const TextStyle(
                color: MindHauseTheme.urgentRed, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? color;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: color ?? MindHauseTheme.slateBlue),
          const SizedBox(width: 12),
          Text('$label: ',
              style: TextStyle(
                  color: color ?? MindHauseTheme.slateBlue,
                  fontWeight: FontWeight.w500)),
          Expanded(
            child: Text(value,
                style: TextStyle(color: color ?? MindHauseTheme.inkDark)),
          ),
        ],
      ),
    );
  }
}

class _SubtaskTile extends StatelessWidget {
  final Subtask subtask;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  const _SubtaskTile({
    required this.subtask,
    required this.onToggle,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Checkbox(value: subtask.done, onChanged: (_) => onToggle()),
      title: Text(
        subtask.title,
        style: TextStyle(
          decoration: subtask.done ? TextDecoration.lineThrough : null,
          color: subtask.done
              ? Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.5)
              : null,
        ),
      ),
      trailing: IconButton(
        icon: const Icon(Icons.close, size: 18),
        onPressed: onDelete,
      ),
    );
  }
}

class _TagsRow extends ConsumerWidget {
  final String taskId;

  const _TagsRow({required this.taskId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tagsAsync = ref.watch(itemTagsProvider(taskId));

    return tagsAsync.when(
      data: (tags) {
        return Wrap(
          spacing: 6,
          runSpacing: 4,
          children: [
            ...tags.map((tag) => Chip(
                  label: Text(tag.name, style: const TextStyle(fontSize: 12)),
                  backgroundColor: tag.color != null
                      ? Color(int.parse(tag.color!, radix: 16) | 0xFF000000)
                          .withValues(alpha: 0.15)
                      : MindHauseTheme.warmStone.withValues(alpha: 0.3),
                  side: BorderSide.none,
                  visualDensity: VisualDensity.compact,
                  deleteIcon: const Icon(Icons.close, size: 14),
                  onDeleted: () => untagItem(
                      ref.read(databaseProvider), taskId, tag.id),
                )),
            ActionChip(
              avatar: const Icon(Icons.add, size: 16),
              label: const Text('Tag', style: TextStyle(fontSize: 12)),
              visualDensity: VisualDensity.compact,
              onPressed: () => _showTagPicker(context, ref),
            ),
          ],
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
    );
  }

  Future<void> _showTagPicker(BuildContext context, WidgetRef ref) async {
    final controller = TextEditingController();
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 16,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
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
            const SizedBox(height: 16),
            Text('Add Tag',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: MindHauseTheme.inkDark)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(
                hintText: 'Tag name',
                prefixIcon: Icon(Icons.label_outline),
              ),
              onSubmitted: (v) async {
                if (v.trim().isEmpty) return;
                final db = ref.read(databaseProvider);
                final tagId = await createTag(db, v.trim());
                await tagItem(db, taskId, tagId);
                if (context.mounted) Navigator.pop(context);
              },
            ),
            const SizedBox(height: 12),
            // Existing tags
            Consumer(builder: (context, ref, _) {
              final allTags = ref.watch(allTagsProvider);
              final currentTags = ref.watch(itemTagsProvider(taskId));
              final currentIds =
                  currentTags.valueOrNull?.map((t) => t.id).toSet() ?? {};

              return allTags.when(
                data: (tags) {
                  final available =
                      tags.where((t) => !currentIds.contains(t.id)).toList();
                  if (available.isEmpty) return const SizedBox.shrink();
                  return Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: available.map((tag) {
                      return ActionChip(
                        label: Text(tag.name,
                            style: const TextStyle(fontSize: 12)),
                        onPressed: () async {
                          final db = ref.read(databaseProvider);
                          await tagItem(db, taskId, tag.id);
                          if (context.mounted) Navigator.pop(context);
                        },
                      );
                    }).toList(),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
              );
            }),
          ],
        ),
      ),
    );
    controller.dispose();
  }
}

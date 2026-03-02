import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../data/goal_providers.dart';

class GoalsScreen extends ConsumerWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(activeGoalsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Goals')),
      body: goalsAsync.when(
        data: (goals) {
          if (goals.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.flag_outlined,
                      size: 64, color: MindHauseTheme.warmStone),
                  const SizedBox(height: 16),
                  Text(
                    'No goals yet.\nTap + to set your first milestone.',
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
            itemCount: goals.length,
            itemBuilder: (context, index) =>
                _GoalCard(goal: goals[index]),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateGoal(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateGoal(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    DateTime? targetDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setSheetState) => Padding(
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
                Text('New Goal',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MindHauseTheme.inkDark)),
                const SizedBox(height: 16),
                TextField(
                  controller: nameController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Learn French, Run a marathon',
                    labelText: 'Goal',
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descController,
                  textCapitalization: TextCapitalization.sentences,
                  maxLines: 3,
                  minLines: 1,
                  decoration: const InputDecoration(
                    hintText: 'Why this matters (optional)',
                    labelText: 'Description',
                  ),
                ),
                const SizedBox(height: 12),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.flag),
                  title: Text(
                    targetDate != null
                        ? 'Target: ${DateFormat.yMMMd().format(targetDate!)}'
                        : 'Set target date (optional)',
                  ),
                  trailing: targetDate != null
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () =>
                              setSheetState(() => targetDate = null),
                        )
                      : null,
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate:
                          targetDate ?? DateTime.now().add(const Duration(days: 90)),
                      firstDate: DateTime.now(),
                      lastDate:
                          DateTime.now().add(const Duration(days: 365 * 5)),
                    );
                    if (picked != null) {
                      setSheetState(() => targetDate = picked);
                    }
                  },
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    final name = nameController.text.trim();
                    if (name.isEmpty) return;
                    await ref.read(projectsDaoProvider).createGoal(
                          GoalsCompanion.insert(
                            id: const Uuid().v4(),
                            name: name,
                            description: Value(descController.text.trim()),
                            targetDate: Value(targetDate),
                            createdAt: DateTime.now(),
                          ),
                        );
                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.flag),
                  label: const Text('Set Goal'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GoalCard extends ConsumerWidget {
  final Goal goal;

  const _GoalCard({required this.goal});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final daysLeft = goal.targetDate?.difference(DateTime.now()).inDays;
    final tasksAsync = ref.watch(goalTasksProvider(goal.id));
    final tasks = tasksAsync.valueOrNull ?? [];
    final doneCount = tasks.where((t) => t.status == 'done').length;
    final totalCount = tasks.length;
    final progress = totalCount > 0 ? doneCount / totalCount : 0.0;

    return Card(
      child: InkWell(
        onTap: () => _showGoalDetail(context, ref),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: MindHauseTheme.bronzeGold.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.emoji_events,
                    color: MindHauseTheme.bronzeGold, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(goal.name,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    if (goal.description.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(goal.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 13, color: MindHauseTheme.slateBlue)),
                    ],
                    if (totalCount > 0) ...[
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: progress,
                                minHeight: 6,
                                backgroundColor:
                                    MindHauseTheme.warmStone.withValues(alpha: 0.3),
                                valueColor: AlwaysStoppedAnimation(
                                    progress >= 1.0
                                        ? MindHauseTheme.deepOlive
                                        : MindHauseTheme.bronzeGold),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text('$doneCount/$totalCount',
                              style: TextStyle(
                                  fontSize: 11,
                                  color: MindHauseTheme.slateBlue)),
                        ],
                      ),
                    ],
                    if (daysLeft != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        daysLeft > 0
                            ? '$daysLeft days remaining'
                            : daysLeft == 0
                                ? 'Due today'
                                : '${-daysLeft} days overdue',
                        style: TextStyle(
                          fontSize: 12,
                          color: daysLeft < 0
                              ? MindHauseTheme.urgentRed
                              : daysLeft <= 7
                                  ? MindHauseTheme.terracotta
                                  : MindHauseTheme.slateBlue,
                          fontWeight: daysLeft <= 0
                              ? FontWeight.w600
                              : FontWeight.normal,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: MindHauseTheme.warmStone),
            ],
          ),
        ),
      ),
    );
  }

  void _showGoalDetail(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.5,
        minChildSize: 0.3,
        maxChildSize: 0.85,
        expand: false,
        builder: (ctx, scrollController) => Consumer(
          builder: (ctx, sheetRef, _) {
            final linkedTasks =
                sheetRef.watch(goalTasksProvider(goal.id)).valueOrNull ?? [];
            final done = linkedTasks.where((t) => t.status == 'done').length;
            final total = linkedTasks.length;
            final prog = total > 0 ? done / total : 0.0;

            return Padding(
              padding: const EdgeInsets.all(24),
              child: ListView(
                controller: scrollController,
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
                  Text(goal.name,
                      style: Theme.of(ctx)
                          .textTheme
                          .titleLarge
                          ?.copyWith(fontWeight: FontWeight.w600)),
                  if (goal.description.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(goal.description,
                        style: TextStyle(color: MindHauseTheme.slateBlue)),
                  ],
                  if (goal.targetDate != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.flag,
                            size: 18, color: MindHauseTheme.terracotta),
                        const SizedBox(width: 8),
                        Text(
                            'Target: ${DateFormat.yMMMd().format(goal.targetDate!)}'),
                      ],
                    ),
                  ],

                  // Progress
                  if (total > 0) ...[
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('Progress: ',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color: MindHauseTheme.inkDark)),
                        Text('$done of $total tasks done',
                            style: TextStyle(color: MindHauseTheme.slateBlue)),
                      ],
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: prog,
                        minHeight: 8,
                        backgroundColor:
                            MindHauseTheme.warmStone.withValues(alpha: 0.3),
                        valueColor: AlwaysStoppedAnimation(prog >= 1.0
                            ? MindHauseTheme.deepOlive
                            : MindHauseTheme.bronzeGold),
                      ),
                    ),
                  ],

                  // Linked tasks
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Text('Linked Tasks',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: MindHauseTheme.inkDark)),
                      const Spacer(),
                      TextButton.icon(
                        onPressed: () => _linkExistingTask(ctx, sheetRef),
                        icon: const Icon(Icons.add_link, size: 18),
                        label: const Text('Link Task'),
                      ),
                    ],
                  ),
                  if (linkedTasks.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text('No tasks linked to this goal.',
                          style: TextStyle(
                              fontSize: 13, color: MindHauseTheme.warmStone)),
                    ),
                  ...linkedTasks.map((task) => ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          task.status == 'done'
                              ? Icons.check_circle
                              : Icons.radio_button_unchecked,
                          color: task.status == 'done'
                              ? MindHauseTheme.deepOlive
                              : MindHauseTheme.warmStone,
                        ),
                        title: Text(task.title,
                            style: TextStyle(
                              decoration: task.status == 'done'
                                  ? TextDecoration.lineThrough
                                  : null,
                            )),
                        trailing: IconButton(
                          icon: const Icon(Icons.link_off, size: 18),
                          tooltip: 'Unlink',
                          onPressed: () async {
                            await sheetRef
                                .read(itemsDaoProvider)
                                .updateItem(ItemsCompanion(
                                  id: Value(task.id),
                                  goalId: const Value(null),
                                ));
                          },
                        ),
                      )),

                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () async {
                            await sheetRef
                                .read(projectsDaoProvider)
                                .updateGoal(GoalsCompanion(
                                  id: Value(goal.id),
                                  status: const Value('achieved'),
                                ));
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.check),
                          label: const Text('Achieved'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            await sheetRef
                                .read(projectsDaoProvider)
                                .deleteGoal(goal.id);
                            if (ctx.mounted) Navigator.pop(ctx);
                          },
                          icon: const Icon(Icons.delete_outline,
                              color: Colors.red),
                          label: const Text('Delete',
                              style: TextStyle(color: Colors.red)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Show a dialog to pick an existing unlinked task and link it to this goal.
  void _linkExistingTask(BuildContext context, WidgetRef ref) async {
    // Fetch tasks not linked to any goal
    final dao = ref.read(itemsDaoProvider);
    final allTasks = await (dao.watchItemsByType('task').first);
    final unlinked =
        allTasks.where((t) => t.goalId == null && t.status != 'done').toList();

    if (!context.mounted) return;

    final picked = await showDialog<Item>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Link a Task'),
        content: SizedBox(
          width: double.maxFinite,
          child: unlinked.isEmpty
              ? const Text('No unlinked tasks available.')
              : ListView.builder(
                  shrinkWrap: true,
                  itemCount: unlinked.length,
                  itemBuilder: (ctx, i) => ListTile(
                    title: Text(unlinked[i].title),
                    onTap: () => Navigator.pop(ctx, unlinked[i]),
                  ),
                ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );

    if (picked != null) {
      await dao.updateItem(ItemsCompanion(
        id: Value(picked.id),
        goalId: Value(goal.id),
      ));
    }
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme.dart';
import '../../../shared/database/providers.dart';
import '../../../shared/services/recurrence_service.dart';
import '../data/task_providers.dart';
import 'widgets/create_task_sheet.dart';
import 'widgets/task_card.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(taskFilterProvider);
    final tasksAsync = ref.watch(filteredTasksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tasks'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/search'),
          ),
          PopupMenuButton<TaskSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            onSelected: (sort) =>
                ref.read(taskSortProvider.notifier).state = sort,
            itemBuilder: (_) {
              final current = ref.read(taskSortProvider);
              return [
                _sortMenuItem(TaskSort.priority, 'Priority', Icons.flag, current),
                _sortMenuItem(TaskSort.dueDate, 'Due Date', Icons.calendar_today, current),
                _sortMenuItem(TaskSort.alphabetical, 'A–Z', Icons.sort_by_alpha, current),
                _sortMenuItem(TaskSort.newest, 'Newest', Icons.arrow_downward, current),
                _sortMenuItem(TaskSort.oldest, 'Oldest', Icons.arrow_upward, current),
              ];
            },
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            onSelected: (route) => context.push(route),
            itemBuilder: (_) => const [
              PopupMenuItem(
                  value: '/calendar',
                  child: ListTile(
                      leading: Icon(Icons.calendar_month),
                      title: Text('Calendar'),
                      contentPadding: EdgeInsets.zero)),
              PopupMenuItem(
                  value: '/habits',
                  child: ListTile(
                      leading: Icon(Icons.eco),
                      title: Text('Habits'),
                      contentPadding: EdgeInsets.zero)),
              PopupMenuItem(
                  value: '/goals',
                  child: ListTile(
                      leading: Icon(Icons.flag),
                      title: Text('Goals'),
                      contentPadding: EdgeInsets.zero)),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          // Dashboard summary
          const _DashboardSummary(),

          // Filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _FilterChip(
                  label: 'All',
                  selected: filter == TaskFilter.all,
                  onSelected: () => ref.read(taskFilterProvider.notifier).state =
                      TaskFilter.all,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'To Do',
                  selected: filter == TaskFilter.todo,
                  onSelected: () => ref.read(taskFilterProvider.notifier).state =
                      TaskFilter.todo,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'In Progress',
                  selected: filter == TaskFilter.inProgress,
                  onSelected: () => ref.read(taskFilterProvider.notifier).state =
                      TaskFilter.inProgress,
                ),
                const SizedBox(width: 8),
                _FilterChip(
                  label: 'Done',
                  selected: filter == TaskFilter.done,
                  onSelected: () => ref.read(taskFilterProvider.notifier).state =
                      TaskFilter.done,
                ),
              ],
            ),
          ),

          // Task list
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return _EmptyState(filter: filter);
                }
                return ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return TaskCard(
                      task: task,
                      onTap: () => context.push('/task/${task.id}'),
                      onComplete: task.status != 'done'
                          ? () async {
                              final dao = ref.read(itemsDaoProvider);
                              await dao.completeItem(task.id);
                              if (task.recurrenceRule != null &&
                                  task.recurrenceRule!.isNotEmpty) {
                                final updated =
                                    await dao.getItemById(task.id);
                                if (updated != null) {
                                  await ref
                                      .read(recurrenceServiceProvider)
                                      .createNextOccurrence(dao, updated);
                                }
                              }
                            }
                          : null,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(
                child: Text('Failed to load tasks: $e'),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateSheet(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  PopupMenuItem<TaskSort> _sortMenuItem(
      TaskSort sort, String label, IconData icon, TaskSort current) {
    return PopupMenuItem(
      value: sort,
      child: ListTile(
        leading: Icon(icon),
        title: Text(label),
        trailing: current == sort
            ? const Icon(Icons.check, size: 18)
            : null,
        contentPadding: EdgeInsets.zero,
      ),
    );
  }

  void _showCreateSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => const CreateTaskSheet(),
    );
  }

}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onSelected;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onSelected(),
    );
  }
}

class _DashboardSummary extends ConsumerWidget {
  const _DashboardSummary();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dueTodayAsync = ref.watch(dueTodayCountProvider);
    final overdueAsync = ref.watch(overdueCountProvider);
    final activeAsync = ref.watch(activeTaskCountProvider);

    final dueToday = dueTodayAsync.valueOrNull ?? 0;
    final overdue = overdueAsync.valueOrNull ?? 0;
    final active = activeAsync.valueOrNull ?? 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _SummaryChip(
            icon: Icons.today,
            label: 'Due Today',
            count: dueToday,
            color: MindHauseTheme.bronzeGold,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            icon: Icons.warning_amber,
            label: 'Overdue',
            count: overdue,
            color: overdue > 0
                ? MindHauseTheme.urgentRed
                : MindHauseTheme.slateBlue,
          ),
          const SizedBox(width: 8),
          _SummaryChip(
            icon: Icons.task_alt,
            label: 'Active',
            count: active,
            color: MindHauseTheme.deepOlive,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _SummaryChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(height: 4),
            Text(
              '$count',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
            Text(
              label,
              style: TextStyle(fontSize: 10, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final TaskFilter filter;

  const _EmptyState({required this.filter});

  @override
  Widget build(BuildContext context) {
    String message;
    IconData icon;
    switch (filter) {
      case TaskFilter.all:
        message = 'No tasks yet.\nTap + to create your first task.';
        icon = Icons.task_alt;
      case TaskFilter.todo:
        message = 'Nothing to do — enjoy the calm.';
        icon = Icons.check_circle_outline;
      case TaskFilter.inProgress:
        message = 'Nothing in progress.';
        icon = Icons.hourglass_empty;
      case TaskFilter.done:
        message = 'No completed tasks yet.';
        icon = Icons.emoji_events_outlined;
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 64, color: MindHauseTheme.warmStone),
          const SizedBox(height: 16),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: MindHauseTheme.slateBlue,
            ),
          ),
        ],
      ),
    );
  }
}


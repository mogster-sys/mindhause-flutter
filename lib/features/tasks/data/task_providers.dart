import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Current filter for the task list
enum TaskFilter { all, todo, inProgress, done }

/// Sort order for the task list
enum TaskSort { priority, dueDate, alphabetical, newest, oldest }

final taskFilterProvider = StateProvider<TaskFilter>((ref) => TaskFilter.all);
final taskSortProvider = StateProvider<TaskSort>((ref) => TaskSort.priority);

/// Watch tasks based on current filter, then sort client-side
final filteredTasksProvider = StreamProvider((ref) {
  final dao = ref.watch(itemsDaoProvider);
  final filter = ref.watch(taskFilterProvider);
  final sort = ref.watch(taskSortProvider);

  Stream stream;
  switch (filter) {
    case TaskFilter.all:
      stream = dao.watchItemsByType('task');
    case TaskFilter.todo:
      stream = dao.watchItemsByStatus('task', 'todo');
    case TaskFilter.inProgress:
      stream = dao.watchItemsByStatus('task', 'in_progress');
    case TaskFilter.done:
      stream = dao.watchItemsByStatus('task', 'done');
  }

  return stream.map((tasks) {
    final sorted = List.of(tasks);
    switch (sort) {
      case TaskSort.priority:
        // Already sorted by priority from DAO, no-op
        break;
      case TaskSort.dueDate:
        sorted.sort((a, b) {
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      case TaskSort.alphabetical:
        sorted.sort(
            (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
      case TaskSort.newest:
        sorted.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case TaskSort.oldest:
        sorted.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    }
    return sorted;
  });
});

/// Watch a single task by ID
final taskDetailProvider = StreamProvider.family((ref, String id) {
  return ref.watch(itemsDaoProvider).watchItem(id);
});

/// Watch subtasks for a given item
final subtasksProvider = StreamProvider.family((ref, String itemId) {
  return ref.watch(itemsDaoProvider).watchSubtasks(itemId);
});

/// Count of tasks due today
final dueTodayProvider = StreamProvider((ref) {
  return ref.watch(itemsDaoProvider).watchDueToday();
});

/// Task counts by status
final todoCountProvider = StreamProvider((ref) {
  return ref.watch(itemsDaoProvider).watchCountByStatus('task', 'todo');
});

final inProgressCountProvider = StreamProvider((ref) {
  return ref.watch(itemsDaoProvider).watchCountByStatus('task', 'in_progress');
});

/// Count of tasks due today (for dashboard)
final dueTodayCountProvider = StreamProvider<int>((ref) {
  return ref.watch(itemsDaoProvider).watchDueToday().map((items) => items.length);
});

/// Count of overdue tasks (past due date, not done)
final overdueCountProvider = StreamProvider<int>((ref) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return ref.watch(itemsDaoProvider).watchItemsByType('task').map(
      (items) => items
          .where((t) =>
              t.dueDate != null &&
              t.dueDate!.isBefore(today) &&
              t.status != 'done' &&
              t.status != 'archived')
          .length);
});

/// Count of active (non-done, non-archived) tasks
final activeTaskCountProvider = StreamProvider<int>((ref) {
  return ref.watch(itemsDaoProvider).watchItemsByType('task').map(
      (items) => items
          .where((t) => t.status != 'done' && t.status != 'archived')
          .length);
});

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';

/// Provider that watches items with a due date within the given month.
final _monthItemsProvider =
    StreamProvider.family((ref, DateTime month) {
  final dao = ref.watch(itemsDaoProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1);
  return dao.watchItemsWithDueDate().map((items) => items
      .where((i) => !i.dueDate!.isBefore(start) && i.dueDate!.isBefore(end))
      .toList());
});

/// Provider that watches habit log entries for a given month
final _monthHabitLogsProvider =
    StreamProvider.family((ref, DateTime month) {
  final dao = ref.watch(habitsDaoProvider);
  final start = DateTime(month.year, month.month);
  final end = DateTime(month.year, month.month + 1);
  return dao.watchLogRange(start, end);
});

class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  late DateTime _focusedMonth;
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _focusedMonth = DateTime(now.year, now.month);
    _selectedDay = DateTime(now.year, now.month, now.day);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(_monthItemsProvider(_focusedMonth));
    final habitLogsAsync = ref.watch(_monthHabitLogsProvider(_focusedMonth));
    final habitLogs = habitLogsAsync.valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar'),
        actions: [
          TextButton(
            onPressed: () {
              final now = DateTime.now();
              setState(() {
                _focusedMonth = DateTime(now.year, now.month);
                _selectedDay = DateTime(now.year, now.month, now.day);
              });
            },
            child: const Text('Today'),
          ),
        ],
      ),
      body: Column(
        children: [
          // Month navigation
          _MonthHeader(
            month: _focusedMonth,
            onPrevious: () => setState(() {
              _focusedMonth = DateTime(
                  _focusedMonth.year, _focusedMonth.month - 1);
            }),
            onNext: () => setState(() {
              _focusedMonth = DateTime(
                  _focusedMonth.year, _focusedMonth.month + 1);
            }),
          ),

          // Day-of-week headers
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                  .map((d) => Expanded(
                        child: Center(
                          child: Text(d,
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: MindHauseTheme.slateBlue)),
                        ),
                      ))
                  .toList(),
            ),
          ),
          const SizedBox(height: 4),

          // Calendar grid
          tasksAsync.when(
            data: (tasks) {
              final tasksByDay = _groupByDay(tasks);
              final habitDays = _habitLogDays(habitLogs);
              return _CalendarGrid(
                month: _focusedMonth,
                selectedDay: _selectedDay,
                tasksByDay: tasksByDay,
                habitDays: habitDays,
                onDaySelected: (day) => setState(() => _selectedDay = day),
              );
            },
            loading: () => const SizedBox(
                height: 240, child: Center(child: CircularProgressIndicator())),
            error: (e, _) => Text('Error: $e'),
          ),

          const Divider(height: 1),

          // Selected day's items and habit completions
          Expanded(
            child: tasksAsync.when(
              data: (tasks) {
                if (_selectedDay == null) {
                  return const Center(child: Text('Select a day'));
                }
                final dayTasks = tasks.where((t) {
                  if (t.dueDate == null) return false;
                  return t.dueDate!.year == _selectedDay!.year &&
                      t.dueDate!.month == _selectedDay!.month &&
                      t.dueDate!.day == _selectedDay!.day;
                }).toList();
                final dayHabitLogs = habitLogs.where((l) =>
                    l.completedAt.year == _selectedDay!.year &&
                    l.completedAt.month == _selectedDay!.month &&
                    l.completedAt.day == _selectedDay!.day).toList();

                if (dayTasks.isEmpty && dayHabitLogs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.event_available,
                            size: 48, color: MindHauseTheme.warmStone),
                        const SizedBox(height: 8),
                        Text(
                          'Nothing scheduled for ${DateFormat.MMMd().format(_selectedDay!)}',
                          style:
                              TextStyle(color: MindHauseTheme.slateBlue),
                        ),
                      ],
                    ),
                  );
                }

                return ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ...dayTasks.map((t) => _DayTaskTile(task: t)),
                    if (dayHabitLogs.isNotEmpty) ...[
                      if (dayTasks.isNotEmpty) const SizedBox(height: 8),
                      ...dayHabitLogs.map((log) => Card(
                            child: ListTile(
                              leading: const Icon(Icons.eco,
                                  color: MindHauseTheme.deepOlive),
                              title: const Text('Habit check-in'),
                              subtitle: Text(
                                DateFormat.jm().format(log.completedAt),
                                style: TextStyle(
                                    fontSize: 12,
                                    color: MindHauseTheme.slateBlue),
                              ),
                            ),
                          )),
                    ],
                  ],
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

  Map<int, List<Item>> _groupByDay(List<Item> tasks) {
    final map = <int, List<Item>>{};
    for (final task in tasks) {
      if (task.dueDate == null) continue;
      if (task.dueDate!.year != _focusedMonth.year ||
          task.dueDate!.month != _focusedMonth.month) {
        continue;
      }
      map.putIfAbsent(task.dueDate!.day, () => []).add(task);
    }
    return map;
  }

  Set<int> _habitLogDays(List<HabitLogData> logs) {
    final days = <int>{};
    for (final log in logs) {
      if (log.completedAt.year == _focusedMonth.year &&
          log.completedAt.month == _focusedMonth.month) {
        days.add(log.completedAt.day);
      }
    }
    return days;
  }
}

class _MonthHeader extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  const _MonthHeader({
    required this.month,
    required this.onPrevious,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: Center(
              child: Text(
                DateFormat.yMMMM().format(month),
                style: const TextStyle(
                    fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }
}

class _CalendarGrid extends StatelessWidget {
  final DateTime month;
  final DateTime? selectedDay;
  final Map<int, List<Item>> tasksByDay;
  final Set<int> habitDays;
  final ValueChanged<DateTime> onDaySelected;

  const _CalendarGrid({
    required this.month,
    required this.selectedDay,
    required this.tasksByDay,
    required this.habitDays,
    required this.onDaySelected,
  });

  @override
  Widget build(BuildContext context) {
    final firstOfMonth = DateTime(month.year, month.month, 1);
    // Monday = 1, so offset is (weekday - 1)
    final startOffset = firstOfMonth.weekday - 1;
    final daysInMonth =
        DateTime(month.year, month.month + 1, 0).day;
    final totalCells = startOffset + daysInMonth;
    final rows = (totalCells / 7).ceil();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            children: List.generate(7, (col) {
              final index = row * 7 + col;
              if (index < startOffset || index >= startOffset + daysInMonth) {
                return const Expanded(child: SizedBox(height: 40));
              }
              final day = index - startOffset + 1;
              final date = DateTime(month.year, month.month, day);
              final isToday = date == today;
              final isSelected = selectedDay != null &&
                  date.year == selectedDay!.year &&
                  date.month == selectedDay!.month &&
                  date.day == selectedDay!.day;
              final tasks = tasksByDay[day];
              final hasOverdue = tasks?.any((t) =>
                      t.status != 'done' && date.isBefore(today)) ??
                  false;
              final hasHabit = habitDays.contains(day);
              final hasTasks = tasks != null && tasks.isNotEmpty;

              return Expanded(
                child: GestureDetector(
                  onTap: () => onDaySelected(date),
                  child: Container(
                    height: 40,
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? MindHauseTheme.terracotta.withValues(alpha: 0.15)
                          : isToday
                              ? MindHauseTheme.bronzeGold
                                  .withValues(alpha: 0.1)
                              : null,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '$day',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isToday || isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                            color: isSelected
                                ? MindHauseTheme.terracotta
                                : isToday
                                    ? MindHauseTheme.bronzeGold
                                    : null,
                          ),
                        ),
                        if (hasTasks || hasHabit)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (hasTasks)
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: hasOverdue
                                        ? MindHauseTheme.urgentRed
                                        : MindHauseTheme.terracotta,
                                  ),
                                ),
                              if (hasHabit) ...[
                                if (hasTasks) const SizedBox(width: 2),
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: MindHauseTheme.deepOlive,
                                  ),
                                ),
                              ],
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}

class _DayTaskTile extends StatelessWidget {
  final Item task;
  const _DayTaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final isDone = task.status == 'done';
    return Card(
      child: ListTile(
        leading: Icon(
          isDone ? Icons.check_circle : Icons.radio_button_unchecked,
          color: isDone ? MindHauseTheme.deepOlive : MindHauseTheme.slateBlue,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: isDone ? TextDecoration.lineThrough : null,
            color: isDone
                ? Theme.of(context)
                    .colorScheme
                    .onSurface
                    .withValues(alpha: 0.5)
                : null,
          ),
        ),
        subtitle: task.room != null
            ? Row(
                children: [
                  Icon(MindHauseTheme.roomIcon(task.room!),
                      size: 14, color: MindHauseTheme.warmStone),
                  const SizedBox(width: 4),
                  Text(task.room!,
                      style: TextStyle(
                          fontSize: 12, color: MindHauseTheme.warmStone)),
                ],
              )
            : null,
        trailing: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: MindHauseTheme.priorityColor(task.priority),
          ),
        ),
      ),
    );
  }
}

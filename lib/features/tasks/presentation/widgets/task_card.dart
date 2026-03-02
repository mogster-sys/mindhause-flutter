import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../app/theme.dart';
import '../../../../shared/database/app_database.dart';

class TaskCard extends StatelessWidget {
  final Item task;
  final VoidCallback onTap;
  final VoidCallback? onComplete;

  const TaskCard({
    super.key,
    required this.task,
    required this.onTap,
    this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue =
        task.dueDate != null && task.dueDate!.isBefore(DateTime.now());
    final isDone = task.status == 'done';

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              // Completion checkbox
              _CompletionCheckbox(
                isDone: isDone,
                priority: task.priority,
                onTap: onComplete,
              ),
              const SizedBox(width: 12),
              // Task info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        decoration:
                            isDone ? TextDecoration.lineThrough : null,
                        color: isDone
                            ? Theme.of(context)
                                .colorScheme
                                .onSurface
                                .withValues(alpha: 0.5)
                            : null,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Due date
                        if (task.dueDate != null) ...[
                          Icon(
                            Icons.schedule,
                            size: 14,
                            color: isOverdue && !isDone
                                ? MindHauseTheme.urgentRed
                                : MindHauseTheme.slateBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            _formatDueDate(task.dueDate!),
                            style: TextStyle(
                              fontSize: 12,
                              color: isOverdue && !isDone
                                  ? MindHauseTheme.urgentRed
                                  : MindHauseTheme.slateBlue,
                              fontWeight: isOverdue && !isDone
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(width: 12),
                        ],
                        // Recurrence
                        if (task.recurrenceRule != null &&
                            task.recurrenceRule!.isNotEmpty) ...[
                          const Icon(
                            Icons.repeat,
                            size: 14,
                            color: MindHauseTheme.slateBlue,
                          ),
                          const SizedBox(width: 12),
                        ],
                        // Room
                        if (task.room != null) ...[
                          Icon(
                            MindHauseTheme.roomIcon(task.room!),
                            size: 14,
                            color: MindHauseTheme.slateBlue,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            task.room!,
                            style: const TextStyle(
                              fontSize: 12,
                              color: MindHauseTheme.slateBlue,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Monster indicator
              if (task.monsterState != 'none') ...[
                _MonsterIndicator(state: task.monsterState),
              ],
              // Priority pip
              _PriorityPip(priority: task.priority),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDueDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));
    final dateOnly = DateTime(date.year, date.month, date.day);

    if (dateOnly == today) return 'Today';
    if (dateOnly == tomorrow) return 'Tomorrow';
    if (dateOnly.isBefore(today)) {
      final days = today.difference(dateOnly).inDays;
      return '${days}d overdue';
    }
    if (date.difference(now).inDays < 7) {
      return DateFormat.EEEE().format(date);
    }
    return DateFormat.MMMd().format(date);
  }
}

class _CompletionCheckbox extends StatelessWidget {
  final bool isDone;
  final String priority;
  final VoidCallback? onTap;

  const _CompletionCheckbox({
    required this.isDone,
    required this.priority,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isDone
                ? MindHauseTheme.completedGold
                : MindHauseTheme.priorityColor(priority),
            width: 2,
          ),
          color: isDone ? MindHauseTheme.completedGold : Colors.transparent,
        ),
        child: isDone
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : null,
      ),
    );
  }
}

class _PriorityPip extends StatelessWidget {
  final String priority;

  const _PriorityPip({required this.priority});

  @override
  Widget build(BuildContext context) {
    if (priority == 'normal') return const SizedBox.shrink();
    return Container(
      width: 8,
      height: 8,
      margin: const EdgeInsets.only(left: 8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: MindHauseTheme.priorityColor(priority),
      ),
    );
  }
}

class _MonsterIndicator extends StatelessWidget {
  final String state;

  const _MonsterIndicator({required this.state});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (state) {
      case 'neglected':
        icon = Icons.warning_amber;
        color = MindHauseTheme.priorityNormal;
      case 'corrupting':
        icon = Icons.whatshot;
        color = Colors.deepOrange;
      case 'monster':
        icon = Icons.pest_control;
        color = MindHauseTheme.urgentRed;
      default:
        return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(icon, size: 18, color: color),
    );
  }
}

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../data/habit_providers.dart';

class HabitsScreen extends ConsumerWidget {
  const HabitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final habitsAsync = ref.watch(habitsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Habits')),
      body: habitsAsync.when(
        data: (habits) {
          if (habits.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.eco_outlined,
                      size: 64, color: MindHauseTheme.warmStone),
                  const SizedBox(height: 16),
                  Text(
                    'No habits yet.\nTap + to plant your first seed.',
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
            itemCount: habits.length,
            itemBuilder: (context, index) {
              final habit = habits[index];
              return _HabitCard(habit: habit);
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateHabit(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showCreateHabit(BuildContext context, WidgetRef ref) {
    final titleController = TextEditingController();
    String frequency = 'daily';

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
                Text('New Habit',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: MindHauseTheme.inkDark)),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  autofocus: true,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    hintText: 'e.g. Meditate, Exercise, Read',
                    labelText: 'Habit name',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Text('Frequency: ',
                        style: TextStyle(fontWeight: FontWeight.w500)),
                    const SizedBox(width: 8),
                    ...['daily', 'weekly'].map((f) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(f[0].toUpperCase() + f.substring(1)),
                            selected: frequency == f,
                            onSelected: (_) =>
                                setSheetState(() => frequency = f),
                          ),
                        )),
                  ],
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: () async {
                    final title = titleController.text.trim();
                    if (title.isEmpty) return;
                    final now = DateTime.now();
                    final itemId = const Uuid().v4();
                    final habitId = const Uuid().v4();
                    // Create the item (type='habit')
                    await ref.read(itemsDaoProvider).createItem(
                          ItemsCompanion.insert(
                            id: itemId,
                            title: title,
                            type: 'habit',
                            createdAt: now,
                            updatedAt: now,
                            lastInteraction: now,
                            room: const Value('garden'),
                            objectType: const Value('plant'),
                          ),
                        );

                    // Create the habit metadata
                    await ref.read(habitsDaoProvider).createHabit(
                          HabitsCompanion.insert(
                            id: habitId,
                            itemId: itemId,
                            frequency: frequency,
                          ),
                        );

                    if (ctx.mounted) Navigator.pop(ctx);
                  },
                  icon: const Icon(Icons.eco),
                  label: const Text('Plant Habit'),
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

class _HabitCard extends ConsumerWidget {
  final Item habit;
  const _HabitCard({required this.habit});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final metaAsync = ref.watch(habitMetaProvider(habit.id));
    final meta = metaAsync.valueOrNull;
    final streak = meta?.currentStreak ?? 0;
    final bestStreak = meta?.bestStreak ?? 0;
    final habitId = meta?.id;

    // Check if completed today
    final todayAsync =
        habitId != null ? ref.watch(todayCompletionsProvider(habitId)) : null;
    final doneToday =
        todayAsync?.valueOrNull?.isNotEmpty ?? false;

    return Card(
      child: InkWell(
        onTap: () => _showDetail(context, ref, meta),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Streak plant icon
              _PlantIcon(streak: streak),
              const SizedBox(width: 16),
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(habit.title,
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500)),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.local_fire_department,
                            size: 16, color: _streakColor(streak)),
                        const SizedBox(width: 4),
                        Text('$streak day streak',
                            style: TextStyle(
                                fontSize: 13, color: _streakColor(streak))),
                        if (bestStreak > streak) ...[
                          const SizedBox(width: 12),
                          Icon(Icons.emoji_events,
                              size: 14, color: MindHauseTheme.warmStone),
                          const SizedBox(width: 2),
                          Text('Best: $bestStreak',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: MindHauseTheme.warmStone)),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              // Check-in button
              if (habitId != null)
                IconButton(
                  onPressed: doneToday
                      ? null
                      : () => _checkIn(ref, habitId, streak, bestStreak),
                  icon: Icon(
                    doneToday
                        ? Icons.check_circle
                        : Icons.radio_button_unchecked,
                    color: doneToday
                        ? MindHauseTheme.deepOlive
                        : MindHauseTheme.terracotta,
                    size: 32,
                  ),
                  tooltip: doneToday ? 'Done for today' : 'Check in',
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _checkIn(
      WidgetRef ref, String habitId, int streak, int bestStreak) async {
    final habitsDao = ref.read(habitsDaoProvider);
    await habitsDao.checkIn(habitId, streak, bestStreak);

    // Update the item's last interaction
    final now = DateTime.now();
    await ref.read(itemsDaoProvider).updateItem(ItemsCompanion(
          id: Value(habit.id),
          lastInteraction: Value(now),
          updatedAt: Value(now),
        ));
  }

  void _showDetail(BuildContext context, WidgetRef ref, Habit? meta) {
    if (meta == null) return;
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
            Text(habit.title,
                style: Theme.of(ctx)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.w600)),
            const SizedBox(height: 16),
            _DetailRow(
                icon: Icons.repeat, label: 'Frequency', value: meta.frequency),
            _DetailRow(
                icon: Icons.local_fire_department,
                label: 'Current Streak',
                value: '${meta.currentStreak} days'),
            _DetailRow(
                icon: Icons.emoji_events,
                label: 'Best Streak',
                value: '${meta.bestStreak} days'),
            if (meta.lastCompleted != null)
              _DetailRow(
                  icon: Icons.check_circle,
                  label: 'Last Completed',
                  value: _formatDate(meta.lastCompleted!)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(habitsDaoProvider).resetStreak(meta.id);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    icon: const Icon(Icons.refresh),
                    label: const Text('Reset Streak'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      await ref.read(habitsDaoProvider).deleteHabit(meta.id);
                      await ref.read(itemsDaoProvider).deleteItem(habit.id);
                      if (ctx.mounted) Navigator.pop(ctx);
                    },
                    icon:
                        const Icon(Icons.delete_outline, color: Colors.red),
                    label: const Text('Delete',
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    return '${diff.inDays} days ago';
  }

  Color _streakColor(int streak) {
    if (streak >= 30) return MindHauseTheme.deepOlive;
    if (streak >= 7) return MindHauseTheme.terracotta;
    if (streak > 0) return MindHauseTheme.bronzeGold;
    return MindHauseTheme.slateBlue;
  }
}

class _PlantIcon extends StatelessWidget {
  final int streak;
  const _PlantIcon({required this.streak});

  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    double size;

    if (streak >= 30) {
      icon = Icons.park;
      color = MindHauseTheme.deepOlive;
      size = 36;
    } else if (streak >= 14) {
      icon = Icons.forest;
      color = const Color(0xFF68A357);
      size = 32;
    } else if (streak >= 7) {
      icon = Icons.eco;
      color = MindHauseTheme.terracotta;
      size = 28;
    } else if (streak > 0) {
      icon = Icons.grass;
      color = MindHauseTheme.bronzeGold;
      size = 24;
    } else {
      icon = Icons.grain;
      color = MindHauseTheme.warmStone;
      size = 20;
    }

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: size),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _DetailRow(
      {required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, size: 20, color: MindHauseTheme.slateBlue),
          const SizedBox(width: 12),
          Text('$label: ',
              style: TextStyle(
                  color: MindHauseTheme.slateBlue,
                  fontWeight: FontWeight.w500)),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

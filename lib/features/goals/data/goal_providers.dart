import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Watch all active goals
final activeGoalsProvider = StreamProvider((ref) {
  return ref.watch(projectsDaoProvider).watchActiveGoals();
});

/// Watch tasks linked to a specific goal
final goalTasksProvider = StreamProvider.family((ref, String goalId) {
  return ref.watch(itemsDaoProvider).watchItemsByGoal(goalId);
});

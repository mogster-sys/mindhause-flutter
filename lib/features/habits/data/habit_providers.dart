import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Watch all habit items (items with type='habit')
final habitsProvider = StreamProvider((ref) {
  final dao = ref.watch(itemsDaoProvider);
  return dao.watchItemsByType('habit');
});

/// Watch habit metadata for a given item
final habitMetaProvider = StreamProvider.family((ref, String itemId) {
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchByItemId(itemId);
});

/// Watch today's completions (for checking if already done today)
final todayCompletionsProvider = StreamProvider.family((ref, String habitId) {
  final dao = ref.watch(habitsDaoProvider);
  return dao.watchTodayCompletions(habitId);
});

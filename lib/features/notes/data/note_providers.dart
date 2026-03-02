import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Watch all notes
final notesProvider = StreamProvider((ref) {
  return ref.watch(itemsDaoProvider).watchItemsByType('note');
});

/// Search notes
final noteSearchProvider = StreamProvider.family((ref, String query) {
  return ref.watch(itemsDaoProvider).searchItems(query);
});

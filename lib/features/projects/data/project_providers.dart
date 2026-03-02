import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Watch all active (non-archived) projects
final activeProjectsProvider = StreamProvider((ref) {
  return ref.watch(projectsDaoProvider).watchActiveProjects();
});

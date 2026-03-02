import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'theme.dart';
import '../features/settings/data/settings_providers.dart';
import '../features/tasks/presentation/task_list_screen.dart';
import '../features/projects/presentation/projects_screen.dart';
import '../features/notes/presentation/notes_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tasks/presentation/task_detail_screen.dart';
import '../features/palace/presentation/palace_screen.dart';
import '../features/calendar/presentation/calendar_screen.dart';
import '../features/habits/presentation/habits_screen.dart';
import '../features/goals/presentation/goals_screen.dart';
import '../features/search/presentation/search_screen.dart';
import '../features/focus/presentation/focus_timer_screen.dart';
import '../shared/widgets/app_shell.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/tasks',
    routes: [
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: '/tasks',
            builder: (context, state) => const TaskListScreen(),
          ),
          GoRoute(
            path: '/projects',
            builder: (context, state) => const ProjectsScreen(),
          ),
          GoRoute(
            path: '/notes',
            builder: (context, state) => const NotesScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const SettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/task/:id',
        builder: (context, state) => TaskDetailScreen(
          taskId: state.pathParameters['id']!,
        ),
      ),
      GoRoute(
        path: '/palace',
        builder: (context, state) => PalaceScreen(
          initialRoom: state.uri.queryParameters['room'] ?? 'foyer',
        ),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const CalendarScreen(),
      ),
      GoRoute(
        path: '/habits',
        builder: (context, state) => const HabitsScreen(),
      ),
      GoRoute(
        path: '/goals',
        builder: (context, state) => const GoalsScreen(),
      ),
      GoRoute(
        path: '/search',
        builder: (context, state) => const SearchScreen(),
      ),
      GoRoute(
        path: '/focus',
        builder: (context, state) => FocusTimerScreen(
          taskId: state.uri.queryParameters['taskId'],
          taskTitle: state.uri.queryParameters['taskTitle'],
        ),
      ),
    ],
  );
});

class MindHauseApp extends ConsumerWidget {
  const MindHauseApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final themeMode =
        ref.watch(themeModeProvider).valueOrNull ?? ThemeMode.system;

    return MaterialApp.router(
      title: 'MindHause',
      theme: MindHauseTheme.lightTheme,
      darkTheme: MindHauseTheme.darkTheme,
      themeMode: themeMode,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:mindhause/app/theme.dart';
import 'package:mindhause/shared/widgets/app_shell.dart';

void main() {
  group('AppShell', () {
    Widget buildShell({String initialLocation = '/tasks'}) {
      final router = GoRouter(
        initialLocation: initialLocation,
        routes: [
          ShellRoute(
            builder: (context, state, child) => AppShell(child: child),
            routes: [
              GoRoute(
                path: '/tasks',
                builder: (_, _) => const Center(child: Text('Tasks Page')),
              ),
              GoRoute(
                path: '/projects',
                builder: (_, _) =>
                    const Center(child: Text('Projects Page')),
              ),
              GoRoute(
                path: '/notes',
                builder: (_, _) => const Center(child: Text('Notes Page')),
              ),
              GoRoute(
                path: '/settings',
                builder: (_, _) =>
                    const Center(child: Text('Settings Page')),
              ),
            ],
          ),
          GoRoute(
            path: '/palace',
            builder: (_, _) => const Center(child: Text('Palace Page')),
          ),
        ],
      );

      return ProviderScope(
        child: MaterialApp.router(
          theme: MindHauseTheme.lightTheme,
          routerConfig: router,
        ),
      );
    }

    testWidgets('renders bottom navigation with 4 destinations',
        (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      expect(find.text('Tasks'), findsOneWidget);
      expect(find.text('Projects'), findsOneWidget);
      expect(find.text('Notes'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('renders Enter Palace FAB and Quick Capture FAB',
        (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      // Two FABs: quick capture (bolt) + palace (castle)
      expect(find.byType(FloatingActionButton), findsNWidgets(2));
      expect(find.byIcon(Icons.castle), findsOneWidget);
      expect(find.byIcon(Icons.bolt), findsOneWidget);
    });

    testWidgets('shows child content', (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      expect(find.text('Tasks Page'), findsOneWidget);
    });

    testWidgets('navigates to Projects tab', (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Projects'));
      await tester.pumpAndSettle();

      expect(find.text('Projects Page'), findsOneWidget);
    });

    testWidgets('navigates to Notes tab', (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Notes'));
      await tester.pumpAndSettle();

      expect(find.text('Notes Page'), findsOneWidget);
    });

    testWidgets('navigates to Settings tab', (tester) async {
      await tester.pumpWidget(buildShell());
      await tester.pumpAndSettle();

      await tester.tap(find.text('Settings'));
      await tester.pumpAndSettle();

      expect(find.text('Settings Page'), findsOneWidget);
    });
  });
}

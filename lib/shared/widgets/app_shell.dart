import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/theme.dart';
import '../../features/quick_capture/presentation/quick_capture_sheet.dart';
import '../../features/settings/data/settings_providers.dart';
import '../database/providers.dart';
import '../services/godot_bridge_service.dart';
import '../services/monster_evolution.dart';
import '../services/notification_service.dart';

/// Main app shell with bottom navigation, quick actions, and palace entry button.
/// Also runs periodic monster evolution checks.
class AppShell extends ConsumerStatefulWidget {
  final Widget child;

  const AppShell({super.key, required this.child});

  @override
  ConsumerState<AppShell> createState() => _AppShellState();
}

class _AppShellState extends ConsumerState<AppShell> {
  Timer? _initialTimer;
  Timer? _periodicTimer;

  @override
  void initState() {
    super.initState();
    // Run monster evaluation after DB has had time to init
    _initialTimer = Timer(
      const Duration(seconds: 2),
      _runMonsterEvaluation,
    );
    // Then every 5 minutes while the app is open
    _periodicTimer = Timer.periodic(
      const Duration(minutes: 5),
      (_) => _runMonsterEvaluation(),
    );
    // Wire Godot bridge callbacks
    _initGodotBridge();
    // Re-arm notifications for all upcoming tasks
    _rescheduleNotifications();
  }

  void _initGodotBridge() {
    final bridge = ref.read(godotBridgeProvider);
    bridge.onExitPalace(() {
      if (mounted) context.go('/tasks');
    });
    bridge.onTaskSelected((taskId) {
      if (mounted) context.push('/task/$taskId');
    });
  }

  Future<void> _rescheduleNotifications() async {
    final notificationsOn =
        ref.read(notificationsEnabledProvider).valueOrNull ?? false;
    if (!notificationsOn) return;
    final tasks =
        await ref.read(itemsDaoProvider).watchItemsWithDueDate().first;
    await ref.read(notificationServiceProvider).rescheduleAll(tasks);
  }

  @override
  void dispose() {
    _initialTimer?.cancel();
    _periodicTimer?.cancel();
    super.dispose();
  }

  Future<void> _runMonsterEvaluation() async {
    final db = ref.read(databaseProvider);
    final enabled =
        ref.read(monstersEnabledProvider).valueOrNull ?? true;
    final sensitivity =
        ref.read(monsterSensitivityProvider).valueOrNull ?? 'normal';
    await evaluateMonsterStates(db, enabled: enabled, sensitivity: sensitivity);
  }

  static int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith('/tasks')) return 0;
    if (location.startsWith('/projects')) return 1;
    if (location.startsWith('/notes')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Quick capture mini-FAB
          FloatingActionButton.small(
            heroTag: 'quick_capture',
            onPressed: () => showQuickCapture(context),
            backgroundColor: MindHauseTheme.deepOlive,
            foregroundColor: Colors.white,
            tooltip: 'Quick Capture',
            child: const Icon(Icons.bolt, size: 20),
          ),
          const SizedBox(height: 8),
          // Palace entry FAB
          FloatingActionButton(
            heroTag: 'palace',
            onPressed: () => context.push('/palace'),
            backgroundColor: MindHauseTheme.bronzeGold,
            foregroundColor: Colors.white,
            tooltip: 'Enter Palace',
            child: const Icon(Icons.castle),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/tasks');
            case 1:
              context.go('/projects');
            case 2:
              context.go('/notes');
            case 3:
              context.go('/settings');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.task_alt_outlined),
            selectedIcon: Icon(Icons.task_alt),
            label: 'Tasks',
          ),
          NavigationDestination(
            icon: Icon(Icons.folder_outlined),
            selectedIcon: Icon(Icons.folder),
            label: 'Projects',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}

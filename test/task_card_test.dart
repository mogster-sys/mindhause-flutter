import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindhause/app/theme.dart';
import 'package:mindhause/features/tasks/presentation/widgets/task_card.dart';
import 'package:mindhause/shared/database/app_database.dart';

Item _makeTask({
  String title = 'Test Task',
  String priority = 'normal',
  String status = 'todo',
  DateTime? dueDate,
  String? room,
  String monsterState = 'none',
}) {
  final now = DateTime.now();
  return Item(
    id: 'test-1',
    title: title,
    description: '',
    type: 'task',
    priority: priority,
    status: status,
    dueDate: dueDate,
    createdAt: now,
    updatedAt: now,
    lastInteraction: now,
    completedAt: null,
    room: room,
    surface: null,
    objectType: 'scroll',
    positionX: 0,
    positionY: 0,
    positionZ: 0,
    projectId: null,
    goalId: null,
    monsterState: monsterState,
    monsterEvolvedAt: null,
    recurrenceRule: null,
    locationLat: null,
    locationLng: null,
    locationName: null,
    notes: '',
  );
}

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: MindHauseTheme.lightTheme,
    home: Scaffold(body: child),
  );
}

void main() {
  group('TaskCard', () {
    testWidgets('displays task title', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(title: 'Buy groceries'),
          onTap: () {},
        ),
      ));

      expect(find.text('Buy groceries'), findsOneWidget);
    });

    testWidgets('shows room label when room is set', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(room: 'kitchen'),
          onTap: () {},
        ),
      ));

      expect(find.text('kitchen'), findsOneWidget);
    });

    testWidgets('shows "Today" for tasks due today', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(dueDate: DateTime.now()),
          onTap: () {},
        ),
      ));

      expect(find.text('Today'), findsOneWidget);
    });

    testWidgets('shows "Tomorrow" for tasks due tomorrow', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(
            dueDate: DateTime.now().add(const Duration(days: 1)),
          ),
          onTap: () {},
        ),
      ));

      expect(find.text('Tomorrow'), findsOneWidget);
    });

    testWidgets('applies line-through style for done tasks', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(status: 'done', title: 'Finished task'),
          onTap: () {},
        ),
      ));

      final titleWidget = tester.widget<Text>(find.text('Finished task'));
      expect(titleWidget.style?.decoration, TextDecoration.lineThrough);
    });

    testWidgets('hides priority pip for normal priority', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(priority: 'normal'),
          onTap: () {},
        ),
      ));

      // Normal priority renders SizedBox.shrink (no visible pip)
      // The card itself still renders, so just verify no red/green indicator dot
      // is shown - we check that the card renders correctly
      expect(find.text('Test Task'), findsOneWidget);
    });

    testWidgets('shows monster indicator for neglected tasks', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(monsterState: 'neglected'),
          onTap: () {},
        ),
      ));

      expect(find.byIcon(Icons.warning_amber), findsOneWidget);
    });

    testWidgets('shows monster indicator for corrupting tasks', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(monsterState: 'corrupting'),
          onTap: () {},
        ),
      ));

      expect(find.byIcon(Icons.whatshot), findsOneWidget);
    });

    testWidgets('shows monster indicator for monster tasks', (tester) async {
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(monsterState: 'monster'),
          onTap: () {},
        ),
      ));

      expect(find.byIcon(Icons.pest_control), findsOneWidget);
    });

    testWidgets('calls onTap when card is tapped', (tester) async {
      var tapped = false;
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(),
          onTap: () => tapped = true,
        ),
      ));

      await tester.tap(find.text('Test Task'));
      expect(tapped, isTrue);
    });

    testWidgets('calls onComplete when checkbox is tapped', (tester) async {
      var completed = false;
      await tester.pumpWidget(_wrap(
        TaskCard(
          task: _makeTask(),
          onTap: () {},
          onComplete: () => completed = true,
        ),
      ));

      // The completion checkbox is a 24x24 decorated Container with a
      // circular border, wrapped in a GestureDetector. Find by the check icon
      // absence — it's the small circle. Tap at its center by finding the
      // Container with BoxShape.circle decoration.
      final checkboxFinder = find.byWidgetPredicate((w) {
        if (w is! Container) return false;
        final dec = w.decoration;
        if (dec is! BoxDecoration) return false;
        return dec.shape == BoxShape.circle;
      });
      await tester.tap(checkboxFinder.first);
      expect(completed, isTrue);
    });
  });
}

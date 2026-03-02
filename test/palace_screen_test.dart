import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindhause/app/theme.dart';
import 'package:mindhause/features/palace/presentation/palace_screen.dart';

void main() {
  group('PalaceScreen', () {
    Widget buildScreen({String room = 'foyer'}) {
      return ProviderScope(
        child: MaterialApp(
          theme: MindHauseTheme.lightTheme,
          home: PalaceScreen(initialRoom: room),
        ),
      );
    }

    testWidgets('displays Memory Palace title', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Memory Palace'), findsOneWidget);
    });

    testWidgets('displays The Palace in app bar', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('The Palace'), findsOneWidget);
    });

    testWidgets('displays room name in uppercase', (tester) async {
      await tester.pumpWidget(buildScreen(room: 'library'));
      await tester.pumpAndSettle();

      expect(find.text('Entering: LIBRARY'), findsOneWidget);
    });

    testWidgets('defaults to foyer room', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.text('Entering: FOYER'), findsOneWidget);
    });

    testWidgets('shows Godot not embedded message', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(
        find.text('Godot runtime not yet embedded'),
        findsOneWidget,
      );
    });

    testWidgets('shows castle icon', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.castle_outlined), findsOneWidget);
    });

    testWidgets('has back button', (tester) async {
      await tester.pumpWidget(buildScreen());
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    });
  });
}

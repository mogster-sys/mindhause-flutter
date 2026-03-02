import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindhause/app/theme.dart';

void main() {
  group('MindHauseTheme', () {
    group('priorityColor', () {
      test('returns red for high priority', () {
        expect(
          MindHauseTheme.priorityColor('high'),
          MindHauseTheme.priorityHigh,
        );
      });

      test('returns green for low priority', () {
        expect(
          MindHauseTheme.priorityColor('low'),
          MindHauseTheme.priorityLow,
        );
      });

      test('returns gold for normal priority', () {
        expect(
          MindHauseTheme.priorityColor('normal'),
          MindHauseTheme.priorityNormal,
        );
      });

      test('defaults to gold for unknown priority', () {
        expect(
          MindHauseTheme.priorityColor('unknown'),
          MindHauseTheme.priorityNormal,
        );
      });
    });

    group('roomIcon', () {
      test('returns correct icon for each room', () {
        expect(MindHauseTheme.roomIcon('foyer'), Icons.home);
        expect(MindHauseTheme.roomIcon('study'), Icons.work);
        expect(MindHauseTheme.roomIcon('library'), Icons.menu_book);
        expect(MindHauseTheme.roomIcon('kitchen'), Icons.kitchen);
        expect(MindHauseTheme.roomIcon('workshop'), Icons.build);
        expect(MindHauseTheme.roomIcon('garden'), Icons.park);
        expect(MindHauseTheme.roomIcon('bedroom'), Icons.bed);
        expect(MindHauseTheme.roomIcon('gymnasium'), Icons.fitness_center);
        expect(MindHauseTheme.roomIcon('treasury'), Icons.emoji_events);
        expect(MindHauseTheme.roomIcon('cellar'), Icons.inventory_2);
      });

      test('returns default icon for unknown room', () {
        expect(MindHauseTheme.roomIcon('unknown'), Icons.room);
      });
    });

    group('lightTheme', () {
      test('uses Material 3', () {
        expect(MindHauseTheme.lightTheme.useMaterial3, isTrue);
      });

      test('has marble scaffold background', () {
        expect(
          MindHauseTheme.lightTheme.scaffoldBackgroundColor,
          MindHauseTheme.marble,
        );
      });

      test('has light brightness', () {
        expect(
          MindHauseTheme.lightTheme.colorScheme.brightness,
          Brightness.light,
        );
      });
    });

    group('darkTheme', () {
      test('uses Material 3', () {
        expect(MindHauseTheme.darkTheme.useMaterial3, isTrue);
      });

      test('has dark brightness', () {
        expect(
          MindHauseTheme.darkTheme.colorScheme.brightness,
          Brightness.dark,
        );
      });
    });
  });
}

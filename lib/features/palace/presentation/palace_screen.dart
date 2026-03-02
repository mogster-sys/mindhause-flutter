import 'dart:io';

import 'package:flutter/material.dart';

import '../../../app/theme.dart';

/// Placeholder palace screen.
///
/// When the Godot runtime is embedded (via platform view), this will host
/// the 3D palace. For now it shows a launch-ready placeholder with the
/// room the user will spawn into.
class PalaceScreen extends StatelessWidget {
  final String initialRoom;

  const PalaceScreen({super.key, this.initialRoom = 'foyer'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Platform view integration point — uncomment when Godot AAR/XCFramework is embedded:
    // if (Platform.isAndroid) {
    //   return AndroidView(viewType: 'com.mindhause/godot_palace');
    // } else if (Platform.isIOS) {
    //   return UiKitView(viewType: 'com.mindhause/godot_palace');
    // }

    return Scaffold(
      backgroundColor: MindHauseTheme.inkDark,
      appBar: AppBar(
        title: const Text('The Palace'),
        backgroundColor: Colors.transparent,
        foregroundColor: MindHauseTheme.marble,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.castle_outlined,
              size: 80,
              color: MindHauseTheme.bronzeGold.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 24),
            Text(
              'Memory Palace',
              style: theme.textTheme.headlineMedium?.copyWith(
                color: MindHauseTheme.marble,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Entering: ${initialRoom.toUpperCase()}',
              style: theme.textTheme.bodyLarge?.copyWith(
                color: MindHauseTheme.marble.withValues(alpha: 0.6),
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 48),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: MindHauseTheme.bronzeGold.withValues(alpha: 0.3),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    'Godot runtime not yet embedded',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: MindHauseTheme.marble.withValues(alpha: 0.5),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _platformHint,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: MindHauseTheme.marble.withValues(alpha: 0.35),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String get _platformHint {
    if (Platform.isAndroid) {
      return 'Export Godot as AAR → place in android/app/libs/\nSee INTEGRATION_GUIDE.md Section B';
    } else if (Platform.isIOS) {
      return 'Export Godot as XCFramework → place in ios/Frameworks/\nSee INTEGRATION_GUIDE.md Section B';
    }
    return 'Desktop embedding requires Godot export templates.\nSee INTEGRATION_GUIDE.md for details.';
  }
}

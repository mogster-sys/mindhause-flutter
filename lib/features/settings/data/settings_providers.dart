import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/database/providers.dart';

/// Watch a specific setting by key
final settingProvider = StreamProvider.family((ref, String key) {
  return ref.watch(settingsDaoProvider).watchSetting(key);
});

/// Watch all rooms
final roomsProvider = StreamProvider((ref) {
  return ref.watch(settingsDaoProvider).watchAllRooms();
});

/// Convenience providers for common settings
final monstersEnabledProvider = StreamProvider((ref) {
  return ref.watch(settingsDaoProvider).watchSetting('monsters_enabled').map(
        (v) => v == 'true',
      );
});

final focusDurationProvider = StreamProvider((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('focus_duration')
      .map((v) => int.tryParse(v ?? '25') ?? 25);
});

/// Theme mode (light / dark / system)
final themeModeProvider = StreamProvider<ThemeMode>((ref) {
  return ref.watch(settingsDaoProvider).watchSetting('theme_mode').map((v) {
    switch (v) {
      case 'dark':
        return ThemeMode.dark;
      case 'light':
        return ThemeMode.light;
      default:
        return ThemeMode.system;
    }
  });
});

/// Active palace aesthetic theme ID
final palaceThemeProvider = StreamProvider<String>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('theme')
      .map((v) => v ?? 'greco_roman');
});

/// Monster sensitivity setting
final monsterSensitivityProvider = StreamProvider<String>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('monster_sensitivity')
      .map((v) => v ?? 'normal');
});

/// Audio enabled (master toggle — shared with Godot AudioManager)
final audioEnabledProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('audio_enabled')
      .map((v) => v != 'false'); // default true
});

/// Music volume (0.0–1.0, shared with Godot AudioManager)
final musicVolumeProvider = StreamProvider<double>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('music_volume')
      .map((v) => double.tryParse(v ?? '0.4') ?? 0.4);
});

/// SFX volume (0.0–1.0, shared with Godot AudioManager)
final sfxVolumeProvider = StreamProvider<double>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('sfx_volume')
      .map((v) => double.tryParse(v ?? '0.8') ?? 0.8);
});

/// Notifications enabled
final notificationsEnabledProvider = StreamProvider<bool>((ref) {
  return ref
      .watch(settingsDaoProvider)
      .watchSetting('notifications_enabled')
      .map((v) => v == 'true');
});

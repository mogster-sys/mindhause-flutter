import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../data/settings_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Appearance section
          _SectionHeader(title: 'Appearance'),
          const _ThemeModeSelector(),
          const SizedBox(height: 12),
          const _PalaceThemeGrid(),
          const Divider(height: 32),

          // Palace section
          _SectionHeader(title: 'Palace'),
          const _ToggleSetting(
            icon: Icons.pest_control,
            title: 'Monster Tasks',
            subtitle: 'Neglected tasks evolve into monsters',
            settingKey: 'monsters_enabled',
          ),
          const _ToggleSetting(
            icon: Icons.directions_run,
            title: 'Monster Chasing',
            subtitle: 'Monsters actively pursue you in the palace',
            settingKey: 'monster_chasing',
          ),
          const _MonsterSensitivity(),
          const Divider(height: 32),

          // Cat section
          _SectionHeader(title: 'Cat Companion'),
          const _ToggleSetting(
            icon: Icons.pets,
            title: 'Cat Enabled',
            subtitle: 'Friendly cat guides you to important tasks',
            settingKey: 'cat_enabled',
          ),
          const Divider(height: 32),

          // Audio section
          _SectionHeader(title: 'Audio'),
          const _ToggleSetting(
            icon: Icons.volume_up,
            title: 'Palace Audio',
            subtitle: 'Ambient music and sound effects in the palace',
            settingKey: 'audio_enabled',
            defaultTrue: true,
          ),
          const _VolumeSlider(
            icon: Icons.music_note,
            title: 'Music Volume',
            settingKey: 'music_volume',
            defaultValue: 0.4,
          ),
          const _VolumeSlider(
            icon: Icons.surround_sound,
            title: 'SFX Volume',
            settingKey: 'sfx_volume',
            defaultValue: 0.8,
          ),
          const Divider(height: 32),

          // Notifications section
          _SectionHeader(title: 'Notifications'),
          const _ToggleSetting(
            icon: Icons.notifications_active,
            title: 'Due Date Reminders',
            subtitle: 'Get notified at 9 AM when tasks are due',
            settingKey: 'notifications_enabled',
          ),
          const Divider(height: 32),

          // Focus section
          _SectionHeader(title: 'Focus'),
          const _FocusDurationSetting(),
          const Divider(height: 32),

          // Rooms section
          _SectionHeader(title: 'Rooms'),
          const _RoomsList(),
          const SizedBox(height: 32),

          // About
          _SectionHeader(title: 'About'),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('MindHause',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text('A memory palace for your mind.',
                      style: TextStyle(color: MindHauseTheme.slateBlue)),
                  const SizedBox(height: 8),
                  Text('Version 0.1.0',
                      style: TextStyle(
                          fontSize: 12, color: MindHauseTheme.warmStone)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, top: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: MindHauseTheme.terracotta,
          letterSpacing: 0.5,
        ),
      ),
    );
  }
}

class _ToggleSetting extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String settingKey;
  final bool defaultTrue;

  const _ToggleSetting({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.settingKey,
    this.defaultTrue = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingAsync = ref.watch(settingProvider(settingKey));
    final isEnabled = defaultTrue
        ? settingAsync.valueOrNull != 'false'
        : settingAsync.valueOrNull == 'true';

    return Card(
      child: SwitchListTile(
        secondary: Icon(icon, color: MindHauseTheme.terracotta),
        title: Text(title),
        subtitle: Text(subtitle,
            style: TextStyle(fontSize: 12, color: MindHauseTheme.slateBlue)),
        value: isEnabled,
        onChanged: (v) {
          ref
              .read(settingsDaoProvider)
              .setSetting(settingKey, v.toString());
        },
      ),
    );
  }
}

class _MonsterSensitivity extends ConsumerWidget {
  const _MonsterSensitivity();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sensitivityAsync = ref.watch(settingProvider('monster_sensitivity'));
    final sensitivity = sensitivityAsync.valueOrNull ?? 'normal';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.speed, color: MindHauseTheme.terracotta),
                const SizedBox(width: 12),
                const Text('Monster Sensitivity',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Text('How quickly neglected tasks become monsters',
                style: TextStyle(
                    fontSize: 12, color: MindHauseTheme.slateBlue)),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'gentle', label: Text('Gentle')),
                ButtonSegment(value: 'normal', label: Text('Normal')),
                ButtonSegment(value: 'strict', label: Text('Strict')),
              ],
              selected: {sensitivity},
              onSelectionChanged: (v) {
                ref
                    .read(settingsDaoProvider)
                    .setSetting('monster_sensitivity', v.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _FocusDurationSetting extends ConsumerWidget {
  const _FocusDurationSetting();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final durationAsync = ref.watch(focusDurationProvider);
    final duration = durationAsync.valueOrNull ?? 25;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.timer, color: MindHauseTheme.terracotta),
                const SizedBox(width: 12),
                const Text('Focus Duration',
                    style: TextStyle(fontSize: 16)),
                const Spacer(),
                Text('$duration min',
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ],
            ),
            const SizedBox(height: 12),
            Slider(
              value: duration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              label: '$duration min',
              onChanged: (v) {
                ref.read(settingsDaoProvider).setSetting(
                    'focus_duration', v.round().toString());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _RoomsList extends ConsumerWidget {
  const _RoomsList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final roomsAsync = ref.watch(roomsProvider);

    return roomsAsync.when(
      data: (rooms) {
        final floors = <String, List<Room>>{};
        for (final room in rooms) {
          final floor = room.floor;
          floors.putIfAbsent(floor, () => []).add(room);
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final entry in _sortedFloors(floors)) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8, bottom: 4),
                child: Text(
                  _floorLabel(entry.key),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: MindHauseTheme.slateBlue,
                  ),
                ),
              ),
              ...entry.value.map((room) => Card(
                    child: ListTile(
                      leading: Icon(MindHauseTheme.roomIcon(room.name),
                          color: MindHauseTheme.terracotta),
                      title: Text(room.displayName),
                      subtitle: room.description.isNotEmpty
                          ? Text(room.description,
                              style: TextStyle(
                                  fontSize: 12,
                                  color: MindHauseTheme.slateBlue))
                          : null,
                      trailing: room.isCustom
                          ? IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  size: 20),
                              onPressed: () => ref
                                  .read(settingsDaoProvider)
                                  .deleteCustomRoom(room.id),
                            )
                          : null,
                    ),
                  )),
            ],
            const SizedBox(height: 8),
            Center(
              child: OutlinedButton.icon(
                onPressed: () => _showAddRoom(context, ref),
                icon: const Icon(Icons.add),
                label: const Text('Add Custom Room'),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  List<MapEntry<String, List<Room>>> _sortedFloors(
      Map<String, List<Room>> floors) {
    const order = ['upper', 'ground', 'basement'];
    final entries = floors.entries.toList();
    entries.sort((a, b) {
      final ai = order.indexOf(a.key);
      final bi = order.indexOf(b.key);
      return (ai == -1 ? 99 : ai).compareTo(bi == -1 ? 99 : bi);
    });
    return entries;
  }

  void _showAddRoom(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedFloor = 'ground';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Add Custom Room'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                textCapitalization: TextCapitalization.words,
                decoration: const InputDecoration(
                  labelText: 'Room Name',
                  hintText: 'e.g. Music Room, Greenhouse',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: descController,
                textCapitalization: TextCapitalization.sentences,
                decoration: const InputDecoration(
                  labelText: 'Description (optional)',
                  hintText: 'What belongs in this room?',
                ),
              ),
              const SizedBox(height: 16),
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(value: 'upper', label: Text('Upper')),
                  ButtonSegment(value: 'ground', label: Text('Ground')),
                  ButtonSegment(value: 'basement', label: Text('Basement')),
                ],
                selected: {selectedFloor},
                onSelectionChanged: (v) =>
                    setDialogState(() => selectedFloor = v.first),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () async {
                final name = nameController.text.trim();
                if (name.isEmpty) return;
                final id = const Uuid().v4();
                await ref.read(settingsDaoProvider).createRoom(
                      RoomsCompanion.insert(
                        id: id,
                        name: name.toLowerCase().replaceAll(' ', '_'),
                        displayName: name,
                        description: Value(descController.text.trim()),
                        floor: Value(selectedFloor),
                        isCustom: const Value(true),
                        sortOrder: const Value(99),
                      ),
                    );
                if (ctx.mounted) Navigator.pop(ctx);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }

  String _floorLabel(String floor) {
    switch (floor) {
      case 'upper':
        return 'UPPER FLOOR';
      case 'ground':
        return 'GROUND FLOOR';
      case 'basement':
        return 'BASEMENT';
      default:
        return floor.toUpperCase();
    }
  }
}

class _ThemeModeSelector extends ConsumerWidget {
  const _ThemeModeSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final modeAsync = ref.watch(settingProvider('theme_mode'));
    final mode = modeAsync.valueOrNull ?? 'system';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.brightness_6, color: MindHauseTheme.terracotta),
                const SizedBox(width: 12),
                const Text('App Theme',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 12),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(
                    value: 'light',
                    icon: Icon(Icons.light_mode, size: 16),
                    label: Text('Light')),
                ButtonSegment(
                    value: 'system',
                    icon: Icon(Icons.settings_brightness, size: 16),
                    label: Text('System')),
                ButtonSegment(
                    value: 'dark',
                    icon: Icon(Icons.dark_mode, size: 16),
                    label: Text('Dark')),
              ],
              selected: {mode},
              onSelectionChanged: (v) {
                ref
                    .read(settingsDaoProvider)
                    .setSetting('theme_mode', v.first);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PalaceThemeGrid extends ConsumerWidget {
  const _PalaceThemeGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeAsync = ref.watch(palaceThemeProvider);
    final activeId = activeAsync.valueOrNull ?? 'greco_roman';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.palette, color: MindHauseTheme.terracotta),
                const SizedBox(width: 12),
                const Text('Palace Theme',
                    style: TextStyle(fontSize: 16)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Visual style for your memory palace',
                style: TextStyle(
                    fontSize: 12, color: MindHauseTheme.slateBlue)),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: PalaceTheme.all.length,
              itemBuilder: (_, i) {
                final theme = PalaceTheme.all[i];
                final isSelected = theme.id == activeId;
                return _PalaceThemeCard(
                  theme: theme,
                  isSelected: isSelected,
                  onTap: () {
                    ref
                        .read(settingsDaoProvider)
                        .setSetting('theme', theme.id);
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _PalaceThemeCard extends StatelessWidget {
  final PalaceTheme theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _PalaceThemeCard({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? theme.accentColor : Colors.transparent,
            width: 2.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Room preview — wall color with floor strip and accent bar
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    // Wall
                    Container(color: theme.wallColor),
                    // Floor strip at bottom
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 18,
                      child: Container(color: theme.floorColor),
                    ),
                    // Accent strip (like a wainscoting line)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 18,
                      height: 3,
                      child: Container(color: theme.accentColor),
                    ),
                    // Palette dots centered
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: theme.palette
                            .map((c) => Container(
                                  width: 14,
                                  height: 14,
                                  margin:
                                      const EdgeInsets.symmetric(horizontal: 2),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: c,
                                    border: Border.all(
                                      color: Colors.white.withValues(alpha: 0.6),
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                    // Selected check
                    if (isSelected)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: theme.accentColor,
                          ),
                          child: const Icon(Icons.check,
                              size: 14, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
              // Info bar
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                color: Theme.of(context).cardTheme.color ??
                    Theme.of(context).colorScheme.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      theme.name,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected ? theme.accentColor : null,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      theme.atmosphere,
                      style: TextStyle(
                          fontSize: 9, color: MindHauseTheme.slateBlue),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _VolumeSlider extends ConsumerWidget {
  final IconData icon;
  final String title;
  final String settingKey;
  final double defaultValue;

  const _VolumeSlider({
    required this.icon,
    required this.title,
    required this.settingKey,
    required this.defaultValue,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final volumeAsync = ref.watch(settingProvider(settingKey));
    final volume =
        double.tryParse(volumeAsync.valueOrNull ?? '') ?? defaultValue;
    final percent = (volume * 100).round();

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            Icon(icon, color: MindHauseTheme.terracotta),
            const SizedBox(width: 12),
            Text(title, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Expanded(
              child: Slider(
                value: volume,
                min: 0.0,
                max: 1.0,
                divisions: 20,
                label: '$percent%',
                onChanged: (v) {
                  ref
                      .read(settingsDaoProvider)
                      .setSetting(settingKey, v.toStringAsFixed(2));
                },
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '$percent%',
                style: const TextStyle(
                    fontSize: 13, fontWeight: FontWeight.w600),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

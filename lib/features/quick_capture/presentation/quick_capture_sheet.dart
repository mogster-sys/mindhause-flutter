import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../../settings/data/settings_providers.dart';

/// A minimal bottom sheet for fast task/note entry.
/// Items land in the Foyer as post-it objects until the user sorts them.
class QuickCaptureSheet extends ConsumerStatefulWidget {
  const QuickCaptureSheet({super.key});

  @override
  ConsumerState<QuickCaptureSheet> createState() => _QuickCaptureSheetState();
}

class _QuickCaptureSheetState extends ConsumerState<QuickCaptureSheet> {
  final _controller = TextEditingController();
  String _type = 'task';
  String _priority = 'normal';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: MindHauseTheme.warmStone,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Quick Capture',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600, color: MindHauseTheme.inkDark),
          ),
          const SizedBox(height: 12),

          // Title input
          TextField(
            controller: _controller,
            autofocus: true,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _capture(),
            decoration: const InputDecoration(
              hintText: 'What\'s on your mind?',
              prefixIcon: Icon(Icons.bolt),
            ),
          ),
          const SizedBox(height: 12),

          // Type + priority row
          Row(
            children: [
              // Type toggle
              SegmentedButton<String>(
                segments: const [
                  ButtonSegment(
                      value: 'task',
                      icon: Icon(Icons.task_alt, size: 16),
                      label: Text('Task')),
                  ButtonSegment(
                      value: 'note',
                      icon: Icon(Icons.note, size: 16),
                      label: Text('Note')),
                ],
                selected: {_type},
                onSelectionChanged: (v) => setState(() => _type = v.first),
                style: ButtonStyle(
                  visualDensity: VisualDensity.compact,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const SizedBox(width: 12),
              // Priority (only for tasks)
              if (_type == 'task') ...[
                ...['low', 'normal', 'high'].map((p) => Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: GestureDetector(
                        onTap: () => setState(() => _priority = p),
                        child: Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _priority == p
                                ? MindHauseTheme.priorityColor(p)
                                : MindHauseTheme.priorityColor(p)
                                    .withValues(alpha: 0.2),
                            border: Border.all(
                              color: MindHauseTheme.priorityColor(p),
                              width: _priority == p ? 2 : 1,
                            ),
                          ),
                        ),
                      ),
                    )),
              ],
              const Spacer(),
              // Submit
              FilledButton(
                onPressed: _capture,
                child: const Text('Capture'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _capture() async {
    final title = _controller.text.trim();
    if (title.isEmpty) return;

    final now = DateTime.now();
    final captureRoom =
        ref.read(settingProvider('quick_capture_room')).valueOrNull ?? 'foyer';
    await ref.read(itemsDaoProvider).createItem(ItemsCompanion.insert(
          id: const Uuid().v4(),
          title: title,
          type: _type,
          priority: Value(_type == 'task' ? _priority : 'normal'),
          status: const Value('todo'),
          createdAt: now,
          updatedAt: now,
          lastInteraction: now,
          room: Value(captureRoom),
          objectType: Value(_type == 'note' ? 'book' : 'post_it'),
        ));

    if (mounted) Navigator.of(context).pop();
  }
}

/// Convenience function to show the quick capture sheet from anywhere
void showQuickCapture(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => const QuickCaptureSheet(),
  );
}

import 'dart:async';

import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme.dart';
import '../../../shared/database/app_database.dart';
import '../../../shared/database/providers.dart';
import '../../settings/data/settings_providers.dart';

/// A focus timer screen. Optionally linked to a specific task.
class FocusTimerScreen extends ConsumerStatefulWidget {
  final String? taskId;
  final String? taskTitle;

  const FocusTimerScreen({super.key, this.taskId, this.taskTitle});

  @override
  ConsumerState<FocusTimerScreen> createState() => _FocusTimerScreenState();
}

class _FocusTimerScreenState extends ConsumerState<FocusTimerScreen> {
  Timer? _timer;
  int _remainingSeconds = 0;
  int _totalSeconds = 0;
  bool _running = false;
  bool _finished = false;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _start(int durationMinutes) {
    _timer?.cancel();
    setState(() {
      _totalSeconds = durationMinutes * 60;
      _remainingSeconds = _totalSeconds;
      _running = true;
      _finished = false;
    });
    _startTicking();
  }

  void _pause() {
    _timer?.cancel();
    setState(() => _running = false);
  }

  void _resume() {
    setState(() => _running = true);
    _startTicking();
  }

  void _reset() {
    _timer?.cancel();
    setState(() {
      _remainingSeconds = 0;
      _totalSeconds = 0;
      _running = false;
      _finished = false;
    });
  }

  void _startTicking() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (_remainingSeconds <= 1) {
        _timer?.cancel();
        setState(() {
          _remainingSeconds = 0;
          _running = false;
          _finished = true;
        });
        HapticFeedback.heavyImpact();
        _onSessionComplete();
      } else {
        setState(() => _remainingSeconds--);
      }
    });
  }

  Future<void> _onSessionComplete() async {
    if (!mounted) return;
    // Update the linked task's lastInteraction
    if (widget.taskId != null) {
      final now = DateTime.now();
      await ref.read(itemsDaoProvider).updateItem(ItemsCompanion(
            id: Value(widget.taskId!),
            lastInteraction: Value(now),
            updatedAt: Value(now),
          ));
    }
  }

  String _formatTime(int totalSeconds) {
    final m = totalSeconds ~/ 60;
    final s = totalSeconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final durationAsync = ref.watch(focusDurationProvider);
    final duration = durationAsync.valueOrNull ?? 25;
    final progress =
        _totalSeconds > 0 ? 1.0 - (_remainingSeconds / _totalSeconds) : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Focus'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Task name if linked
              if (widget.taskTitle != null) ...[
                Text(
                  widget.taskTitle!,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MindHauseTheme.slateBlue,
                      ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 24),
              ],

              // Timer ring
              SizedBox(
                width: 240,
                height: 240,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 240,
                      height: 240,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor:
                            MindHauseTheme.warmStone.withValues(alpha: 0.3),
                        color: _finished
                            ? MindHauseTheme.deepOlive
                            : MindHauseTheme.terracotta,
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          _totalSeconds > 0
                              ? _formatTime(_remainingSeconds)
                              : _formatTime(duration * 60),
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 2,
                          ),
                        ),
                        if (_finished)
                          Text(
                            'Done!',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: MindHauseTheme.deepOlive,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),

              // Controls
              if (!_running && !_finished && _totalSeconds == 0)
                // Not started — show start button
                FilledButton.icon(
                  onPressed: () => _start(duration),
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Start ($duration min)'),
                  style: FilledButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                )
              else if (_running)
                // Running — show pause
                OutlinedButton.icon(
                  onPressed: _pause,
                  icon: const Icon(Icons.pause),
                  label: const Text('Pause'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                  ),
                )
              else if (!_running && _totalSeconds > 0 && !_finished)
                // Paused — show resume and reset
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: _reset,
                      icon: const Icon(Icons.stop),
                      label: const Text('Reset'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _resume,
                      icon: const Icon(Icons.play_arrow),
                      label: const Text('Resume'),
                    ),
                  ],
                )
              else if (_finished)
                // Finished — show reset
                Column(
                  children: [
                    FilledButton.icon(
                      onPressed: () => _start(duration),
                      icon: const Icon(Icons.replay),
                      label: const Text('Again'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Done'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

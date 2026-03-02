import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final godotBridgeProvider = Provider<GodotBridgeService>((ref) {
  return GodotBridgeService();
});

/// Bridge between Flutter and the embedded Godot palace runtime.
///
/// Uses a MethodChannel to send commands to Godot (enter palace, set DB path)
/// and receive callbacks (exit palace, task selected).
class GodotBridgeService {
  static const _channel = MethodChannel('com.mindhause/godot');

  VoidCallback? _onExitPalace;
  void Function(String taskId)? _onTaskSelected;

  GodotBridgeService() {
    _channel.setMethodCallHandler(_handleGodotCall);
  }

  /// Tell Godot where the shared SQLite database lives.
  Future<void> setDatabasePath(String path) async {
    await _channel.invokeMethod('setDatabasePath', {'path': path});
  }

  /// Launch the palace view, optionally starting in a specific room.
  Future<void> enterPalace({String room = 'foyer'}) async {
    await _channel.invokeMethod('enterPalace', {'room': room});
  }

  /// Tell Godot to pause rendering (when switching to organiser).
  Future<void> pausePalace() async {
    await _channel.invokeMethod('pausePalace');
  }

  /// Tell Godot to resume rendering.
  Future<void> resumePalace() async {
    await _channel.invokeMethod('resumePalace');
  }

  /// Register callback for when user exits palace mode.
  void onExitPalace(VoidCallback callback) {
    _onExitPalace = callback;
  }

  /// Register callback for when user taps a task object in the palace.
  void onTaskSelected(void Function(String taskId) callback) {
    _onTaskSelected = callback;
  }

  Future<dynamic> _handleGodotCall(MethodCall call) async {
    switch (call.method) {
      case 'exitPalace':
        _onExitPalace?.call();
      case 'taskSelected':
        final taskId = call.arguments['taskId'] as String;
        _onTaskSelected?.call(taskId);
    }
  }
}

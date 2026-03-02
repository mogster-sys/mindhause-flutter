import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mindhause/shared/services/godot_bridge_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('GodotBridgeService', () {
    late GodotBridgeService bridge;
    late List<MethodCall> log;

    setUp(() {
      log = [];

      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.mindhause/godot'),
        (call) async {
          log.add(call);
          return null;
        },
      );

      bridge = GodotBridgeService();
    });

    tearDown(() {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('com.mindhause/godot'),
        null,
      );
    });

    test('enterPalace sends correct method and default room', () async {
      await bridge.enterPalace();

      expect(log, hasLength(1));
      expect(log.first.method, 'enterPalace');
      expect(log.first.arguments, {'room': 'foyer'});
    });

    test('enterPalace sends specified room', () async {
      await bridge.enterPalace(room: 'library');

      expect(log, hasLength(1));
      expect(log.first.arguments, {'room': 'library'});
    });

    test('pausePalace sends correct method', () async {
      await bridge.pausePalace();

      expect(log, hasLength(1));
      expect(log.first.method, 'pausePalace');
    });

    test('resumePalace sends correct method', () async {
      await bridge.resumePalace();

      expect(log, hasLength(1));
      expect(log.first.method, 'resumePalace');
    });

    test('setDatabasePath sends path argument', () async {
      await bridge.setDatabasePath('/data/mindhause.db');

      expect(log, hasLength(1));
      expect(log.first.method, 'setDatabasePath');
      expect(log.first.arguments, {'path': '/data/mindhause.db'});
    });

    test('onExitPalace callback fires when Godot sends exitPalace', () async {
      var exitCalled = false;
      bridge.onExitPalace(() => exitCalled = true);

      // Simulate Godot sending exitPalace back to Flutter
      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(const MethodCall('exitPalace'));

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'com.mindhause/godot',
        data,
        (ByteData? reply) {},
      );

      expect(exitCalled, isTrue);
    });

    test('onTaskSelected callback fires with task ID', () async {
      String? selectedId;
      bridge.onTaskSelected((id) => selectedId = id);

      final codec = const StandardMethodCodec();
      final data = codec.encodeMethodCall(
        const MethodCall('taskSelected', {'taskId': 'task-42'}),
      );

      await TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .handlePlatformMessage(
        'com.mindhause/godot',
        data,
        (ByteData? reply) {},
      );

      expect(selectedId, 'task-42');
    });
  });
}

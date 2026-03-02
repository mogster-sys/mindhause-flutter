import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;

import '../database/app_database.dart';

final notificationServiceProvider = Provider<NotificationService>((ref) {
  return NotificationService();
});

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    tz.initializeTimeZones();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      ),
    );

    _initialized = true;
  }

  /// Schedule a notification for a task's due date.
  /// Schedules at 9 AM on the due day if the due date has no specific time.
  Future<void> scheduleTaskDue(Item task) async {
    if (task.dueDate == null) return;
    await init();

    final dueDate = task.dueDate!;
    // Schedule for 9 AM on the due date
    final scheduledDate = DateTime(dueDate.year, dueDate.month, dueDate.day, 9);

    // Don't schedule if already in the past
    if (scheduledDate.isBefore(DateTime.now())) return;

    final tzDate = tz.TZDateTime.from(scheduledDate, tz.local);

    await _plugin.zonedSchedule(
      task.id.hashCode,
      'Task Due: ${task.title}',
      task.description.isNotEmpty ? task.description : 'This task is due today.',
      tzDate,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'task_due',
          'Task Reminders',
          channelDescription: 'Notifications for task due dates',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  /// Cancel a notification for a specific task
  Future<void> cancelTaskNotification(String taskId) async {
    await init();
    await _plugin.cancel(taskId.hashCode);
  }

  /// Cancel all notifications
  Future<void> cancelAll() async {
    await init();
    await _plugin.cancelAll();
  }

  /// Re-schedule notifications for all tasks with due dates.
  /// Call after app launch or after bulk edits.
  Future<void> rescheduleAll(List<Item> tasks) async {
    await init();
    await _plugin.cancelAll();
    for (final task in tasks) {
      if (task.status != 'done' && task.status != 'archived') {
        await scheduleTaskDue(task);
      }
    }
  }
}

import 'package:coach_workout/core/services/supabase_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotificationService {
  LocalNotificationService._();

  static final LocalNotificationService instance = LocalNotificationService._();

  static const List<int> reminderHours = [8, 12, 15, 18];
  static const int _notificationBaseId = 88000;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> init() async {
    if (_initialized) return;

    await _configureTimezone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
        macOS: iosSettings,
      ),
    );

    await requestPermissions();
    _initialized = true;
  }

  Future<void> requestPermissions() async {
    final androidImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidImplementation?.requestNotificationsPermission();

    final iosImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    await iosImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    final macImplementation = _plugin
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >();
    await macImplementation?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> syncTodayWorkoutReminders() async {
    await init();

    final now = tz.TZDateTime.now(tz.local);
    await _cancelReminderIdsForRange(now, 30);
    await _cancelReminderIdsForDate(now.subtract(const Duration(days: 1)));

    try {
      final status = await SupabaseService().getMyCalendarTrainingStatus();
      final plannedKeys = status['planned'] ?? <String>{};
      final completedKeys = status['completed'] ?? <String>{};

      for (final plannedKey in plannedKeys) {
        if (completedKeys.contains(plannedKey)) continue;

        final plannedDate = _dateFromKey(plannedKey);
        if (plannedDate == null) continue;

        final plannedDay = tz.TZDateTime(
          tz.local,
          plannedDate.year,
          plannedDate.month,
          plannedDate.day,
        );
        final daysFromNow = plannedDay.difference(
          tz.TZDateTime(tz.local, now.year, now.month, now.day),
        );

        if (daysFromNow.isNegative || daysFromNow.inDays > 30) continue;

        for (final hour in reminderHours) {
          final scheduledTime = tz.TZDateTime(
            tz.local,
            plannedDate.year,
            plannedDate.month,
            plannedDate.day,
            hour,
          );

          if (!scheduledTime.isAfter(now)) continue;

          await _plugin.zonedSchedule(
            _notificationId(scheduledTime, hour),
            'Đến giờ tập luyện rồi 💪',
            'Hôm nay bạn có lịch tập. Hoàn thành bài tập để giữ streak nhé!',
            scheduledTime,
            _notificationDetails(),
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            uiLocalNotificationDateInterpretation:
                UILocalNotificationDateInterpretation.absoluteTime,
            payload: 'workout_reminder_$plannedKey',
          );
        }
      }
    } catch (e) {
      debugPrint('Không thể đồng bộ thông báo lịch tập: $e');
    }
  }

  Future<void> cancelTodayWorkoutReminders() async {
    await init();
    await _cancelReminderIdsForDate(tz.TZDateTime.now(tz.local));
  }

  Future<void> _configureTimezone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Ho_Chi_Minh'));
  }

  Future<void> _cancelReminderIdsForDate(DateTime date) async {
    for (final hour in reminderHours) {
      await _plugin.cancel(_notificationId(date, hour));
    }
  }

  Future<void> _cancelReminderIdsForRange(DateTime startDate, int days) async {
    for (var index = 0; index <= days; index++) {
      await _cancelReminderIdsForDate(startDate.add(Duration(days: index)));
    }
  }

  NotificationDetails _notificationDetails() {
    const androidDetails = AndroidNotificationDetails(
      'workout_schedule_reminders',
      'Nhắc lịch tập luyện',
      channelDescription: 'Thông báo nhắc tập theo lịch của người dùng',
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    return const NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
      macOS: iosDetails,
    );
  }

  int _notificationId(DateTime date, int hour) {
    final local = date.toLocal();
    return _notificationBaseId +
        (local.year % 100) * 1000000 +
        local.month * 10000 +
        local.day * 100 +
        hour;
  }

  DateTime? _dateFromKey(String key) {
    final parts = key.split('-');
    if (parts.length != 3) return null;

    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;

    return DateTime(year, month, day);
  }
}

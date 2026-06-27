import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:child_monitor_app/core/di/service_locator.dart';
import 'package:child_monitor_app/core/managers/daily_quote_manager.dart';
import 'package:child_monitor_app/features/notification/domain/entities/notification_entity.dart';
import 'package:child_monitor_app/features/notification/domain/repos/notification_repo.dart';

class LocalNotificationService {
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  factory LocalNotificationService() {
    return _instance;
  }

  LocalNotificationService._internal();

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// Initialize local notifications
  Future<void> initializeNotifications() async {
    if (_isInitialized) return;

    final androidImpl = _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();

    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInitSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: iosInitSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      settings: initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification click logic
      },
    );
    _isInitialized = true;
  }

  /// Show immediate notification and save it to storage
  Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? type,
    String? quote,
  }) async {
    await initializeNotifications();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'instant_channel',
      'Instant Notifications',
      channelDescription: 'Notifications for achievements and security alerts',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: notificationDetails,
      );

      // Save to local storage
      final entity = NotificationEntity(
        title: title,
        body: body,
        date: DateTime.now().toString(),
        highlighted: true,
        type: type,
        quote: quote,
      );
      await getIt<NotificationRepository>().saveNotification(entity);
    } catch (e) {
      debugPrint('Error showing/saving instant notification: $e');
    }
  }

  /// Schedule a notification and save it to storage
  Future<void> scheduleLocalNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
    String? type,
    String? quote,
  }) async {
    await initializeNotifications();

    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'scheduled_channel',
      'Scheduled Notifications',
      channelDescription: 'Daily goals and reminders channel',
      importance: Importance.high,
      priority: Priority.high,
    );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: id,
        title: title,
        body: body,
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      );

      // Save to local storage (will be hidden until scheduledDate passes)
      final entity = NotificationEntity(
        title: title,
        body: body,
        date: scheduledDate.toString(),
        highlighted: false,
        type: type,
        quote: quote,
      );
      await getIt<NotificationRepository>().saveNotification(entity);
    } catch (e) {
      debugPrint('Error scheduling/saving notification: $e');
    }
  }

  /// Cancel all scheduled system alerts
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Cancel specific notification by ID
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }

  /// Main helper to schedule 7 days of daily content (quotes, reminders, tips) on app boot.
  /// Cleans future entries of these types in storage first to prevent repeats.
  Future<void> scheduleDailyNotifications() async {
    await initializeNotifications();
    final now = DateTime.now();

    // Clean up future scheduled notifications from the repository list first to prevent duplicates
    try {
      final listKey = 'local_notifications_history';
      final prefs = getIt<SharedPreferences>();
      final storedStrings = prefs.getStringList(listKey) ?? [];

      final updatedStrings = storedStrings.where((item) {
        final json = jsonDecode(item) as Map<String, dynamic>;
        final dateStr = json['date'] as String;
        final date = DateTime.tryParse(dateStr);
        final type = json['type'] as String?;
        if (date == null) return true;
        // Keep past notifications or non-scheduled types
        if (date.isBefore(now)) return true;
        if (type != 'daily_quote' && type != 'reminder' && type != 'tip') return true;
        return false; // Remove future daily quotes, reminders, or tips
      }).toList();

      await prefs.setStringList(listKey, updatedStrings);
    } catch (e) {
      debugPrint('Error cleaning up future notifications: $e');
    }

    // 1. Schedule Daily Quotes for the next 7 days (e.g. at 2:00 PM / 14:00)
    for (int i = 0; i < 7; i++) {
      final scheduledDate = DateTime(now.year, now.month, now.day, 14, 0).add(Duration(days: i));
      if (i == 0 && scheduledDate.isBefore(now)) continue;

      final quote = DailyQuoteManager.getRandomQuote();
      await scheduleLocalNotification(
        id: 100 + i,
        title: 'daily_quote_title',
        body: '"$quote"',
        scheduledDate: scheduledDate,
        type: 'daily_quote',
        quote: quote,
      );
    }

    // 2. Schedule Daily Activity Plan Reminders for the next 7 days (e.g. at 10:00 AM)
    for (int i = 0; i < 7; i++) {
      final scheduledDate = DateTime(now.year, now.month, now.day, 10, 0).add(Duration(days: i));
      if (i == 0 && scheduledDate.isBefore(now)) continue;

      await scheduleLocalNotification(
        id: 200 + i,
        title: 'plan_reminder_title',
        body: 'plan_reminder_body',
        scheduledDate: scheduledDate,
        type: 'reminder',
      );
    }

    // 3. Schedule Weekly Developmental/Parenting Tip for the next 4 weeks (e.g. every Sunday at 9:00 AM)
    // Find next Sunday
    var nextSunday = DateTime(now.year, now.month, now.day, 9, 0);
    while (nextSunday.weekday != DateTime.sunday) {
      nextSunday = nextSunday.add(const Duration(days: 1));
    }

    final parentingTips = [
      "Tip of the week: Encourage free play for 30 minutes today to boost creativity.",
      "Tip of the week: Maintain a consistent daily routine to enhance your child's sense of security.",
      "Tip of the week: Use positive reinforcement instead of focusing only on mistakes.",
      "Tip of the week: Read a short story together tonight to stimulate vocabulary and language skills."
    ];

    for (int i = 0; i < 4; i++) {
      final scheduledDate = nextSunday.add(Duration(days: i * 7));
      if (scheduledDate.isBefore(now)) continue;

      final tip = parentingTips[i % parentingTips.length];
      await scheduleLocalNotification(
        id: 300 + i,
        title: 'weekly_tip_title',
        body: tip,
        scheduledDate: scheduledDate,
        type: 'reminder',
      );
    }
  }
}

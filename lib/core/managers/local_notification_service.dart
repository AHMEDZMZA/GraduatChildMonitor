import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:child_monitor_app/core/managers/daily_quote_manager.dart';
import 'package:child_monitor_app/core/managers/dynamic_notification_manager.dart';
import 'package:child_monitor_app/core/navigation/routing_manager.dart';

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

    // Request Android 13+ notification permission via the plugin itself
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
        final payload = response.payload;
        if (payload != null && payload.isNotEmpty) {
          RoutingManager.navigatorKey.currentState?.pushNamed(payload);
        }
      },
    );
    _isInitialized = true;
  }

  /// Schedule daily quote notification at specific time
  Future<void> scheduleDailyQuoteNotification({
    int hour = 9, // Default 9 AM
    int minute = 0,
  }) async {
    await initializeNotifications();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_quote_channel',
          'Daily Quote Notifications',
          channelDescription: 'Send daily motivational quotes',
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

    // Schedule for today first; if already past, schedule for tomorrow
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id: 0,
        title: getGreetingTitle(),
        body: getNotificationPreview(),
        scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
        notificationDetails: notificationDetails,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('Notification scheduling error: $e');
    }
  }

  /// Schedule 14 dynamic notifications (7 days, 9AM and 9PM)
  Future<void> scheduleDynamic12HourNotifications() async {
    await initializeNotifications();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'dynamic_channel',
          'Dynamic Notifications',
          channelDescription: 'Send dynamic 12-hour updates',
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

    final now = DateTime.now();

    // Cancel previously scheduled dynamic notifications before scheduling new ones
    // We assume dynamic notifications use IDs from 1000 to 1020
    for (int i = 1000; i <= 1020; i++) {
      await cancelNotification(i);
    }

    // Schedule for 7 days
    for (int i = 0; i < 7; i++) {
      // 9 AM Notification
      var morningDate = DateTime(now.year, now.month, now.day, 9, 0).add(Duration(days: i));
      if (morningDate.isAfter(now)) {
        final morningContent = DynamicNotificationManager.getRandomMorningNotification();
        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            id: i * 2 + 1000,
            title: morningContent.title,
            body: morningContent.body,
            scheduledDate: tz.TZDateTime.from(morningDate, tz.local),
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: morningContent.payloadRoute,
          );
        } catch (e) {
          debugPrint('Morning schedule error: $e');
        }
      }

      // 9 PM Notification
      var eveningDate = DateTime(now.year, now.month, now.day, 21, 0).add(Duration(days: i));
      if (eveningDate.isAfter(now)) {
        final eveningContent = DynamicNotificationManager.getRandomEveningNotification();
        try {
          await _flutterLocalNotificationsPlugin.zonedSchedule(
            id: i * 2 + 1001,
            title: eveningContent.title,
            body: eveningContent.body,
            scheduledDate: tz.TZDateTime.from(eveningDate, tz.local),
            notificationDetails: notificationDetails,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            payload: eveningContent.payloadRoute,
          );
        } catch (e) {
          debugPrint('Evening schedule error: $e');
        }
      }
    }
  }

  /// Show immediate notification with daily quote
  Future<void> showDailyQuoteNotification() async {
    await initializeNotifications();

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'daily_quote_channel',
          'Daily Quote Notifications',
          channelDescription: 'Send daily motivational quotes',
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

    await _flutterLocalNotificationsPlugin.show(
      id: 1,
      title: getGreetingTitle(),
      body: getNotificationPreview(),
      notificationDetails: notificationDetails,
    );
  }

  /// Get greeting title based on time
  String getGreetingTitle() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning! 🌅";
    } else if (hour < 17) {
      return "Good Afternoon! ☀️";
    } else {
      return "Good Evening! 🌙";
    }
  }

  /// Get notification preview from DailyQuoteManager
  String getNotificationPreview() {
    return DailyQuoteManager.getRandomQuote();
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// Cancel specific notification
  Future<void> cancelNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id: id);
  }
}


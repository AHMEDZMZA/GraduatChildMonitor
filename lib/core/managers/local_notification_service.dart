import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:child_monitor_app/core/managers/daily_quote_manager.dart';

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

    await _flutterLocalNotificationsPlugin.initialize(settings: initSettings);
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

    // Schedule for today first if not yet passed
    final now = DateTime.now();
    var scheduledDate = DateTime(now.year, now.month, now.day, hour, minute);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    // Schedule periodic daily notification using updated API
    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id: 0,
      title: getGreetingTitle(),
      body: getNotificationPreview(),
      scheduledDate: tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails: notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
    );
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

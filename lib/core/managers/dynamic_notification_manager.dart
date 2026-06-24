import 'dart:math';
import 'package:child_monitor_app/core/navigation/app_routes.dart';

class DynamicNotificationContent {
  final String title;
  final String body;
  final String payloadRoute;

  const DynamicNotificationContent({
    required this.title,
    required this.body,
    required this.payloadRoute,
  });
}

class DynamicNotificationManager {
  static final Random _random = Random();

  static const List<DynamicNotificationContent> _morningNotifications = [
    DynamicNotificationContent(
      title: "Good Morning! 🌅",
      body: "Have you checked today's plan for your child? Start the day right!",
      payloadRoute: AppRoutes.todayPlan,
    ),
    DynamicNotificationContent(
      title: "Morning Routine ☀️",
      body: "A new day brings new opportunities. Tap to see today's suggested activities.",
      payloadRoute: AppRoutes.todayPlan,
    ),
    DynamicNotificationContent(
      title: "Parenting Tip of the Day 💡",
      body: "Discover new ways to connect with your child. Check out our latest articles.",
      payloadRoute: AppRoutes.articles,
    ),
    DynamicNotificationContent(
      title: "Rise and Shine! 🌟",
      body: "Interactive tests can make morning learning fun. Try one today!",
      payloadRoute: AppRoutes.selectTest,
    ),
  ];

  static const List<DynamicNotificationContent> _eveningNotifications = [
    DynamicNotificationContent(
      title: "Good Evening! 🌙",
      body: "Did your child finish today's activities? Tap to log their progress.",
      payloadRoute: AppRoutes.todayPlan,
    ),
    DynamicNotificationContent(
      title: "Daily Review 📊",
      body: "Take a moment to review your child's weekly progress.",
      payloadRoute: AppRoutes.progressTracker,
    ),
    DynamicNotificationContent(
      title: "Wind Down 📖",
      body: "Read a quick parenting article to prepare for tomorrow.",
      payloadRoute: AppRoutes.articles,
    ),
    DynamicNotificationContent(
      title: "End of Day Check-in ✅",
      body: "Update your child's profile or add any notes from today's interactions.",
      payloadRoute: AppRoutes.childrenProfiles,
    ),
  ];

  /// Get a random morning notification
  static DynamicNotificationContent getRandomMorningNotification() {
    return _morningNotifications[_random.nextInt(_morningNotifications.length)];
  }

  /// Get a random evening notification
  static DynamicNotificationContent getRandomEveningNotification() {
    return _eveningNotifications[_random.nextInt(_eveningNotifications.length)];
  }

  /// Helper to get generic payload for testing
  static DynamicNotificationContent getTestNotification() {
    return _morningNotifications.first;
  }
}

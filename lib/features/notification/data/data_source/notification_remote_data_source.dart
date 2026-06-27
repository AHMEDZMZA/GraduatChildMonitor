import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/notification_entity.dart';
import '../model/notification_model.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> clearAllNotifications();
  Future<void> deleteNotification(int index);
  Future<void> cancelAllNotifications();
  Future<void> saveNotification(NotificationEntity notification);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final SharedPreferences sharedPreferences;
  static const String _notificationsKey = 'local_notifications_history';

  NotificationRemoteDataSourceImpl({required this.sharedPreferences}) {
    _initMockHistory();
  }

  /// Populate some realistic past notifications if the history is empty
  void _initMockHistory() {
    if (!sharedPreferences.containsKey(_notificationsKey)) {
      final now = DateTime.now();

      final mockList = [
        NotificationModel(
          title: 'Welcome to Child Monitor! 🎉',
          body: 'We are excited to help you track your child\'s developmental milestones and plans.',
          date: now.subtract(const Duration(days: 3)).toString(),
          highlighted: false,
          type: 'reminder',
        ),
        NotificationModel(
          title: 'Daily Quote',
          body: '"Your presence is your greatest gift to your child."',
          date: now.subtract(const Duration(days: 2)).toString(),
          highlighted: true,
          type: 'daily_quote',
          quote: 'Your presence is your greatest gift to your child.',
        ),
        NotificationModel(
          title: 'Today\'s Plan Reminder 🧩',
          body: 'Time for learning! Check today\'s plan for your child\'s activities.',
          date: now.subtract(const Duration(days: 1)).toString(),
          highlighted: false,
          type: 'reminder',
        ),
      ];

      final jsonList = mockList.map((n) => jsonEncode(n.toJson())).toList();
      sharedPreferences.setStringList(_notificationsKey, jsonList);
    }
  }

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    final list = sharedPreferences.getStringList(_notificationsKey) ?? [];

    final allNotifications = list.map((item) {
      final json = jsonDecode(item) as Map<String, dynamic>;
      return NotificationModel.fromJson(json);
    }).toList();

    // Filter to only show notifications that should have been sent (in the past or exactly now)
    final now = DateTime.now();
    final visibleNotifications = allNotifications.where((n) {
      final parsedDate = DateTime.tryParse(n.date);
      if (parsedDate == null) return true;
      return parsedDate.isBefore(now) || parsedDate.isAtSameMomentAs(now);
    }).toList();

    // Sort by date descending (newest first)
    visibleNotifications.sort((a, b) {
      final dateA = DateTime.tryParse(a.date) ?? DateTime.now();
      final dateB = DateTime.tryParse(b.date) ?? DateTime.now();
      return dateB.compareTo(dateA);
    });

    return visibleNotifications;
  }

  @override
  Future<void> saveNotification(NotificationEntity notification) async {
    final list = sharedPreferences.getStringList(_notificationsKey) ?? [];

    final model = NotificationModel(
      title: notification.title,
      body: notification.body,
      date: notification.date,
      highlighted: notification.highlighted,
      type: notification.type,
      quote: notification.quote,
    );

    list.add(jsonEncode(model.toJson()));
    await sharedPreferences.setStringList(_notificationsKey, list);
  }

  @override
  Future<void> clearAllNotifications() async {
    await sharedPreferences.remove(_notificationsKey);
  }

  @override
  Future<void> deleteNotification(int index) async {
    final list = sharedPreferences.getStringList(_notificationsKey) ?? [];
    final allNotifications = list.map((item) {
      final json = jsonDecode(item) as Map<String, dynamic>;
      return NotificationModel.fromJson(json);
    }).toList();

    // Retrieve the visible list in the same order as getNotifications()
    final visibleList = await getNotifications();
    if (index >= 0 && index < visibleList.length) {
      final itemToDelete = visibleList[index];

      // Find the index of itemToDelete in allNotifications
      final allIndex = allNotifications.indexWhere((n) =>
          n.title == itemToDelete.title &&
          n.date == itemToDelete.date &&
          n.body == itemToDelete.body);

      if (allIndex != -1) {
        allNotifications.removeAt(allIndex);
        final updatedJsonList = allNotifications
            .map((n) => jsonEncode(n.toJson()))
            .toList();
        await sharedPreferences.setStringList(_notificationsKey, updatedJsonList);
      }
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    // This will be handled directly in LocalNotificationService,
    // but we can leave it as a no-op or clear schedule.
  }
}

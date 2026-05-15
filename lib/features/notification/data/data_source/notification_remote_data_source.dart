import '../model/notification_item_model.dart';
import '../../domain/entities/notification_entity.dart';
import '../../../../core/helpers/notification_helper.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> getNotifications();
  Future<void> clearAllNotifications();
  Future<void> deleteNotification(int index);
  Future<void> cancelAllNotifications();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  // Simulating a backend storage with a local list
  final List<NotificationEntity> _localNotifications =
      notifications
          .map(
            (e) => NotificationEntity(
              title: e.title,
              date: e.date,
              highlighted: e.highlighted,
            ),
          )
          .toList();

  @override
  Future<List<NotificationEntity>> getNotifications() async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    return _localNotifications;
  }

  @override
  Future<void> clearAllNotifications() async {
    await Future.delayed(const Duration(milliseconds: 500));
    _localNotifications.clear();
  }

  @override
  Future<void> deleteNotification(int index) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (index >= 0 && index < _localNotifications.length) {
      _localNotifications.removeAt(index);
    }
  }

  @override
  Future<void> cancelAllNotifications() async {
    // This cancels local system notifications via the helper
    await NotificationHelper.cancelAllNotifications();
  }
}

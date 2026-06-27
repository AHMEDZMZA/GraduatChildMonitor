import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<Either<Failure, List<NotificationEntity>>> getNotifications();
  Future<Either<Failure, void>> clearAllNotifications();
  Future<Either<Failure, void>> deleteNotification(int index);
  Future<Either<Failure, void>> cancelAllNotifications();
  Future<Either<Failure, String>> getDailyQuote();
  Future<Either<Failure, List<NotificationEntity>>> getNotificationsWithQuote();
  Future<Either<Failure, void>> saveNotification(NotificationEntity notification);
}

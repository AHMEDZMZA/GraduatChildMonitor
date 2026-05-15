import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../../../../core/managers/daily_quote_manager.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/repos/notification_repo.dart';
import '../data_source/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remoteDataSource;

  NotificationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotifications() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      return Right(notifications);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> clearAllNotifications() async {
    try {
      await remoteDataSource.clearAllNotifications();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteNotification(int index) async {
    try {
      await remoteDataSource.deleteNotification(index);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> cancelAllNotifications() async {
    try {
      await remoteDataSource.cancelAllNotifications();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getDailyQuote() async {
    try {
      final quote = await DailyQuoteManager.getDailyQuote();
      return Right(quote);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<NotificationEntity>>> getNotificationsWithQuote() async {
    try {
      final notifications = await remoteDataSource.getNotifications();
      final dailyQuote = await DailyQuoteManager.getDailyQuote();
      
      // Add daily quote as the first notification
      final quoteNotification = NotificationEntity(
        title: 'Daily Quote',
        date: DateTime.now().toString(),
        highlighted: true,
        type: 'daily_quote',
        quote: dailyQuote,
      );
      
      return Right([quoteNotification, ...notifications]);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
}

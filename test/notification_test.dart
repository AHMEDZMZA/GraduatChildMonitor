import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:child_monitor_app/core/managers/daily_quote_manager.dart';
import 'package:child_monitor_app/features/notification/data/data_source/notification_remote_data_source.dart';
import 'package:child_monitor_app/features/notification/data/repos/notification_repo_impl.dart';
import 'package:child_monitor_app/features/notification/domain/entities/notification_entity.dart';
import 'package:child_monitor_app/features/notification/domain/repos/notification_repo.dart';
import 'package:dartz/dartz.dart';

void main() {
  group('DailyQuoteManager', () {
    test('getRandomQuote returns non-empty string', () {
      final quote = DailyQuoteManager.getRandomQuote();
      expect(quote, isNotEmpty);
    });

    test('getAllQuotes returns expected list', () {
      final all = DailyQuoteManager.getAllQuotes();
      expect(all.length, greaterThanOrEqualTo(50));
      expect(all.first, isNotEmpty);
    });

    test('getDailyQuote returns non-empty string', () async {
      SharedPreferences.setMockInitialValues({});
      final quote = await DailyQuoteManager.getDailyQuote();
      expect(quote, isNotEmpty);
    });
  });

  group('NotificationRemoteDataSourceImpl', () {
    test('getNotifications returns list of items', () async {
      final dataSource = NotificationRemoteDataSourceImpl();
      final notifications = await dataSource.getNotifications();
      expect(notifications, isNotEmpty);
      for (final n in notifications) {
        expect(n.title, isNotEmpty);
        expect(n.date, isNotEmpty);
      }
    });

    test('clearAllNotifications empties the list', () async {
      final dataSource = NotificationRemoteDataSourceImpl();
      await dataSource.clearAllNotifications();
      final notifications = await dataSource.getNotifications();
      expect(notifications, isEmpty);
    });

    test('deleteNotification removes last item', () async {
      final ds = NotificationRemoteDataSourceImpl();
      final before = await ds.getNotifications();
      final initialLength = before.length;
      expect(initialLength, greaterThanOrEqualTo(5));
      final lastTitle = before.last.title;
      await ds.deleteNotification(initialLength - 1);
      final after = await ds.getNotifications();
      expect(after.length, equals(initialLength - 1));
      expect(after.every((n) => n.title != lastTitle), isTrue);
    });
  });

  group('NotificationRepositoryImpl', () {
    late NotificationRepository repository;
    late NotificationRemoteDataSource dataSource;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      dataSource = NotificationRemoteDataSourceImpl();
      repository = NotificationRepositoryImpl(remoteDataSource: dataSource);
    });

    test('getNotificationsWithQuote returns list with daily quote', () async {
      final result = await repository.getNotificationsWithQuote();
      expect(result, isA<Right<dynamic, List<NotificationEntity>>>());

      final notifications = result.getOrElse(() => []);
      expect(notifications, isNotEmpty);
      expect(notifications.first.type, equals('daily_quote'));
      expect(notifications.first.quote, isNotEmpty);
    });

    test('getDailyQuote returns non-empty string', () async {
      final result = await repository.getDailyQuote();
      expect(result, isA<Right<dynamic, String>>());

      final quote = result.getOrElse(() => '');
      expect(quote, isNotEmpty);
    });

    test('getNotifications returns raw list', () async {
      final result = await repository.getNotifications();
      expect(result, isA<Right<dynamic, List<NotificationEntity>>>());

      final notifications = result.getOrElse(() => []);
      expect(notifications, isNotEmpty);
    });

    test('getNotifications does not include daily quote', () async {
      final result = await repository.getNotifications();
      expect(result, isA<Right<dynamic, List<NotificationEntity>>>());
      result.fold(
        (_) {},
        (notifications) {
          expect(notifications.every((n) => n.type != 'daily_quote'), isTrue,
              reason: 'getNotifications should return raw list without daily quote');
        },
      );
    });
  });
}

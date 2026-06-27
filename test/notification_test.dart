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
    late SharedPreferences prefs;
    late NotificationRemoteDataSourceImpl dataSource;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = NotificationRemoteDataSourceImpl(sharedPreferences: prefs);
    });

    test('getNotifications returns list of items', () async {
      final notifications = await dataSource.getNotifications();
      expect(notifications, isNotEmpty);
      for (final n in notifications) {
        expect(n.title, isNotEmpty);
        expect(n.date, isNotEmpty);
      }
    });

    test('clearAllNotifications empties the list', () async {
      await dataSource.clearAllNotifications();
      final notifications = await dataSource.getNotifications();
      expect(notifications, isEmpty);
    });

    test('deleteNotification removes last item', () async {
      final before = await dataSource.getNotifications();
      final initialLength = before.length;
      expect(initialLength, greaterThanOrEqualTo(3));
      final lastTitle = before.last.title;
      await dataSource.deleteNotification(initialLength - 1);
      final after = await dataSource.getNotifications();
      expect(after.length, equals(initialLength - 1));
      expect(after.every((n) => n.title != lastTitle), isTrue);
    });
  });

  group('NotificationRepositoryImpl', () {
    late NotificationRepository repository;
    late NotificationRemoteDataSource dataSource;
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      dataSource = NotificationRemoteDataSourceImpl(sharedPreferences: prefs);
      repository = NotificationRepositoryImpl(remoteDataSource: dataSource);
    });

    test('getNotificationsWithQuote returns list with daily quote', () async {
      final result = await repository.getNotificationsWithQuote();
      expect(result, isA<Right<dynamic, List<NotificationEntity>>>());

      final notifications = result.getOrElse(() => []);
      expect(notifications, isNotEmpty);
      // Because we pre-populate and check if today's quote is there,
      // getNotificationsWithQuote will insert today's quote if not present
      expect(notifications.any((n) => n.type == 'daily_quote'), isTrue);
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
  });
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repos/notification_repo.dart';
import '../state/notification_state.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationCubit extends Cubit<NotificationState> {
  final NotificationRepository repository;

  NotificationCubit({required this.repository}) : super(NotificationInitial());

  Future<void> getNotifications() async {
    emit(NotificationLoading());
    final result = await repository.getNotificationsWithQuote();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (notifications) => emit(NotificationLoaded(notifications)),
    );
  }

  Future<void> getDailyQuote() async {
    final result = await repository.getDailyQuote();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (quote) {
        final quoteNotification = NotificationEntity(
          title: 'Daily Quote',
          date: DateTime.now().toString(),
          highlighted: true,
          type: 'daily_quote',
          quote: quote,
        );
        
        final currentState = state;
        if (currentState is NotificationLoaded) {
          // Replace existing daily quote or add new one
          final notifications = List<NotificationEntity>.from(currentState.notifications);
          final quoteIndex = notifications.indexWhere((n) => n.type == 'daily_quote');
          
          if (quoteIndex >= 0) {
            notifications[quoteIndex] = quoteNotification;
          } else {
            notifications.insert(0, quoteNotification);
          }
          
          emit(NotificationLoaded(notifications));
        } else {
          emit(NotificationLoaded([quoteNotification]));
        }
      },
    );
  }

  Future<void> clearAll() async {
    final result = await repository.clearAllNotifications();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => emit(const NotificationLoaded([])),
    );
  }

  Future<void> deleteNotification(int index) async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      final updatedList = List<NotificationEntity>.from(currentState.notifications);
      final removedItem = updatedList.removeAt(index);
      
      // Optimistic update
      emit(NotificationLoaded(updatedList));

      final result = await repository.deleteNotification(index);
      result.fold(
        (failure) {
          // Revert on failure
          final revertedList = List<NotificationEntity>.from(updatedList);
          revertedList.insert(index, removedItem);
          emit(NotificationLoaded(revertedList));
          emit(NotificationError(failure.message));
        },
        (_) => null, // Keep the updated list
      );
    }
  }
}

  Future<void> cancelAllNotifications() async {
    final result = await repository.cancelAllNotifications();
    result.fold(
      (failure) => emit(NotificationError(failure.message)),
      (_) => null,
    );
  }
}

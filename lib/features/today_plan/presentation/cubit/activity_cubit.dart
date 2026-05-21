import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/today_plan/domain/usecases/activity_usecases.dart';
import 'package:child_monitor_app/features/today_plan/presentation/state/activity_state.dart';

class ActivityCubit extends Cubit<ActivityState> {
  final GetAllActivitiesUseCase getAllActivitiesUseCase;
  final GetActivitiesByTypeUseCase getActivitiesByTypeUseCase;
  final GetActivitiesForChildUseCase getActivitiesForChildUseCase;
  final GetActivityDetailUseCase getActivityDetailUseCase;
  final CompleteActivityUseCase completeActivityUseCase;
  final GetActivityStatsUseCase getActivityStatsUseCase;
  final GetRecommendedActivitiesUseCase getRecommendedActivitiesUseCase;

  ActivityCubit({
    required this.getAllActivitiesUseCase,
    required this.getActivitiesByTypeUseCase,
    required this.getActivitiesForChildUseCase,
    required this.getActivityDetailUseCase,
    required this.completeActivityUseCase,
    required this.getActivityStatsUseCase,
    required this.getRecommendedActivitiesUseCase,
  }) : super(const ActivityInitial());

  Future<void> getAllActivities() async {
    emit(const ActivityLoading());
    final result = await getAllActivitiesUseCase.call();

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(AllActivitiesLoaded(activities)),
    );
  }

  Future<void> getActivitiesByType(String type) async {
    emit(const ActivityLoading());
    final result = await getActivitiesByTypeUseCase.call(type);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(ActivitiesByTypeLoaded(activities, type)),
    );
  }

  Future<void> getActivitiesForChild(String childId) async {
    emit(const ActivityLoading());
    final result = await getActivitiesForChildUseCase.call(childId);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(ActivitiesForChildLoaded(activities)),
    );
  }

  Future<void> getActivityDetail(String activityId) async {
    emit(const ActivityLoading());
    final result = await getActivityDetailUseCase.call(activityId);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activity) => emit(ActivityDetailLoaded(activity)),
    );
  }

  Future<void> completeActivity(String childId, String activityId) async {
    emit(const ActivityLoading());
    final result = await completeActivityUseCase.call(childId, activityId);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (_) => emit(const ActivityCompleted()),
    );
  }

  Future<void> getActivityStats(String childId) async {
    emit(const ActivityLoading());
    final result = await getActivityStatsUseCase.call(childId);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (stats) => emit(ActivityStatsLoaded(stats)),
    );
  }

  Future<void> getRecommendedActivities(String childId) async {
    emit(const ActivityLoading());
    final result = await getRecommendedActivitiesUseCase.call(childId);

    result.fold(
      (failure) => emit(ActivityError(failure.message)),
      (activities) => emit(RecommendedActivitiesLoaded(activities)),
    );
  }
}

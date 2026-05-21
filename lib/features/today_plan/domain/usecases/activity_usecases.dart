import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/activity_entity.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/activity_repository.dart';

class GetAllActivitiesUseCase {
  final ActivityRepository repository;

  GetAllActivitiesUseCase({required this.repository});

  Future<Either<Failure, List<ActivityEntity>>> call() {
    return repository.getAllActivities();
  }
}

class GetActivitiesByTypeUseCase {
  final ActivityRepository repository;

  GetActivitiesByTypeUseCase({required this.repository});

  Future<Either<Failure, List<ActivityEntity>>> call(String type) {
    return repository.getActivitiesByType(type);
  }
}

class GetActivitiesForChildUseCase {
  final ActivityRepository repository;

  GetActivitiesForChildUseCase({required this.repository});

  Future<Either<Failure, List<ActivityEntity>>> call(String childId) {
    return repository.getActivitiesForChild(childId);
  }
}

class GetActivityDetailUseCase {
  final ActivityRepository repository;

  GetActivityDetailUseCase({required this.repository});

  Future<Either<Failure, ActivityEntity>> call(String activityId) {
    return repository.getActivityDetail(activityId);
  }
}

class CompleteActivityUseCase {
  final ActivityRepository repository;

  CompleteActivityUseCase({required this.repository});

  Future<Either<Failure, void>> call(String childId, String activityId) {
    return repository.completeActivity(childId, activityId);
  }
}

class GetActivityStatsUseCase {
  final ActivityRepository repository;

  GetActivityStatsUseCase({required this.repository});

  Future<Either<Failure, ActivityStatsEntity>> call(String childId) {
    return repository.getActivityStats(childId);
  }
}

class GetRecommendedActivitiesUseCase {
  final ActivityRepository repository;

  GetRecommendedActivitiesUseCase({required this.repository});

  Future<Either<Failure, List<ActivityEntity>>> call(String childId) {
    return repository.getRecommendedActivities(childId);
  }
}

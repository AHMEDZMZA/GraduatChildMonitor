import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/activity_entity.dart';

abstract class ActivityRepository {
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities();
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesByType(
    String type,
  );
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesForChild(
    String childId,
  );
  Future<Either<Failure, ActivityEntity>> getActivityDetail(String activityId);
  Future<Either<Failure, void>> completeActivity(
    String childId,
    String activityId,
  );
  Future<Either<Failure, ActivityStatsEntity>> getActivityStats(String childId);
  Future<Either<Failure, List<ActivityEntity>>> getRecommendedActivities(
    String childId,
  );
}

class ActivityStatsEntity {
  final int completedCount;
  final int totalActivities;
  final double completionPercentage;

  ActivityStatsEntity({
    required this.completedCount,
    required this.totalActivities,
    required this.completionPercentage,
  });
}

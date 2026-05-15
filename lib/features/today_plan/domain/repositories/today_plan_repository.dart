import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/today_plan_entity.dart';

abstract class TodayPlanRepository {
  Future<Either<Failure, (PlanEntity?, List<ActivityEntity>)>> getTodayPlan(
    String childId,
  );

  Future<Either<Failure, void>> completeTodayPlan(String childId, String date);

  Future<Either<Failure, List<PlanEntity>>> getPlanHistory(String childId);

  Future<Either<Failure, HomeDataEntity>> getHomeData(String? childId);
}

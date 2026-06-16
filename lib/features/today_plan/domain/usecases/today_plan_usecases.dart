import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/today_plan_entity.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/today_plan_repository.dart';

class GetTodayPlanUseCase {
  final TodayPlanRepository repository;

  GetTodayPlanUseCase({required this.repository});

  Future<Either<Failure, (PlanEntity?, List<ActivityEntity>)>> call(String childId) {
    return repository.getTodayPlan(childId);
  }
}

class CompleteTodayPlanUseCase {
  final TodayPlanRepository repository;

  CompleteTodayPlanUseCase({required this.repository});

  Future<Either<Failure, void>> call(String childId, String date) {
    return repository.completeTodayPlan(childId, date);
  }
}

class GetPlanHistoryUseCase {
  final TodayPlanRepository repository;

  GetPlanHistoryUseCase({required this.repository});

  Future<Either<Failure, List<PlanEntity>>> call(String childId) {
    return repository.getPlanHistory(childId);
  }
}

/// H-9: Renamed from GetHomeDataUseCase to avoid collision with the identically-named
/// use case in the home feature (home/domain/usecases/get_home_data_usecase.dart).
class GetTodayPlanHomeDataUseCase {
  final TodayPlanRepository repository;

  GetTodayPlanHomeDataUseCase({required this.repository});

  Future<Either<Failure, HomeDataEntity>> call(String? childId) {
    return repository.getHomeData(childId);
  }
}

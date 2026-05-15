import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/today_plan/domain/usecases/today_plan_usecases.dart';
import 'package:child_monitor_app/features/today_plan/presentation/state/today_plan_state.dart';

class TodayPlanCubit extends Cubit<TodayPlanState> {
  final GetTodayPlanUseCase getTodayPlanUseCase;
  final CompleteTodayPlanUseCase completeTodayPlanUseCase;
  final GetPlanHistoryUseCase getPlanHistoryUseCase;
  final GetHomeDataUseCase getHomeDataUseCase;

  TodayPlanCubit({
    required this.getTodayPlanUseCase,
    required this.completeTodayPlanUseCase,
    required this.getPlanHistoryUseCase,
    required this.getHomeDataUseCase,
  }) : super(const TodayPlanInitial());

  Future<void> getTodayPlan(String childId) async {
    emit(const TodayPlanLoading());
    final result = await getTodayPlanUseCase.call(childId);

    result.fold(
      (failure) => emit(TodayPlanError(failure.message)),
      (data) => emit(TodayPlanLoaded(data.$1, data.$2)),
    );
  }

  Future<void> completeTodayPlan(String childId, String date) async {
    emit(const TodayPlanLoading());
    final result = await completeTodayPlanUseCase.call(childId, date);

    result.fold(
      (failure) => emit(TodayPlanError(failure.message)),
      (_) => emit(const PlanCompleted()),
    );
  }

  Future<void> getPlanHistory(String childId) async {
    emit(const TodayPlanLoading());
    final result = await getPlanHistoryUseCase.call(childId);

    result.fold(
      (failure) => emit(TodayPlanError(failure.message)),
      (plans) => emit(PlanHistoryLoaded(plans)),
    );
  }

  Future<void> getHomeData(String? childId) async {
    emit(const TodayPlanLoading());
    final result = await getHomeDataUseCase.call(childId);

    result.fold(
      (failure) => emit(TodayPlanError(failure.message)),
      (homeData) => emit(HomeDataLoaded(homeData)),
    );
  }
}

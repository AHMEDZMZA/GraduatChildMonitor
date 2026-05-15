import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/today_plan_entity.dart';

abstract class TodayPlanState extends Equatable {
  const TodayPlanState();

  @override
  List<Object?> get props => [];
}

class TodayPlanInitial extends TodayPlanState {
  const TodayPlanInitial();
}

class TodayPlanLoading extends TodayPlanState {
  const TodayPlanLoading();
}

class TodayPlanLoaded extends TodayPlanState {
  final PlanEntity? plan;
  final List<ActivityEntity> activities;

  const TodayPlanLoaded(this.plan, this.activities);

  @override
  List<Object?> get props => [plan, activities];
}

class PlanHistoryLoaded extends TodayPlanState {
  final List<PlanEntity> plans;

  const PlanHistoryLoaded(this.plans);

  @override
  List<Object?> get props => [plans];
}

class HomeDataLoaded extends TodayPlanState {
  final HomeDataEntity homeData;

  const HomeDataLoaded(this.homeData);

  @override
  List<Object?> get props => [homeData];
}

class PlanCompleted extends TodayPlanState {
  const PlanCompleted();
}

class TodayPlanError extends TodayPlanState {
  final String message;

  const TodayPlanError(this.message);

  @override
  List<Object?> get props => [message];
}

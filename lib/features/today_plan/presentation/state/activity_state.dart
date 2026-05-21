import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/activity_entity.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/activity_repository.dart';

abstract class ActivityState extends Equatable {
  const ActivityState();

  @override
  List<Object?> get props => [];
}

class ActivityInitial extends ActivityState {
  const ActivityInitial();
}

class ActivityLoading extends ActivityState {
  const ActivityLoading();
}

class AllActivitiesLoaded extends ActivityState {
  final List<ActivityEntity> activities;

  const AllActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivitiesByTypeLoaded extends ActivityState {
  final List<ActivityEntity> activities;
  final String type;

  const ActivitiesByTypeLoaded(this.activities, this.type);

  @override
  List<Object?> get props => [activities, type];
}

class ActivitiesForChildLoaded extends ActivityState {
  final List<ActivityEntity> activities;

  const ActivitiesForChildLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivityDetailLoaded extends ActivityState {
  final ActivityEntity activity;

  const ActivityDetailLoaded(this.activity);

  @override
  List<Object?> get props => [activity];
}

class ActivityCompleted extends ActivityState {
  const ActivityCompleted();
}

class ActivityStatsLoaded extends ActivityState {
  final ActivityStatsEntity stats;

  const ActivityStatsLoaded(this.stats);

  @override
  List<Object?> get props => [stats];
}

class RecommendedActivitiesLoaded extends ActivityState {
  final List<ActivityEntity> activities;

  const RecommendedActivitiesLoaded(this.activities);

  @override
  List<Object?> get props => [activities];
}

class ActivityError extends ActivityState {
  final String message;

  const ActivityError(this.message);

  @override
  List<Object?> get props => [message];
}

import 'package:equatable/equatable.dart';

class ProgressEntity extends Equatable {
  final ProgressSummaryEntity summary;
  final TrendEntity trend;
  final ActivityStatsEntity activityStats;

  const ProgressEntity({
    required this.summary,
    required this.trend,
    required this.activityStats,
  });

  @override
  List<Object?> get props => [summary, trend, activityStats];
}

class ProgressSummaryEntity extends Equatable {
  final String summaryText;
  final double improvementPercentage;

  const ProgressSummaryEntity({
    required this.summaryText,
    required this.improvementPercentage,
  });

  @override
  List<Object?> get props => [summaryText, improvementPercentage];
}

class TrendEntity extends Equatable {
  final String status; // improving, declining, stable
  final List<double> trendData;

  const TrendEntity({
    required this.status,
    required this.trendData,
  });

  @override
  List<Object?> get props => [status, trendData];
}

class ActivityStatsEntity extends Equatable {
  final int completedActivities;
  final int totalActivities;
  final double completionPercentage;

  const ActivityStatsEntity({
    required this.completedActivities,
    required this.totalActivities,
    required this.completionPercentage,
  });

  @override
  List<Object?> get props => [completedActivities, totalActivities, completionPercentage];
}

import '../../domain/entities/progress_entity.dart';

class ProgressSummaryModel {
  final String summaryText;
  final double improvementPercentage;
  final int completedActivities;
  final int totalActivities;
  final double completionPercentage;

  ProgressSummaryModel({
    required this.summaryText,
    required this.improvementPercentage,
    required this.completedActivities,
    required this.totalActivities,
    required this.completionPercentage,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    final progressData = json['progress'];
    if (progressData is Map) {
      final completionRate = ((progressData['activity_completion_rate'] ?? 0.0) as num).toDouble();
      return ProgressSummaryModel(
        summaryText: (progressData['progress_summary'] ??
            progressData['summary_text'] ??
            progressData['summaryText'] ??
            progressData['message'] ??
            '') as String,
        improvementPercentage: ((progressData['assessment_improvement_percentage'] ??
            progressData['improvement_percentage'] ??
            progressData['improvementPercentage'] ??
            0) as num)
            .toDouble(),
        completedActivities: (progressData['completed_activities'] ?? 0) as int,
        totalActivities: (progressData['total_activities_attempted'] ?? progressData['total_activities'] ?? 0) as int,
        completionPercentage: (completionRate <= 1.0 ? completionRate * 100 : completionRate),
      );
    } else if (progressData is String) {
      return ProgressSummaryModel(
        summaryText: progressData,
        improvementPercentage: 0.0,
        completedActivities: 0,
        totalActivities: 0,
        completionPercentage: 0.0,
      );
    }

    final completionRate = ((json['activity_completion_rate'] ?? 0.0) as num).toDouble();
    return ProgressSummaryModel(
      summaryText: (json['progress_summary'] ??
          json['summary_text'] ??
          json['summaryText'] ??
          json['message'] ??
          '') as String,
      improvementPercentage: ((json['assessment_improvement_percentage'] ??
          json['improvement_percentage'] ??
          json['improvementPercentage'] ??
          0) as num)
          .toDouble(),
      completedActivities: (json['completed_activities'] ?? 0) as int,
      totalActivities: (json['total_activities_attempted'] ?? json['total_activities'] ?? 0) as int,
      completionPercentage: (completionRate <= 1.0 ? completionRate * 100 : completionRate),
    );
  }

  ProgressSummaryEntity toEntity() => ProgressSummaryEntity(
        summaryText: summaryText,
        improvementPercentage: improvementPercentage,
      );
}

class TrendModel {
  final String status;
  final List<double> trendData;

  TrendModel({
    required this.status,
    required this.trendData,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map ? json['data'] : json;
    final rawTrend = data['trend_data'] ?? data['trendData'] ?? data['assessments'];
    List<double> trendData = [];
    if (rawTrend is List) {
      trendData = rawTrend.map((e) {
        if (e is Map) {
          return ((e['totalScore'] ?? e['score'] ?? 0) as num).toDouble();
        }
        return (e as num).toDouble();
      }).toList();
    }
    return TrendModel(
      status: (data['trend'] ?? data['status'] ?? 'stable') as String,
      trendData: trendData,
    );
  }

  TrendEntity toEntity() => TrendEntity(
        status: status,
        trendData: trendData,
      );
}

class ActivityStatsModel {
  final int completedActivities;
  final int totalActivities;
  final double completionPercentage;

  ActivityStatsModel({
    required this.completedActivities,
    required this.totalActivities,
    required this.completionPercentage,
  });

  factory ActivityStatsModel.fromJson(Map<String, dynamic> json) {
    return ActivityStatsModel(
      completedActivities:
          ((json['completed_activities'] ?? json['completedActivities'] ?? json['completed_count'] ?? 0) as num)
              .toInt(),
      totalActivities:
          ((json['total_activities'] ?? json['totalActivities'] ?? json['total'] ?? 0) as num)
              .toInt(),
      completionPercentage:
          ((json['completion_percentage'] ?? json['completionPercentage'] ?? 0) as num)
              .toDouble(),
    );
  }

  ActivityStatsEntity toEntity() => ActivityStatsEntity(
        completedActivities: completedActivities,
        totalActivities: totalActivities,
        completionPercentage: completionPercentage,
      );
}

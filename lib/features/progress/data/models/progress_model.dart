import '../../domain/entities/progress_entity.dart';

class ProgressSummaryModel {
  final String summaryText;
  final double improvementPercentage;

  ProgressSummaryModel({
    required this.summaryText,
    required this.improvementPercentage,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) {
    return ProgressSummaryModel(
      summaryText: (json['summary_text'] ?? json['summaryText'] ?? '') as String,
      improvementPercentage:
          ((json['improvement_percentage'] ?? json['improvementPercentage'] ?? 0) as num)
              .toDouble(),
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
    final rawTrend = json['trend_data'] ?? json['trendData'];
    final trendData = rawTrend is List
        ? rawTrend.map((e) => (e as num).toDouble()).toList()
        : <double>[];
    return TrendModel(
      status: (json['status'] ?? 'stable') as String,
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

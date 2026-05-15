// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'progress_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProgressSummaryModel _$ProgressSummaryModelFromJson(
  Map<String, dynamic> json,
) => ProgressSummaryModel(
  summaryText: json['summary_text'] as String,
  improvementPercentage: (json['improvement_percentage'] as num).toDouble(),
);

Map<String, dynamic> _$ProgressSummaryModelToJson(
  ProgressSummaryModel instance,
) => <String, dynamic>{
  'summary_text': instance.summaryText,
  'improvement_percentage': instance.improvementPercentage,
};

TrendModel _$TrendModelFromJson(Map<String, dynamic> json) => TrendModel(
  status: json['status'] as String,
  trendData: (json['trend_data'] as List<dynamic>)
      .map((e) => (e as num).toDouble())
      .toList(),
);

Map<String, dynamic> _$TrendModelToJson(TrendModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'trend_data': instance.trendData,
    };

ActivityStatsModel _$ActivityStatsModelFromJson(Map<String, dynamic> json) =>
    ActivityStatsModel(
      completedActivities: (json['completed_activities'] as num).toInt(),
      totalActivities: (json['total_activities'] as num).toInt(),
      completionPercentage: (json['completion_percentage'] as num).toDouble(),
    );

Map<String, dynamic> _$ActivityStatsModelToJson(ActivityStatsModel instance) =>
    <String, dynamic>{
      'completed_activities': instance.completedActivities,
      'total_activities': instance.totalActivities,
      'completion_percentage': instance.completionPercentage,
    };

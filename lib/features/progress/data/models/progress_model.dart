import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/progress_entity.dart';

part 'progress_model.g.dart';

@JsonSerializable()
class ProgressSummaryModel {
  @JsonKey(name: 'summary_text')
  final String summaryText;
  @JsonKey(name: 'improvement_percentage')
  final double improvementPercentage;

  ProgressSummaryModel({
    required this.summaryText,
    required this.improvementPercentage,
  });

  factory ProgressSummaryModel.fromJson(Map<String, dynamic> json) =>
      _$ProgressSummaryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProgressSummaryModelToJson(this);

  ProgressSummaryEntity toEntity() => ProgressSummaryEntity(
        summaryText: summaryText,
        improvementPercentage: improvementPercentage,
      );
}

@JsonSerializable()
class TrendModel {
  final String status;
  @JsonKey(name: 'trend_data')
  final List<double> trendData;

  TrendModel({
    required this.status,
    required this.trendData,
  });

  factory TrendModel.fromJson(Map<String, dynamic> json) =>
      _$TrendModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrendModelToJson(this);

  TrendEntity toEntity() => TrendEntity(
        status: status,
        trendData: trendData,
      );
}

@JsonSerializable()
class ActivityStatsModel {
  @JsonKey(name: 'completed_activities')
  final int completedActivities;
  @JsonKey(name: 'total_activities')
  final int totalActivities;
  @JsonKey(name: 'completion_percentage')
  final double completionPercentage;

  ActivityStatsModel({
    required this.completedActivities,
    required this.totalActivities,
    required this.completionPercentage,
  });

  factory ActivityStatsModel.fromJson(Map<String, dynamic> json) =>
      _$ActivityStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$ActivityStatsModelToJson(this);

  ActivityStatsEntity toEntity() => ActivityStatsEntity(
        completedActivities: completedActivities,
        totalActivities: totalActivities,
        completionPercentage: completionPercentage,
      );
}

import 'package:dartz/dartz.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ApiClient apiClient;

  ProgressRepositoryImpl(this.apiClient);

  @override
  Future<Either<Failure, ProgressEntity>> getChildProgress(String childId) async {
    try {
      final response = await apiClient.getHomeProgress(childId);
      final responseData = response.data;
      final progressData = responseData.progress;

      return Right(
        ProgressEntity(
          summary: ProgressSummaryEntity(
            summaryText: progressData.progressSummary,
            improvementPercentage: progressData.assessmentImprovementPercentage,
          ),
          trend: TrendEntity(
            status: progressData.trend,
            trendData: const [],
          ),
          activityStats: ActivityStatsEntity(
            completedActivities: progressData.completedActivities,
            totalActivities: progressData.totalActivitiesAttempted,
            completionPercentage: progressData.activityCompletionRate,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

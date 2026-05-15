import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';
import '../models/progress_model.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProgressEntity>> getChildProgress(String childId) async {
    try {
      // Fetch each endpoint independently with fallbacks so one failure
      // doesn't break the entire screen.
      ProgressSummaryModel summary;
      try {
        summary = await remoteDataSource.getProgressSummary();
      } catch (_) {
        summary = ProgressSummaryModel(
          summaryText: 'No summary available yet.',
          improvementPercentage: 0.0,
        );
      }

      TrendModel trend;
      try {
        trend = await remoteDataSource.getTrend(childId);
      } catch (_) {
        trend = TrendModel(status: 'stable', trendData: []);
      }

      ActivityStatsModel stats;
      try {
        stats = await remoteDataSource.getActivityStats(childId);
      } catch (_) {
        stats = ActivityStatsModel(
          completedActivities: 0,
          totalActivities: 0,
          completionPercentage: 0.0,
        );
      }

      return Right(ProgressEntity(
        summary: summary.toEntity(),
        trend: trend.toEntity(),
        activityStats: stats.toEntity(),
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


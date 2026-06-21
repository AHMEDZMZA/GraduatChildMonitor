import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';
import '../models/progress_model.dart';

/// C-6 Fix: Repository now depends on [ProgressRemoteDataSource] — the proper
/// Retrofit-based data source for this feature. Previously it was calling
/// [ApiClient] directly, bypassing the data layer entirely.
class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, ProgressEntity>> getChildProgress(
    String childId,
  ) async {
    try {
      // Fetch summary (which includes stats) and trend concurrently.
      // Omit the conflicting activities/stats endpoint.
      final results = await Future.wait([
        remoteDataSource.getProgressSummary(childId),
        remoteDataSource.getTrend(childId),
      ]);

      final summary = results[0] as ProgressSummaryModel;
      final trend = results[1] as TrendModel;

      return Right(
        ProgressEntity(
          summary: summary.toEntity(),
          trend: trend.toEntity(),
          activityStats: ActivityStatsEntity(
            completedActivities: summary.completedActivities,
            totalActivities: summary.totalActivities,
            completionPercentage: summary.completionPercentage,
          ),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

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
      // Fetch all three data points concurrently.
      final results = await Future.wait([
        remoteDataSource.getProgressSummary(),
        remoteDataSource.getTrend(childId),
        remoteDataSource.getActivityStats(childId),
      ]);

      final summary = results[0] as dynamic;
      final trend = results[1] as dynamic;
      final stats = results[2] as dynamic;

      return Right(
        ProgressEntity(
          summary: summary.toEntity(),
          trend: trend.toEntity(),
          activityStats: stats.toEntity(),
        ),
      );
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

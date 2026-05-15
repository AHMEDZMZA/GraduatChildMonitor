import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/progress_entity.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/progress_remote_data_source.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final ProgressRemoteDataSource remoteDataSource;

  ProgressRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, ProgressEntity>> getChildProgress(String childId) async {
    try {
      final summary = await remoteDataSource.getProgressSummary();
      final trend = await remoteDataSource.getTrend(childId);
      final stats = await remoteDataSource.getActivityStats(childId);

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

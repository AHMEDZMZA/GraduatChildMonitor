import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/features/today_plan/data/datasources/activity_remote_data_source.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/activity_repository.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/activity_entity.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final ActivityRemoteDataSource remoteDataSource;

  ActivityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<ActivityEntity>>> getAllActivities() async {
    try {
      final response = await remoteDataSource.getAllActivities();
      final activities = response.activities
          .map(
            (item) => ActivityEntity(
              id: item.id,
              title: item.title,
              description: item.description,
              activityType: item.type,
              difficultyLevel: item.difficultyLevel ?? 'MEDIUM',
              durationMinutes: item.durationMinutes ?? 10,
              minAge: item.minAge ?? 0,
              maxAge: item.maxAge ?? 100,
              steps: item.steps ?? [],
              benefits: item.benefits,
              exampleActivities: item.exampleActivities,
              isActive: item.isActive ?? true,
            ),
          )
          .toList();
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesByType(
    String type,
  ) async {
    try {
      final response = await remoteDataSource.getActivitiesByType(type);
      final activities = response.activities
          .map(
            (item) => ActivityEntity(
              id: item.id,
              title: item.title,
              description: item.description,
              activityType: item.type,
              difficultyLevel: item.difficultyLevel ?? 'MEDIUM',
              durationMinutes: item.durationMinutes ?? 10,
              minAge: item.minAge ?? 0,
              maxAge: item.maxAge ?? 100,
              steps: item.steps ?? [],
              benefits: item.benefits,
              exampleActivities: item.exampleActivities,
              isActive: item.isActive ?? true,
            ),
          )
          .toList();
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getActivitiesForChild(
    String childId,
  ) async {
    try {
      final response = await remoteDataSource.getActivitiesForChild(childId);
      final activities = response.activities
          .map(
            (item) => ActivityEntity(
              id: item.id,
              title: item.title,
              description: item.description,
              activityType: item.type,
              difficultyLevel: item.difficultyLevel ?? 'MEDIUM',
              durationMinutes: item.durationMinutes ?? 10,
              minAge: item.minAge ?? 0,
              maxAge: item.maxAge ?? 100,
              steps: item.steps ?? [],
              benefits: item.benefits,
              exampleActivities: item.exampleActivities,
              isActive: item.isActive ?? true,
            ),
          )
          .toList();
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityEntity>> getActivityDetail(
    String activityId,
  ) async {
    try {
      final response = await remoteDataSource.getActivityDetail(activityId);
      final List<String> steps = [];
      if (response.instructions != null) {
        if (response.instructions is String) {
          steps.add(response.instructions as String);
        } else if (response.instructions is List) {
          steps.addAll(
            (response.instructions as List).map((e) => e.toString()).toList(),
          );
        }
      }
      final activity = ActivityEntity(
        id: response.id,
        title: response.title,
        description: response.description,
        activityType: response.type,
        difficultyLevel: 'MEDIUM',
        durationMinutes: response.duration ?? 10,
        minAge: 0,
        maxAge: 100,
        steps: steps,
        benefits: '',
        exampleActivities: null,
        isActive: true,
      );
      return Right(activity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeActivity(
    String childId,
    String activityId,
  ) async {
    try {
      await remoteDataSource.completeActivity(childId, activityId);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ActivityStatsEntity>> getActivityStats(
    String childId,
  ) async {
    try {
      final response = await remoteDataSource.getActivityStats(childId);
      final entity = ActivityStatsEntity(
        completedCount: response.completedCount,
        totalActivities: response.totalActivities,
        completionPercentage: response.completionPercentage,
      );
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ActivityEntity>>> getRecommendedActivities(
    String childId,
  ) async {
    try {
      final response = await remoteDataSource.getRecommendedActivities(childId);
      final activities = response.recommendedActivities
          .map(
            (item) => ActivityEntity(
              id: item.id,
              title: item.title,
              description: item.description,
              activityType: item.type,
              difficultyLevel: item.difficultyLevel ?? 'MEDIUM',
              durationMinutes: item.durationMinutes ?? 10,
              minAge: item.minAge ?? 0,
              maxAge: item.maxAge ?? 100,
              steps: item.steps ?? [],
              benefits: item.benefits,
              exampleActivities: item.exampleActivities,
              isActive: item.isActive ?? true,
            ),
          )
          .toList();
      return Right(activities);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/features/today_plan/data/datasources/today_plan_remote_data_source.dart';
import 'package:child_monitor_app/features/today_plan/domain/entities/today_plan_entity.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/today_plan_repository.dart';

class TodayPlanRepositoryImpl implements TodayPlanRepository {
  final TodayPlanRemoteDataSource remoteDataSource;

  TodayPlanRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, (PlanEntity?, List<ActivityEntity>)>> getTodayPlan(
    String childId,
  ) async {
    try {
      final response = await remoteDataSource.getTodayPlan(childId);

      final plan = response.plan != null
          ? PlanEntity(
              id: response.plan!.id,
              date: response.plan!.date,
              status: response.plan!.status,
              activities: response.plan!.activities
                  .map((a) => ActivityEntity(
                        id: a.id,
                        title: a.title,
                        description: a.description,
                        type: a.type,
                        completed: a.completed,
                      ))
                  .toList(),
            )
          : null;

      final activities = response.activities
          .map((a) => ActivityEntity(
                id: a.id,
                title: a.title,
                description: a.description,
                type: a.type,
                completed: a.completed,
              ))
          .toList();

      return Right((plan, activities));
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
  Future<Either<Failure, void>> completeTodayPlan(String childId, String date) async {
    try {
      await remoteDataSource.completeTodayPlan(childId, date);
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
  Future<Either<Failure, List<PlanEntity>>> getPlanHistory(String childId) async {
    try {
      final plans = await remoteDataSource.getPlanHistory(childId);
      return Right(
        plans
            .map((p) => PlanEntity(
                  id: p.id,
                  date: p.date,
                  status: p.status,
                  activities: p.activities
                      .map((a) => ActivityEntity(
                            id: a.id,
                            title: a.title,
                            description: a.description,
                            type: a.type,
                            completed: a.completed,
                          ))
                      .toList(),
                ))
            .toList(),
      );
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
  Future<Either<Failure, HomeDataEntity>> getHomeData(String? childId) async {
    try {
      final response = await remoteDataSource.getHomeData(childId);

      return Right(
        HomeDataEntity(
          userName: response.userName,
          greeting: response.greeting,
          children: response.children
              .map((c) => ChildEntity(
                    id: c.id,
                    name: c.name,
                    birthDate: c.birthDate,
                    gender: c.gender,
                    knowsCondition: c.knowsCondition,
                    diagnosedCondition: c.diagnosedCondition,
                  ))
              .toList(),
          todayPlan: response.todayPlan != null
              ? PlanEntity(
                  id: response.todayPlan!.id,
                  date: response.todayPlan!.date,
                  status: response.todayPlan!.status,
                  activities: response.todayPlan!.activities
                      .map((a) => ActivityEntity(
                            id: a.id,
                            title: a.title,
                            description: a.description,
                            type: a.type,
                            completed: a.completed,
                          ))
                      .toList(),
                )
              : null,
          todayActivities: response.todayActivities
              .map((a) => ActivityEntity(
                    id: a.id,
                    title: a.title,
                    description: a.description,
                    type: a.type,
                    completed: a.completed,
                  ))
              .toList(),
          progressStats: response.progressStats,
          articles: response.articles
              .map((a) => ArticleEntity(
                    id: a.id,
                    title: a.title,
                    content: a.content,
                    image: a.image,
                    category: a.category,
                    author: a.author,
                    publishedDate: a.publishedDate,
                    description: a.description,
                  ))
              .toList(),
        ),
      );
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

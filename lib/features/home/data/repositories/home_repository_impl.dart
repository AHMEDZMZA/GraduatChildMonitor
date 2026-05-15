import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/failures.dart';
import '../../domain/entities/home_entity.dart';
import '../../domain/repositories/home_repository.dart';
import '../datasources/home_remote_data_source.dart';

import '../../../profile/domain/entities/profile_entity.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, HomeEntity>> getHomeData(String? childId) async {
    try {
      final response = await remoteDataSource.getHomeData(childId);
      
      final entity = HomeEntity(
        userName: response.userName,
        greeting: response.greeting,
        selectedChildId: childId,
        children: response.children.map((c) => ChildProfileEntity(
          id: c.id,
          name: c.name,
          birthDate: c.birthDate,
          gender: c.gender,
          knowsCondition: c.knowsCondition,
          diagnosedCondition: c.diagnosedCondition,
        )).toList(),
      );

      return Right(entity);
    } on DioException catch (e) {
      if (e.response != null && e.response?.statusCode == 401) {
        return const Left(UnauthorizedFailure("Session expired. Please login again."));
      }
      return Left(ServerFailure(e.message ?? "Server error occurred"));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

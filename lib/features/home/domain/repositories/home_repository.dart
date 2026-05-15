import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../entities/home_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, HomeEntity>> getHomeData(String? childId);
}

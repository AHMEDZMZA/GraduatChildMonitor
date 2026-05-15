import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../entities/home_entity.dart';
import '../repositories/home_repository.dart';

class GetHomeDataUseCase {
  final HomeRepository repository;

  GetHomeDataUseCase(this.repository);

  Future<Either<Failure, HomeEntity>> call({String? childId}) {
    return repository.getHomeData(childId);
  }
}

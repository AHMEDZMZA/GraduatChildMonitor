import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../entities/progress_entity.dart';
import '../repositories/progress_repository.dart';

class GetChildProgressUseCase {
  final ProgressRepository repository;

  GetChildProgressUseCase(this.repository);

  Future<Either<Failure, ProgressEntity>> call(String childId) async {
    return await repository.getChildProgress(childId);
  }
}

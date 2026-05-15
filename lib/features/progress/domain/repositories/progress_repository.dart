import 'package:dartz/dartz.dart';
import '../../../../core/network/failures.dart';
import '../entities/progress_entity.dart';

abstract class ProgressRepository {
  Future<Either<Failure, ProgressEntity>> getChildProgress(String childId);
}

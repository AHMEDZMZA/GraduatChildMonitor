import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/tests/domain/entities/test_entity.dart';

abstract class TestsRepository {
  Future<Either<Failure, TestEntity>> getTestQuestions(String testType);

  Future<Either<Failure, TestResultEntity>> submitTest(
    int childId,
    String testType,
    int age,
    String sex,
    String? jaundice,
    String? familyAsd,
    List<Map<String, dynamic>> answers,
  );

  Future<Either<Failure, List<TestResultEntity>>> getTestHistory(
    String childId,
  );
}

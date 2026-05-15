import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/tests/domain/entities/test_entity.dart';
import 'package:child_monitor_app/features/tests/domain/repositories/tests_repository.dart';

class GetTestQuestionsUseCase {
  final TestsRepository repository;

  GetTestQuestionsUseCase({required this.repository});

  Future<Either<Failure, TestEntity>> call(String testType) async {
    return await repository.getTestQuestions(testType);
  }
}

class SubmitTestUseCase {
  final TestsRepository repository;

  SubmitTestUseCase({required this.repository});

  Future<Either<Failure, TestResultEntity>> call(
    int childId,
    String testType,
    int age,
    String sex,
    String jaundice,
    String familyAsd,
    List<Map<String, dynamic>> answers,
  ) async {
    return await repository.submitTest(
      childId,
      testType,
      age,
      sex,
      jaundice,
      familyAsd,
      answers,
    );
  }
}

class GetTestHistoryUseCase {
  final TestsRepository repository;

  GetTestHistoryUseCase({required this.repository});

  Future<Either<Failure, List<TestResultEntity>>> call(String childId) async {
    return await repository.getTestHistory(childId);
  }
}

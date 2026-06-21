import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/core/network/api_client.dart' hide TestQuestion;
import 'package:child_monitor_app/features/tests/data/datasources/tests_remote_data_source.dart';
import 'package:child_monitor_app/features/tests/domain/repositories/tests_repository.dart';
import 'package:child_monitor_app/features/tests/domain/entities/test_entity.dart';

class TestsRepositoryImpl implements TestsRepository {
  final TestsRemoteDataSource remoteDataSource;

  TestsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, TestEntity>> getTestQuestions(String testType) async {
    try {
      final response = await remoteDataSource.getTestQuestions(testType);
      return Right(
        TestEntity(
          testType: response.testType,
          totalQuestions: response.totalQuestions,
          instructions: response.instructions,
          questions: response.questions
              .map((q) => TestQuestion(
                    id: q.id,
                    question: q.question,
                    options: q.options,
                  ))
              .toList(),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TestResultEntity>> submitTest(
    int childId,
    String testType,
    int age,
    String sex,
    String? jaundice,
    String? familyAsd,
    List<Map<String, dynamic>> answers,
  ) async {
    try {
      final request = TestSubmitRequest(
        childId: childId,
        testType: testType,
        age: age,
        sex: sex,
        jaundice: jaundice,
        familyAsd: familyAsd,
        answers: answers
            .map((a) => TestAnswer(
                  qId: a['q_id'] as int,
                  answer: a['answer'] as String,
                ))
            .toList(),
      );

      final response = await remoteDataSource.submitTest(request);

      return Right(
        TestResultEntity(
          testId: response.testId,
          testType: response.testType,
          result: response.result,
          riskScore: response.riskScore,
          childId: response.childId,
          childName: response.childName,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<TestResultEntity>>> getTestHistory(
    String childId,
  ) async {
    // No API endpoint exists for test history — return empty list gracefully
    return const Right([]);
  }
}

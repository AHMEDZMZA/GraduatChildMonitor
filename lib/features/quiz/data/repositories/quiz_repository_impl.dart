import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:child_monitor_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:child_monitor_app/features/quiz/domain/repositories/quiz_repository.dart';

class QuizRepositoryImpl implements QuizRepository {
  final QuizRemoteDataSource remoteDataSource;

  QuizRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, QuizEntity>> getQuizQuestions() async {
    try {
      final response = await remoteDataSource.getQuizQuestions();
      final entity = QuizEntity(
        title: response.title,
        description: response.description,
        totalQuestions: response.totalQuestions,
        questions: response.questions.map((q) => QuizQuestionEntity(
          id: q.id,
          question: q.question,
          type: q.type,
        )).toList(),
      );
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      return Left(ServerFailure(e.message ?? 'Network Error'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, QuizResultEntity>> submitQuiz(String childId, Map<String, dynamic> answers) async {
    try {
      final request = QuizSubmitRequest(childId: int.tryParse(childId) ?? 1, answers: answers);
      final response = await remoteDataSource.submitQuiz(request);
      final entity = QuizResultEntity(
        message: response.message,
        score: response.score,
        feedback: response.feedback,
        resultId: response.resultId,
      );
      return Right(entity);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on DioException catch (e) {
      String errorMessage = e.message ?? 'Network Error';
      if (e.response != null && e.response?.data != null) {
        errorMessage = 'Server error: ${e.response?.statusCode} - ${e.response?.data}';
      }
      return Left(ServerFailure(errorMessage));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import '../../domain/repositories/monthly_assessment_repository.dart';

/// Concrete implementation of [MonthlyAssessmentRepository].
/// Bridges the domain layer to [ApiClient] for monthly assessment network calls.
class MonthlyAssessmentRepositoryImpl implements MonthlyAssessmentRepository {
  final ApiClient apiClient;

  MonthlyAssessmentRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, MonthlyAssessmentQuestionsResponse>> getQuestions(
    String disorder,
  ) async {
    try {
      final response = await apiClient.getMonthlyAssessmentQuestions(disorder);
      return Right(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['error'] ??
          e.response?.data?['message'] ??
          'Error connecting to server';
      return Left(ServerFailure(msg.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, SubmitMonthlyAssessmentResponse>> submitAssessment({
    required int childId,
    required String disorder,
    required List<MonthlyAssessmentAnswer> answers,
  }) async {
    try {
      final request = SubmitMonthlyAssessmentRequest(
        childId: childId,
        disorder: disorder,
        answers: answers,
      );
      final response = await apiClient.submitMonthlyAssessment(request);
      return Right(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['error'] ??
          e.response?.data?['message'] ??
          'Error submitting assessment';
      return Left(ServerFailure(msg.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, MonthlyAssessmentHistoryResponse>> getHistory(
    String childId,
  ) async {
    try {
      final response = await apiClient.getMonthlyAssessmentHistory(childId);
      return Right(response.data);
    } on DioException catch (e) {
      final msg = e.response?.data?['error'] ??
          e.response?.data?['message'] ??
          'Error loading history';
      return Left(ServerFailure(msg.toString()));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}

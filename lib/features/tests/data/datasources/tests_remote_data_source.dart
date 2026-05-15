import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class TestsRemoteDataSource {
  Future<TestQuestionsResponse> getTestQuestions(String testType);
  Future<TestResultResponse> submitTest(TestSubmitRequest request);
}

class TestsRemoteDataSourceImpl implements TestsRemoteDataSource {
  final ApiClient apiClient;

  TestsRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TestQuestionsResponse> getTestQuestions(String testType) async {
    try {
      final response = await apiClient.getTestQuestions(testType);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get test questions failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<TestResultResponse> submitTest(TestSubmitRequest request) async {
    try {
      final response = await apiClient.submitTest(request);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Submit test failed: ${e.toString()}');
    }
  }

  ServerException _handleDioException(DioException e) {
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(message: 'Unauthorized access');
    } else if (e.response?.statusCode == 404) {
      throw ServerException(message: 'Resource not found', statusCode: 404);
    } else if (e.response?.statusCode == 500) {
      throw ServerException(message: 'Server error', statusCode: 500);
    }
    throw ServerException(message: e.message ?? 'Unknown error');
  }
}

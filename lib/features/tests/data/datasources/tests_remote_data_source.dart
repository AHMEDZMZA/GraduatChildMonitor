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
    final data = e.response?.data;
    final msg = (data is Map ? data['message'] : null) as String?;
    if (e.response?.statusCode == 401) {
      throw UnauthorizedException(message: msg ?? 'Unauthorized access');
    } else if (e.response?.statusCode == 403) {
      throw ForbiddenException(
        message: msg ?? 'Access Forbidden - you do not have permission to access this resource',
      );
    } else if (e.response?.statusCode == 404) {
      throw ServerException(message: msg ?? 'Resource not found', statusCode: 404);
    } else if (e.response?.statusCode == 500) {
      throw ServerException(message: msg ?? 'Server error', statusCode: 500);
    }
    throw ServerException(message: msg ?? (e.message ?? 'Unknown error'));
  }
}

import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class TodayPlanRemoteDataSource {
  Future<TodayPlanResponse> getTodayPlan(String childId);
  Future<void> completeTodayPlan(String childId, String date);
  Future<List<Plan>> getPlanHistory(String childId);
  Future<HomeDataResponse> getHomeData(String? childId);
}

class TodayPlanRemoteDataSourceImpl implements TodayPlanRemoteDataSource {
  final ApiClient apiClient;

  TodayPlanRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TodayPlanResponse> getTodayPlan(String childId) async {
    try {
      final response = await apiClient.getTodayPlan(childId);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get today plan failed: ${e.toString()}');
    }
  }

  @override
  Future<void> completeTodayPlan(String childId, String date) async {
    try {
      await apiClient.completeTodayPlan(childId, date);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Complete plan failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Plan>> getPlanHistory(String childId) async {
    try {
      final response = await apiClient.getPlanHistory(childId);
      return response.data.plans;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get plan history failed: ${e.toString()}');
    }
  }

  @override
  Future<HomeDataResponse> getHomeData(String? childId) async {
    try {
      final response = await apiClient.getHomeData(childId);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get home data failed: ${e.toString()}');
    }
  }

  Exception _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        final data = e.response?.data;
        final msg = (data is Map ? data['message'] : null) as String?;
        if (e.response?.statusCode == 401) {
          return UnauthorizedException(
            message: msg ?? 'Unauthorized',
          );
        }
        if (e.response?.statusCode == 403) {
          return ForbiddenException(
            message: msg ?? 'Access Forbidden - you do not have permission to access this resource',
          );
        }
        return ServerException(
          message: msg ?? 'Server error',
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');
      default:
        return ServerException(message: 'Network error: ${e.message}');
    }
  }
}

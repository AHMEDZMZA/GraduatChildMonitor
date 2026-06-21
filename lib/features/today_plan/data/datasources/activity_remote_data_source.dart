import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ActivityRemoteDataSource {
  Future<ActivitiesResponse> getAllActivities();
  Future<ActivitiesResponse> getActivitiesByType(String type);
  Future<ActivitiesResponse> getActivitiesForChild(String childId);
  Future<ActivityDetailResponse> getActivityDetail(String activityId);
  Future<ActivityCompletionResponse> completeActivity(
    String childId,
    String activityId,
  );
  Future<ActivityStatsResponse> getActivityStats(String childId);
  Future<RecommendedActivitiesResponse> getRecommendedActivities(
    String childId,
  );
}

class ActivityRemoteDataSourceImpl implements ActivityRemoteDataSource {
  final ApiClient apiClient;

  ActivityRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<ActivitiesResponse> getAllActivities() async {
    try {
      final response = await apiClient.getAllActivities();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get all activities failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ActivitiesResponse> getActivitiesByType(String type) async {
    try {
      final response = await apiClient.getActivitiesByType(type);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get activities by type failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ActivitiesResponse> getActivitiesForChild(String childId) async {
    try {
      final childIdInt = int.tryParse(childId) ?? childId;
      final response = await apiClient.getActivitiesForChild({
        'childId': childIdInt,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get activities for child failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ActivityDetailResponse> getActivityDetail(String activityId) async {
    try {
      final response = await apiClient.getActivityDetail(activityId);
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get activity detail failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ActivityCompletionResponse> completeActivity(
    String childId,
    String activityId,
  ) async {
    try {
      final childIdInt = int.tryParse(childId) ?? childId;
      final activityIdInt = int.tryParse(activityId) ?? activityId;
      final response = await apiClient.completeActivity({
        'childId': childIdInt,
        'activityId': activityIdInt,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Complete activity failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<ActivityStatsResponse> getActivityStats(String childId) async {
    try {
      final childIdInt = int.tryParse(childId) ?? childId;
      final response = await apiClient.getActivityStats({
        'childId': childIdInt,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get activity stats failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<RecommendedActivitiesResponse> getRecommendedActivities(
    String childId,
  ) async {
    try {
      final childIdInt = int.tryParse(childId) ?? childId;
      final response = await apiClient.getRecommendedActivities({
        'childId': childIdInt,
      });
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get recommended activities failed: ${e.toString()}',
      );
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
          return UnauthorizedException(message: msg ?? 'Unauthorized');
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

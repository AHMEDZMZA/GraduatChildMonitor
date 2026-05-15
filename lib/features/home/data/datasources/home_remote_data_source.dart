import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

abstract class HomeRemoteDataSource {
  Future<HomeDataResponse> getHomeData(String? childId);
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final ApiClient apiClient;

  HomeRemoteDataSourceImpl(this.apiClient);

  @override
  Future<HomeDataResponse> getHomeData(String? childId) async {
    try {
      final response = await apiClient.getHomeData(childId);
      return response.data;
    } on DioException catch (e) {
      throw _mapDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get home data failed: ${e.toString()}');
    }
  }

  Exception _mapDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          return UnauthorizedException(
            message: e.response?.data['message'] ?? 'Unauthorized',
          );
        }
        final msg = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Server error'
            : 'Server error (${e.response?.statusCode})';
        return ServerException(
          message: msg,
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        return ServerException(message: 'Request cancelled');
      default:
        return ServerException(message: 'Network error: ${e.message}');
    }
  }
}

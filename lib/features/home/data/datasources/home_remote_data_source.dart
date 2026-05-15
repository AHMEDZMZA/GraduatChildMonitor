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
      _handleDioException(e);
      rethrow;
    } catch (e) {
      throw ServerException(message: 'Get home data failed: ${e.toString()}');
    }
  }

  void _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        throw NetworkException(message: 'Connection timeout');
      case DioExceptionType.badResponse:
        if (e.response?.statusCode == 401) {
          throw UnauthorizedException(
            message: e.response?.data['message'] ?? 'Unauthorized',
          );
        }
        final msg = e.response?.data is Map
            ? e.response?.data['message'] ?? 'Server error'
            : 'Server error (${e.response?.statusCode})';
        throw ServerException(
          message: msg,
          statusCode: e.response?.statusCode,
        );
      case DioExceptionType.cancel:
        throw ServerException(message: 'Request cancelled');
      default:
        throw ServerException(message: 'Network error: ${e.message}');
    }
  }
}

import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> signup({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<AuthResponse> login({
    required String email,
    required String password,
  });

  Future<void> logout();

  Future<void> requestPasswordReset(String email);

  Future<void> verifyOtp(String email, String otp);

  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;

  AuthRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<AuthResponse> signup({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await apiClient.signup(
        SignupRequest(
          monitorName: monitorName,
          email: email,
          password: password,
          confirmPassword: confirmPassword,
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Signup failed: ${e.toString()}');
    }
  }

  @override
  Future<AuthResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await apiClient.login(
        LoginRequest(email: email, password: password),
      );
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    try {
      await apiClient.logout();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Logout failed: ${e.toString()}');
    }
  }

  @override
  Future<void> requestPasswordReset(String email) async {
    try {
      await apiClient.requestPasswordReset(
        RequestPasswordResetRequest(email: email),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Request password reset failed: ${e.toString()}');
    }
  }

  @override
  Future<void> verifyOtp(String email, String otp) async {
    try {
      await apiClient.verifyOtp(
        VerifyOtpRequest(email: email, otp: otp),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'OTP verification failed: ${e.toString()}');
    }
  }

  @override
  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await apiClient.confirmPasswordReset(
        ConfirmPasswordResetRequest(
          email: email,
          otp: otp,
          newPassword: newPassword,
          confirmPassword: confirmPassword,
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Password reset failed: ${e.toString()}');
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

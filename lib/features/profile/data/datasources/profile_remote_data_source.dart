import 'dart:io';
import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:dio/dio.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileResponse> getUserProfile();

  Future<void> updateUserProfile(String monitorName, String email);

  Future<void> deleteAccount();

  Future<void> uploadProfileImage(File image);

  Future<List<Child>> getMyChildren();

  Future<Child> getChildDetail(String childId);

  Future<int> addChild({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  });

  Future<void> updateChild(
    String childId, {
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  });

  Future<void> deleteChild(String childId);

  Future<SettingsResponse> getSettings();

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ApiClient apiClient;

  ProfileRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<UserProfileResponse> getUserProfile() async {
    try {
      final response = await apiClient.getUserProfile();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get profile failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateUserProfile(String monitorName, String email) async {
    try {
      await apiClient.updateUserProfile(
        UpdateProfileRequest(monitorName: monitorName, email: email),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Update profile failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteAccount() async {
    try {
      await apiClient.deleteAccount();
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Delete account failed: ${e.toString()}');
    }
  }

  @override
  Future<void> uploadProfileImage(File image) async {
    try {
      await apiClient.uploadProfileImage(image);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Upload profile image failed: ${e.toString()}');
    }
  }

  @override
  Future<List<Child>> getMyChildren() async {
    try {
      final response = await apiClient.getMyChildren();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get children failed: ${e.toString()}');
    }
  }

  @override
  Future<Child> getChildDetail(String childId) async {
    try {
      final response = await apiClient.getChildDetail(childId);
      return Child(
        id: response.data.id,
        name: response.data.name,
        birthDate: response.data.birthDate,
        gender: response.data.gender,
        knowsCondition: response.data.knowsCondition,
        diagnosedCondition: response.data.diagnosedCondition,
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(
        message: 'Get child detail failed: ${e.toString()}',
      );
    }
  }

  @override
  Future<int> addChild({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) async {
    try {
      final response = await apiClient.addChild(
        AddChildRequest(
          name: name,
          birthDate: birthDate,
          gender: gender,
          knowsCondition: knowsCondition,
          diagnosedCondition: diagnosedCondition,
        ),
      );
      return response.data.childId;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Add child failed: ${e.toString()}');
    }
  }

  @override
  Future<void> updateChild(
    String childId, {
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) async {
    try {
      await apiClient.updateChild(
        childId,
        AddChildRequest(
          name: name,
          birthDate: birthDate,
          gender: gender,
          knowsCondition: knowsCondition,
          diagnosedCondition: diagnosedCondition,
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Update child failed: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteChild(String childId) async {
    try {
      await apiClient.deleteChild(childId);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Delete child failed: ${e.toString()}');
    }
  }

  @override
  Future<SettingsResponse> getSettings() async {
    try {
      final response = await apiClient.getSettings();
      return response.data;
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Get settings failed: ${e.toString()}');
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      await apiClient.changePassword(
        ChangePasswordRequest(
          currentPassword: currentPassword,
          newPassword: newPassword,
          confirmNewPassword: confirmNewPassword,
        ),
      );
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw ServerException(message: 'Change password failed: ${e.toString()}');
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

// Note: AddChildRequest and AddChildResponse are defined in api_client.dart

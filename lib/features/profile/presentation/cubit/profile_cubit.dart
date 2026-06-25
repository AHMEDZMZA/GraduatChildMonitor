import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:child_monitor_app/features/profile/domain/usecases/profile_usecases.dart';
import 'package:child_monitor_app/features/profile/presentation/state/profile_state.dart';
import 'package:child_monitor_app/features/profile/domain/entities/profile_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/service_locator.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserProfileUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final GetMyChildrenUseCase getMyChildrenUseCase;
  final GetChildDetailUseCase getChildDetailUseCase;
  final AddChildUseCase addChildUseCase;
  final UpdateChildUseCase updateChildUseCase;
  final DeleteChildUseCase deleteChildUseCase;
  final GetSettingsUseCase getSettingsUseCase;
  final ChangePasswordUseCase changePasswordUseCase;
  final UploadProfileImageUseCase uploadProfileImageUseCase;

  UserProfileEntity? _currentUserProfile;
  UserProfileEntity? get currentUserProfile => _currentUserProfile;

  ProfileCubit({
    required this.getUserProfileUseCase,
    required this.updateUserProfileUseCase,
    required this.deleteAccountUseCase,
    required this.getMyChildrenUseCase,
    required this.getChildDetailUseCase,
    required this.addChildUseCase,
    required this.updateChildUseCase,
    required this.deleteChildUseCase,
    required this.getSettingsUseCase,
    required this.changePasswordUseCase,
    required this.uploadProfileImageUseCase,
  }) : super(const ProfileInitial());

  Future<void> getUserProfile() async {
    emit(const ProfileLoading());
    final result = await getUserProfileUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (profile) {
        _currentUserProfile = profile;
        emit(UserProfileLoaded(profile));
      },
    );
  }

  Future<void> updateUserProfile(String monitorName, String email) async {
    emit(const ProfileLoading());
    final result = await updateUserProfileUseCase.call(monitorName, email);
    await result.fold(
      (failure) async => emit(ProfileError(failure.message)),
      (_) async {
        final profileResult = await getUserProfileUseCase.call();
        profileResult.fold(
          (failure) => emit(ProfileError(failure.message)),
          (profile) {
            _currentUserProfile = profile;
            emit(UserProfileLoaded(profile));
            emit(const ProfileUpdated());
          },
        );
      },
    );
  }

  Future<void> deleteAccount() async {
    emit(const ProfileLoading());
    final result = await deleteAccountUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(const AccountDeleted()),
    );
  }

  Future<void> uploadProfileImage(File image) async {
    emit(const ProfileLoading());
    final result = await uploadProfileImageUseCase.call(image);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) {
        emit(const ProfileImageUploaded());
        // Reload user profile after image upload to get the updated image url if it was returned in profile.
        // Currently, Profile doesn't seem to return imageUrl, but we trigger it just in case.
        getUserProfile();
      },
    );
  }

  Future<void> getMyChildren() async {
    emit(const ProfileLoading());
    final result = await getMyChildrenUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (children) => emit(ChildrenLoaded(children)),
    );
  }

  Future<void> getChildDetail(String childId) async {
    emit(const ProfileLoading());
    final result = await getChildDetailUseCase.call(childId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (child) => emit(ChildDetailLoaded(child)),
    );
  }

  Future<void> addChild({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) async {
    emit(const ProfileLoading());
    final result = await addChildUseCase.call(
      name: name,
      birthDate: birthDate,
      gender: gender,
      knowsCondition: knowsCondition,
      diagnosedCondition: diagnosedCondition,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (childId) {
        getIt<SharedPreferences>().setString('childId', childId.toString());
        emit(ChildAdded(childId));
      },
    );
  }

  Future<void> updateChild(
    String childId, {
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) async {
    emit(const ProfileLoading());
    final result = await updateChildUseCase.call(
      childId,
      name: name,
      birthDate: birthDate,
      gender: gender,
      knowsCondition: knowsCondition,
      diagnosedCondition: diagnosedCondition,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(const ChildUpdated()),
    );
  }

  Future<void> deleteChild(String childId) async {
    emit(const ProfileLoading());
    final result = await deleteChildUseCase.call(childId);
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(const ChildDeleted()),
    );
  }

  Future<void> getSettings() async {
    emit(const ProfileLoading());
    final result = await getSettingsUseCase.call();
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (settings) => emit(SettingsLoaded(settings)),
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    emit(const ProfileLoading());
    final result = await changePasswordUseCase.call(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
    result.fold(
      (failure) => emit(ProfileError(failure.message)),
      (_) => emit(const PasswordChanged()),
    );
  }
}

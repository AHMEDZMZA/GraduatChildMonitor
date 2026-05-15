import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/profile/domain/entities/profile_entity.dart';
import 'package:child_monitor_app/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase({required this.repository});

  Future<Either<Failure, UserProfileEntity>> call() {
    return repository.getUserProfile();
  }
}

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase({required this.repository});

  Future<Either<Failure, void>> call(String monitorName, String email) {
    return repository.updateUserProfile(monitorName, email);
  }
}

class DeleteAccountUseCase {
  final ProfileRepository repository;

  DeleteAccountUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.deleteAccount();
  }
}

class GetMyChildrenUseCase {
  final ProfileRepository repository;

  GetMyChildrenUseCase({required this.repository});

  Future<Either<Failure, List<ChildProfileEntity>>> call() {
    return repository.getMyChildren();
  }
}

class GetChildDetailUseCase {
  final ProfileRepository repository;

  GetChildDetailUseCase({required this.repository});

  Future<Either<Failure, ChildProfileEntity>> call(String childId) {
    return repository.getChildDetail(childId);
  }
}

class AddChildUseCase {
  final ProfileRepository repository;

  AddChildUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) {
    return repository.addChild(
      name: name,
      birthDate: birthDate,
      gender: gender,
      knowsCondition: knowsCondition,
      diagnosedCondition: diagnosedCondition,
    );
  }
}

class UpdateChildUseCase {
  final ProfileRepository repository;

  UpdateChildUseCase({required this.repository});

  Future<Either<Failure, void>> call(
    String childId, {
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  }) {
    return repository.updateChild(
      childId,
      name: name,
      birthDate: birthDate,
      gender: gender,
      knowsCondition: knowsCondition,
      diagnosedCondition: diagnosedCondition,
    );
  }
}

class DeleteChildUseCase {
  final ProfileRepository repository;

  DeleteChildUseCase({required this.repository});

  Future<Either<Failure, void>> call(String childId) {
    return repository.deleteChild(childId);
  }
}

class GetSettingsUseCase {
  final ProfileRepository repository;

  GetSettingsUseCase({required this.repository});

  Future<Either<Failure, SettingsEntity>> call() {
    return repository.getSettings();
  }
}

class ChangePasswordUseCase {
  final ProfileRepository repository;

  ChangePasswordUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) {
    return repository.changePassword(
      currentPassword: currentPassword,
      newPassword: newPassword,
      confirmNewPassword: confirmNewPassword,
    );
  }
}

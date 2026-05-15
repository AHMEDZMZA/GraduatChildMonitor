import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, UserProfileEntity>> getUserProfile();

  Future<Either<Failure, void>> updateUserProfile(String monitorName, String email);

  Future<Either<Failure, void>> deleteAccount();

  Future<Either<Failure, List<ChildProfileEntity>>> getMyChildren();

  Future<Either<Failure, ChildProfileEntity>> getChildDetail(String childId);

  Future<Either<Failure, void>> addChild({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  });

  Future<Either<Failure, void>> updateChild(
    String childId, {
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
    String? diagnosedCondition,
  });

  Future<Either<Failure, void>> deleteChild(String childId);

  Future<Either<Failure, SettingsEntity>> getSettings();

  Future<Either<Failure, void>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}

import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthEntity>> signup({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  });

  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> logout();

  Future<Either<Failure, void>> requestPasswordReset(String email);

  Future<Either<Failure, void>> verifyOtp(String email, String otp);

  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  });
}

import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/auth/domain/entities/auth_entity.dart';
import 'package:child_monitor_app/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;

  SignupUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  }) {
    return repository.signup(
      monitorName: monitorName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}

class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call({
    required String email,
    required String password,
  }) {
    return repository.login(email: email, password: password);
  }
}

class LogoutUseCase {
  final AuthRepository repository;

  LogoutUseCase({required this.repository});

  Future<Either<Failure, void>> call() {
    return repository.logout();
  }
}

class RequestPasswordResetUseCase {
  final AuthRepository repository;

  RequestPasswordResetUseCase({required this.repository});

  Future<Either<Failure, void>> call(String email) {
    return repository.requestPasswordReset(email);
  }
}

class VerifyOtpUseCase {
  final AuthRepository repository;

  VerifyOtpUseCase({required this.repository});

  Future<Either<Failure, void>> call(String email, String otp) {
    return repository.verifyOtp(email, otp);
  }
}

class ConfirmPasswordResetUseCase {
  final AuthRepository repository;

  ConfirmPasswordResetUseCase({required this.repository});

  Future<Either<Failure, void>> call({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) {
    return repository.confirmPasswordReset(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );
  }
}

class LoginWithGoogleUseCase {
  final AuthRepository repository;

  LoginWithGoogleUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call({required String idToken}) {
    return repository.loginWithGoogle(idToken: idToken);
  }
}

class LoginWithFacebookUseCase {
  final AuthRepository repository;

  LoginWithFacebookUseCase({required this.repository});

  Future<Either<Failure, AuthEntity>> call({required String accessToken}) {
    return repository.loginWithFacebook(accessToken: accessToken);
  }
}

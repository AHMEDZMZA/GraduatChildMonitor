import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/exceptions.dart';
import 'package:child_monitor_app/core/network/token_storage.dart';
import 'package:child_monitor_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:child_monitor_app/features/auth/domain/entities/auth_entity.dart';
import 'package:child_monitor_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final TokenStorage tokenStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.tokenStorage,
  });

  @override
  Future<Either<Failure, AuthEntity>> signup({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    try {
      final response = await remoteDataSource.signup(
        monitorName: monitorName,
        email: email,
        password: password,
        confirmPassword: confirmPassword,
      );

      // Save token and email
      await tokenStorage.saveToken(response.token);
      await tokenStorage.saveEmail(response.email);

      return Right(
        AuthEntity(
          message: response.message,
          email: response.email,
          token: response.token,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );

      // Save token and email
      await tokenStorage.saveToken(response.token);
      await tokenStorage.saveEmail(response.email);

      return Right(
        AuthEntity(
          message: response.message,
          email: response.email,
          token: response.token,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithGoogle({
    required String idToken,
  }) async {
    try {
      final response = await remoteDataSource.loginWithGoogle(idToken: idToken);

      // Save token and email
      await tokenStorage.saveToken(response.token);
      await tokenStorage.saveEmail(response.email);

      return Right(
        AuthEntity(
          message: response.message,
          email: response.email,
          token: response.token,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthEntity>> loginWithFacebook({
    required String accessToken,
  }) async {
    try {
      final response = await remoteDataSource.loginWithFacebook(
        accessToken: accessToken,
      );

      // Save token and email
      await tokenStorage.saveToken(response.token);
      await tokenStorage.saveEmail(response.email);

      return Right(
        AuthEntity(
          message: response.message,
          email: response.email,
          token: response.token,
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on UnauthorizedException catch (e) {
      return Left(UnauthorizedFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
    } catch (_) {
      // Ignore server-side logout failures (e.g. invalid/expired token)
      // to ensure the user can always log out locally.
    } finally {
      await tokenStorage.clearAuth();
    }
    return const Right(null);
  }

  @override
  Future<Either<Failure, void>> requestPasswordReset(String email) async {
    try {
      await remoteDataSource.requestPasswordReset(email);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> verifyOtp(String email, String otp) async {
    try {
      await remoteDataSource.verifyOtp(email, otp);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    try {
      await remoteDataSource.confirmPasswordReset(
        email: email,
        otp: otp,
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }
}

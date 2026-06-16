import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:child_monitor_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import 'package:child_monitor_app/core/network/token_storage.dart';
import 'dart:developer' as developer;

class AuthCubit extends Cubit<AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;
  final LoginWithGoogleUseCase loginWithGoogleUseCase;
  final LoginWithFacebookUseCase loginWithFacebookUseCase;
  final GoogleSignIn googleSignIn;
  final FacebookAuth facebookAuth;
  final TokenStorage tokenStorage;

  AuthCubit({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.requestPasswordResetUseCase,
    required this.verifyOtpUseCase,
    required this.confirmPasswordResetUseCase,
    required this.loginWithGoogleUseCase,
    required this.loginWithFacebookUseCase,
    required this.googleSignIn,
    required this.facebookAuth,
    required this.tokenStorage,
  }) : super(const AuthInitial());

  /// Called by the network layer when a 401 Unauthorized response is received.
  /// Signals that the stored token is no longer valid and the user must log in again.
  void handleUnauthenticated() {
    emit(const AuthUnauthenticated());
  }

  Future<void> signup({
    required String monitorName,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    emit(const AuthLoading());
    final result = await signupUseCase.call(
      monitorName: monitorName,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (auth) => emit(SignupSuccess(auth)),
    );
  }

  Future<void> login({required String email, required String password}) async {
    emit(const AuthLoading());
    final result = await loginUseCase.call(email: email, password: password);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (auth) => emit(LoginSuccess(auth)),
    );
  }

  Future<void> logout() async {
    emit(const AuthLoading());
    final result = await logoutUseCase.call();

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const LogoutSuccess()),
    );
  }

  Future<void> requestPasswordReset(String email) async {
    emit(const AuthLoading());
    final result = await requestPasswordResetUseCase.call(email);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordResetRequestSent()),
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    emit(const AuthLoading());
    final result = await verifyOtpUseCase.call(email, otp);

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const OtpVerified()),
    );
  }

  Future<void> confirmPasswordReset({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    emit(const AuthLoading());
    final result = await confirmPasswordResetUseCase.call(
      email: email,
      otp: otp,
      newPassword: newPassword,
      confirmPassword: confirmPassword,
    );

    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (_) => emit(const PasswordResetSuccess()),
    );
  }

  Future<void> signInWithGoogle() async {
    try {
      emit(const AuthLoading());
      developer.log('Google Sign-In: Starting Google sign-in flow');

      // Trigger the authentication flow
      final googleUser = await googleSignIn.signIn();
      if (googleUser == null) {
        developer.log('Google Sign-In: User cancelled the sign-in');
        emit(const AuthCancelled());
        return;
      }

      developer.log('Google Sign-In: User signed in - ${googleUser.email}');

      // Get the ID token
      final googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        developer.log('Google Sign-In: Failed to obtain ID token');
        emit(AuthError('Failed to obtain authentication token'));
        return;
      }

      developer.log('Google Sign-In: Successfully obtained ID token');

      // Send to backend
      final result = await loginWithGoogleUseCase.call(idToken: idToken);

      result.fold(
        (failure) {
          developer.log(
            'Google Sign-In: Backend authentication failed - ${failure.message}',
          );
          emit(AuthError(failure.message));
        },
        (auth) {
          developer.log(
            'Google Sign-In: Successfully authenticated - ${auth.email}',
          );
          emit(LoginSuccess(auth));
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Google Sign-In: Exception occurred - $e',
        stackTrace: stackTrace,
      );
      emit(AuthError('Google sign-in failed: ${e.toString()}'));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(const AuthLoading());
      developer.log('Facebook Login: Starting Facebook login flow');

      // Trigger the Facebook login flow
      final result = await facebookAuth.login(
        permissions: ['email', 'public_profile'],
      );

      if (result.status == LoginStatus.cancelled) {
        developer.log('Facebook Login: User cancelled the login');
        emit(const AuthCancelled());
        return;
      }

      if (result.status == LoginStatus.failed) {
        developer.log('Facebook Login: Login failed - ${result.message}');
        emit(AuthError('Login failed: ${result.message}'));
        return;
      }

      final accessToken = result.accessToken;
      if (accessToken == null) {
        developer.log('Facebook Login: Failed to obtain access token');
        emit(AuthError('Failed to obtain access token'));
        return;
      }

      developer.log('Facebook Login: Successfully obtained access token');

      // Send to backend
      final backendResult = await loginWithFacebookUseCase.call(
        accessToken: accessToken.tokenString,
      );

      backendResult.fold(
        (failure) {
          developer.log(
            'Facebook Login: Backend authentication failed - ${failure.message}',
          );
          emit(AuthError(failure.message));
        },
        (auth) {
          developer.log(
            'Facebook Login: Successfully authenticated - ${auth.email}',
          );
          emit(LoginSuccess(auth));
        },
      );
    } catch (e, stackTrace) {
      developer.log(
        'Facebook Login: Exception occurred - $e',
        stackTrace: stackTrace,
      );
      emit(AuthError('Facebook login failed: ${e.toString()}'));
    }
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import 'package:child_monitor_app/features/auth/domain/entities/auth_entity.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class AuthCubit extends Cubit<AuthState> {
  final SignupUseCase signupUseCase;
  final LoginUseCase loginUseCase;
  final LogoutUseCase logoutUseCase;
  final RequestPasswordResetUseCase requestPasswordResetUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ConfirmPasswordResetUseCase confirmPasswordResetUseCase;

  AuthCubit({
    required this.signupUseCase,
    required this.loginUseCase,
    required this.logoutUseCase,
    required this.requestPasswordResetUseCase,
    required this.verifyOtpUseCase,
    required this.confirmPasswordResetUseCase,
  }) : super(const AuthInitial());

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

      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        emit(const AuthError('Google Sign In cancelled'));
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final email = googleUser.email;
      final token = googleAuth.accessToken ?? '';

      final authEntity = AuthEntity(
        message: 'Successfully signed in with Google',
        email: email,
        token: token,
      );

      emit(SignupSuccess(authEntity));
    } catch (e) {
      emit(AuthError('Google Sign In failed: ${e.toString()}'));
    }
  }

  Future<void> signInWithFacebook() async {
    try {
      emit(const AuthLoading());

      final LoginResult result = await FacebookAuth.instance.login();

      if (result.status == LoginStatus.success) {
        final AccessToken? accessToken = result.accessToken;
        final userData = await FacebookAuth.instance.getUserData();

        final email = userData['email'] ?? userData['name'] ?? '';
        final token = accessToken?.tokenString ?? '';

        final authEntity = AuthEntity(
          message: 'Successfully signed in with Facebook',
          email: email,
          token: token,
        );

        emit(SignupSuccess(authEntity));
      } else if (result.status == LoginStatus.cancelled) {
        emit(const AuthError('Facebook Sign In cancelled'));
      } else {
        emit(AuthError('Facebook Sign In failed: ${result.message}'));
      }
    } catch (e) {
      emit(AuthError('Facebook Sign In failed: ${e.toString()}'));
    }
  }
}

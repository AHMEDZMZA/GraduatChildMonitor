import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/auth/domain/entities/auth_entity.dart';

abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  const AuthLoading();
}

class SignupSuccess extends AuthState {
  final AuthEntity auth;

  const SignupSuccess(this.auth);

  @override
  List<Object?> get props => [auth];
}

class LoginSuccess extends AuthState {
  final AuthEntity auth;

  const LoginSuccess(this.auth);

  @override
  List<Object?> get props => [auth];
}

class LogoutSuccess extends AuthState {
  const LogoutSuccess();
}

class AuthError extends AuthState {
  final String message;

  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Emitted by the 401 interceptor when the server rejects the stored token.
/// Views should listen for this and navigate the user to the login screen.
class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class PasswordResetRequestSent extends AuthState {
  const PasswordResetRequestSent();
}

class OtpVerified extends AuthState {
  const OtpVerified();
}

class PasswordResetSuccess extends AuthState {
  const PasswordResetSuccess();
}

/// Emitted when the user dismisses a social sign-in dialog (Google / Facebook).
/// This is NOT an error — treat it silently in the UI.
class AuthCancelled extends AuthState {
  const AuthCancelled();
}

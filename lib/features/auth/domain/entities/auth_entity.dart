import 'package:equatable/equatable.dart';

class AuthEntity extends Equatable {
  final String message;
  final String email;
  final String token;

  const AuthEntity({
    required this.message,
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [message, email, token];
}

class UserEntity extends Equatable {
  final String email;
  final String token;

  const UserEntity({
    required this.email,
    required this.token,
  });

  @override
  List<Object?> get props => [email, token];
}

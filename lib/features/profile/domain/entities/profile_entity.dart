import 'package:equatable/equatable.dart';

class UserProfileEntity extends Equatable {
  final String monitorName;
  final String email;
  final int userId;

  const UserProfileEntity({
    required this.monitorName,
    required this.email,
    required this.userId,
  });

  @override
  List<Object?> get props => [monitorName, email, userId];
}

class ChildProfileEntity extends Equatable {
  final String id;
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  const ChildProfileEntity({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    birthDate,
    gender,
    knowsCondition,
    diagnosedCondition,
  ];
}

class SettingsEntity extends Equatable {
  final int userId;
  final String email;
  final String monitorName;
  final Map<String, dynamic> availableSettings;

  const SettingsEntity({
    required this.userId,
    required this.email,
    required this.monitorName,
    required this.availableSettings,
  });

  @override
  List<Object?> get props => [userId, email, monitorName, availableSettings];
}

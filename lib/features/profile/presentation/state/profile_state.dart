import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class UserProfileLoaded extends ProfileState {
  final UserProfileEntity profile;

  const UserProfileLoaded(this.profile);

  @override
  List<Object?> get props => [profile];
}

class ProfileUpdated extends ProfileState {
  const ProfileUpdated();
}

class AccountDeleted extends ProfileState {
  const AccountDeleted();
}

class ChildrenLoaded extends ProfileState {
  final List<ChildProfileEntity> children;

  const ChildrenLoaded(this.children);

  @override
  List<Object?> get props => [children];
}

class ChildDetailLoaded extends ProfileState {
  final ChildProfileEntity child;

  const ChildDetailLoaded(this.child);

  @override
  List<Object?> get props => [child];
}

class ChildAdded extends ProfileState {
  final int childId;

  const ChildAdded(this.childId);

  @override
  List<Object?> get props => [childId];
}

class ChildUpdated extends ProfileState {
  const ChildUpdated();
}

class ChildDeleted extends ProfileState {
  const ChildDeleted();
}

class SettingsLoaded extends ProfileState {
  final SettingsEntity settings;

  const SettingsLoaded(this.settings);

  @override
  List<Object?> get props => [settings];
}

class PasswordChanged extends ProfileState {
  const PasswordChanged();
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError(this.message);

  @override
  List<Object?> get props => [message];
}

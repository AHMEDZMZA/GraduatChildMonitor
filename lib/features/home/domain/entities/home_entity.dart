import 'package:equatable/equatable.dart';
import '../../../profile/domain/entities/profile_entity.dart';

class HomeEntity extends Equatable {
  final String userName;
  final String greeting;
  final List<ChildProfileEntity> children;
  final String? selectedChildId;

  const HomeEntity({
    required this.userName,
    required this.greeting,
    required this.children,
    this.selectedChildId,
  });

  @override
  List<Object?> get props => [userName, greeting, children, selectedChildId];
}

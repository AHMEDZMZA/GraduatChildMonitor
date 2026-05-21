import 'package:equatable/equatable.dart';

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String activityType;
  final String difficultyLevel;
  final int durationMinutes;
  final int minAge;
  final int maxAge;
  final List<String> steps;
  final String? benefits;
  final String? exampleActivities;
  final bool isActive;

  const ActivityEntity({
    required this.id,
    required this.title,
    this.description,
    required this.activityType,
    required this.difficultyLevel,
    required this.durationMinutes,
    required this.minAge,
    required this.maxAge,
    required this.steps,
    this.benefits,
    this.exampleActivities,
    required this.isActive,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    description,
    activityType,
    difficultyLevel,
    durationMinutes,
    minAge,
    maxAge,
    steps,
    benefits,
    exampleActivities,
    isActive,
  ];
}

import 'package:equatable/equatable.dart';

class ChildEntity extends Equatable {
  final int? id;
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  const ChildEntity({
    this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  @override
  List<Object?> get props =>
      [id, name, birthDate, gender, knowsCondition, diagnosedCondition];
}

import 'package:equatable/equatable.dart';

class TestEntity extends Equatable {
  final String testType;
  final int totalQuestions;
  final String? instructions;
  final List<TestQuestion> questions;

  const TestEntity({
    required this.testType,
    required this.totalQuestions,
    this.instructions,
    required this.questions,
  });

  @override
  List<Object?> get props => [testType, totalQuestions, instructions, questions];
}

class TestQuestion extends Equatable {
  final int id;
  final String question;
  final List<String> options;

  const TestQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  @override
  List<Object?> get props => [id, question, options];
}

class TestResultEntity extends Equatable {
  final int testId;
  final String testType;
  final String result;
  final double riskScore;
  final int childId;

  const TestResultEntity({
    required this.testId,
    required this.testType,
    required this.result,
    required this.riskScore,
    required this.childId,
  });

  @override
  List<Object?> get props => [testId, testType, result, riskScore, childId];
}

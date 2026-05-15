import 'package:equatable/equatable.dart';

class TestResultEntity extends Equatable {
  final int testId;
  final String testType;
  final String result;
  final double riskScore;
  final int childId;
  final String childName;

  const TestResultEntity({
    required this.testId,
    required this.testType,
    required this.result,
    required this.riskScore,
    required this.childId,
    this.childName = '',
  });

  @override
  List<Object?> get props =>
      [testId, testType, result, riskScore, childId, childName];
}

class QuestionsResponseEntity extends Equatable {
  final String testType;
  final int totalQuestions;
  final String instructions;
  final List<QuestionEntityInner> questions;

  const QuestionsResponseEntity({
    required this.testType,
    required this.totalQuestions,
    required this.instructions,
    required this.questions,
  });

  @override
  List<Object?> get props =>
      [testType, totalQuestions, instructions, questions];
}

class QuestionEntityInner extends Equatable {
  final int qId;
  final String question;
  final String? type;

  const QuestionEntityInner({
    required this.qId,
    required this.question,
    this.type,
  });

  @override
  List<Object?> get props => [qId, question, type];
}

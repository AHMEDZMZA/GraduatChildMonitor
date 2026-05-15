class TestEntity {
  final String testType;
  final int totalQuestions;
  final String? instructions;
  final List<dynamic> questions;

  TestEntity({
    required this.testType,
    required this.totalQuestions,
    this.instructions,
    required this.questions,
  });
}

class TestResultEntity {
  final int testId;
  final String testType;
  final String result;
  final double riskScore;
  final int childId;

  TestResultEntity({
    required this.testId,
    required this.testType,
    required this.result,
    required this.riskScore,
    required this.childId,
  });
}

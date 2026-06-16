import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/api_client.dart';
import '../repositories/monthly_assessment_repository.dart';

class GetMonthlyAssessmentQuestionsUseCase {
  final MonthlyAssessmentRepository repository;

  GetMonthlyAssessmentQuestionsUseCase({required this.repository});

  Future<Either<Failure, MonthlyAssessmentQuestionsResponse>> call(
    String disorder,
  ) {
    return repository.getQuestions(disorder);
  }
}

class SubmitMonthlyAssessmentUseCase {
  final MonthlyAssessmentRepository repository;

  SubmitMonthlyAssessmentUseCase({required this.repository});

  Future<Either<Failure, SubmitMonthlyAssessmentResponse>> call({
    required int childId,
    required String disorder,
    required List<MonthlyAssessmentAnswer> answers,
  }) {
    return repository.submitAssessment(
      childId: childId,
      disorder: disorder,
      answers: answers,
    );
  }
}

class GetMonthlyAssessmentHistoryUseCase {
  final MonthlyAssessmentRepository repository;

  GetMonthlyAssessmentHistoryUseCase({required this.repository});

  Future<Either<Failure, MonthlyAssessmentHistoryResponse>> call(
    String childId,
  ) {
    return repository.getHistory(childId);
  }
}

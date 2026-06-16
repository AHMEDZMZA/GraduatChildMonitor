import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/core/network/api_client.dart';

/// Domain repository contract for Monthly Assessments.
/// Presentation layer depends on this abstraction only — never on ApiClient directly.
abstract class MonthlyAssessmentRepository {
  Future<Either<Failure, MonthlyAssessmentQuestionsResponse>> getQuestions(
    String disorder,
  );

  Future<Either<Failure, SubmitMonthlyAssessmentResponse>> submitAssessment({
    required int childId,
    required String disorder,
    required List<MonthlyAssessmentAnswer> answers,
  });

  Future<Either<Failure, MonthlyAssessmentHistoryResponse>> getHistory(
    String childId,
  );
}

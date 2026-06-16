import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/core/network/api_client.dart';
import '../../domain/usecases/monthly_assessment_usecases.dart';
import 'monthly_assessment_state.dart';

/// C-5 Fix: Cubit now depends on use cases (domain layer) instead of ApiClient directly.
/// Error handling, network calls, and data transformation are in the repository impl.
class MonthlyAssessmentCubit extends Cubit<MonthlyAssessmentState> {
  final GetMonthlyAssessmentQuestionsUseCase getQuestionsUseCase;
  final SubmitMonthlyAssessmentUseCase submitAssessmentUseCase;
  final GetMonthlyAssessmentHistoryUseCase getHistoryUseCase;

  MonthlyAssessmentCubit({
    required this.getQuestionsUseCase,
    required this.submitAssessmentUseCase,
    required this.getHistoryUseCase,
  }) : super(MonthlyAssessmentInitial());

  Future<void> getQuestions(String disorder) async {
    emit(MonthlyAssessmentQuestionsLoading());
    final result = await getQuestionsUseCase(disorder);
    result.fold(
      (failure) => emit(MonthlyAssessmentQuestionsError(failure.message)),
      (response) => emit(MonthlyAssessmentQuestionsLoaded(response)),
    );
  }

  Future<void> submitAssessment({
    required int childId,
    required String disorder,
    required List<MonthlyAssessmentAnswer> answers,
  }) async {
    emit(MonthlyAssessmentSubmitLoading());
    final result = await submitAssessmentUseCase(
      childId: childId,
      disorder: disorder,
      answers: answers,
    );
    result.fold(
      (failure) => emit(MonthlyAssessmentSubmitError(failure.message)),
      (response) => emit(MonthlyAssessmentSubmitSuccess(response)),
    );
  }

  Future<void> getHistory(String childId) async {
    emit(MonthlyAssessmentHistoryLoading());
    final result = await getHistoryUseCase(childId);
    result.fold(
      (failure) => emit(MonthlyAssessmentHistoryError(failure.message)),
      (response) => emit(MonthlyAssessmentHistoryLoaded(response)),
    );
  }
}

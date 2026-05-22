import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';
import 'monthly_assessment_state.dart';

class MonthlyAssessmentCubit extends Cubit<MonthlyAssessmentState> {
  final ApiClient apiClient;

  MonthlyAssessmentCubit({required this.apiClient}) : super(MonthlyAssessmentInitial());

  Future<void> getQuestions(String disorder) async {
    emit(MonthlyAssessmentQuestionsLoading());
    try {
      final response = await apiClient.getMonthlyAssessmentQuestions(disorder);
      if (response.response.statusCode == 200) {
        emit(MonthlyAssessmentQuestionsLoaded(response.data));
      } else {
        emit(const MonthlyAssessmentQuestionsError('Failed to load questions'));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.response?.data?['message'] ?? 'Error connecting to server';
      emit(MonthlyAssessmentQuestionsError(errorMsg.toString()));
    } catch (e) {
      emit(MonthlyAssessmentQuestionsError(e.toString()));
    }
  }

  Future<void> submitAssessment({
    required int childId,
    required String disorder,
    required List<MonthlyAssessmentAnswer> answers,
  }) async {
    emit(MonthlyAssessmentSubmitLoading());
    try {
      final request = SubmitMonthlyAssessmentRequest(
        childId: childId,
        disorder: disorder,
        answers: answers,
      );
      final response = await apiClient.submitMonthlyAssessment(request);
      if (response.response.statusCode == 200 || response.response.statusCode == 201) {
        emit(MonthlyAssessmentSubmitSuccess(response.data));
      } else {
        emit(const MonthlyAssessmentSubmitError('Failed to submit assessment'));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.response?.data?['message'] ?? 'Error submitting assessment';
      emit(MonthlyAssessmentSubmitError(errorMsg.toString()));
    } catch (e) {
      emit(MonthlyAssessmentSubmitError(e.toString()));
    }
  }

  Future<void> getHistory(String childId) async {
    emit(MonthlyAssessmentHistoryLoading());
    try {
      final response = await apiClient.getMonthlyAssessmentHistory(childId);
      if (response.response.statusCode == 200) {
        emit(MonthlyAssessmentHistoryLoaded(response.data));
      } else {
        emit(const MonthlyAssessmentHistoryError('Failed to load history'));
      }
    } on DioException catch (e) {
      final errorMsg = e.response?.data?['error'] ?? e.response?.data?['message'] ?? 'Error loading history';
      emit(MonthlyAssessmentHistoryError(errorMsg.toString()));
    } catch (e) {
      emit(MonthlyAssessmentHistoryError(e.toString()));
    }
  }
}

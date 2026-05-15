import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/tests/domain/repositories/tests_repository.dart';
import 'package:child_monitor_app/features/tests/domain/usecases/test_usecases.dart';
import 'tests_state.dart';

class TestsCubit extends Cubit<TestsState> {
  final GetTestQuestionsUseCase getTestQuestionsUseCase;
  final SubmitTestUseCase submitTestUseCase;
  final GetTestHistoryUseCase getTestHistoryUseCase;

  TestsCubit({
    required this.getTestQuestionsUseCase,
    required this.submitTestUseCase,
    required this.getTestHistoryUseCase,
  }) : super(const TestsInitial());

  Future<void> loadTestQuestions(String testType) async {
    emit(const TestsLoading());

    final result = await getTestQuestionsUseCase(testType);

    result.fold(
      (failure) {
        emit(TestsError(failure.toString()));
      },
      (test) {
        emit(TestQuestionsLoaded(test));
      },
    );
  }

  Future<void> submitTest(
    int childId,
    String testType,
    int age,
    String sex,
    String jaundice,
    String familyAsd,
    List<Map<String, dynamic>> answers,
  ) async {
    emit(const TestSubmitting());

    final result = await submitTestUseCase(
      childId,
      testType,
      age,
      sex,
      jaundice,
      familyAsd,
      answers,
    );

    result.fold(
      (failure) {
        emit(TestsError(failure.toString()));
      },
      (testResult) {
        emit(TestSubmissionSuccess(testResult));
      },
    );
  }

  Future<void> loadTestHistory(String childId) async {
    emit(const TestsLoading());

    final result = await getTestHistoryUseCase(childId);

    result.fold(
      (failure) {
        emit(TestsError(failure.toString()));
      },
      (history) {
        emit(TestHistoryLoaded(history));
      },
    );
  }
}

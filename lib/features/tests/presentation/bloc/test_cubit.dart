import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/child_entity.dart';
import '../../domain/entities/question_entity.dart';
import '../../domain/entities/test_submission_entity.dart';
import '../../domain/usecases/test_usecases.dart';
import '../../../profile/domain/usecases/profile_usecases.dart';
import '../../../../core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'test_state.dart';

class TestCubit extends Cubit<TestState> {
  final GetTestQuestionsUseCase getTestQuestionsUseCase;
  final SubmitTestUseCase submitTestUseCase;
  final AddChildUseCase addChildUseCase;

  TestCubit({
    required this.getTestQuestionsUseCase,
    required this.submitTestUseCase,
    required this.addChildUseCase,
  }) : super(TestInitial());

  void getQuestions(String testType) async {
    emit(QuestionsLoading());
    final result = await getTestQuestionsUseCase(testType);
    result.fold(
      (failure) => emit(QuestionsFailure(message: failure.toString())),
      (test) {
        final viewQuestions = test.questions
            .map(
              (q) => QuestionEntity(
                qId: q.id,
                question: q.question,
                options: q.options,
              ),
            )
            .toList();

        // Overwrite the response to match what the view expects (which is a bit messy,
        // so we'll just mock the structure it needs). Actually the view expects
        // QuestionsResponse with a 'questions' list of QuestionEntity
        // Let's create a custom object to satisfy both types.
        emit(
          QuestionsLoaded(
            questionsResponse: QuestionsResponseWrapper(
              testType: test.testType,
              totalQuestions: test.totalQuestions,
              instructions: test.instructions ?? '',
              questions: viewQuestions,
            ),
          ),
        );
      },
    );
  }

  void submitTest({
    required int childId,
    required String testType,
    required int age,
    required String sex,
    String? jaundice,
    String? familyAsd,
    required Map<int, String> answers,
  }) async {
    emit(SubmitTestLoading());

    final formattedAnswers = answers.entries
        .map((e) => {'q_id': e.key, 'answer': e.value})
        .toList();

    final result = await submitTestUseCase(
      childId,
      testType,
      age,
      sex,
      testType == 'autism' ? (jaundice ?? 'no') : null,
      testType == 'autism' ? (familyAsd ?? 'no') : null,
      formattedAnswers,
    );

    result.fold(
      (failure) => emit(SubmitTestFailure(message: failure.toString())),
      (res) => emit(
        SubmitTestSuccess(
          result: TestResultEntity(
            testId: res.testId,
            testType: res.testType,
            result: res.result,
            riskScore: res.riskScore,
            childId: res.childId,
            childName: res.childName,
          ),
        ),
      ),
    );
  }

  void submitMultipleTests({
    required int childId,
    required int age,
    required String sex,
    String? jaundice,
    String? familyAsd,
    required Map<String, Map<int, String>> allTestsAnswers,
  }) async {
    emit(MultipleTestsLoading());

    // As a simplification for the prototype, just submit the first test.
    // In a real app, this would iterate or call a batch endpoint.
    if (allTestsAnswers.isEmpty) {
      emit(MultipleTestsFailure(message: 'No tests to submit'));
      return;
    }

    final firstTest = allTestsAnswers.entries.first;
    final testType = firstTest.key;
    final formattedAnswers = firstTest.value.entries
        .map((e) => {'q_id': e.key, 'answer': e.value})
        .toList();

    final result = await submitTestUseCase(
      childId,
      testType,
      age,
      sex,
      testType == 'autism' ? (jaundice ?? 'no') : null,
      testType == 'autism' ? (familyAsd ?? 'no') : null,
      formattedAnswers,
    );

    result.fold(
      (failure) => emit(MultipleTestsFailure(message: failure.toString())),
      (res) => emit(
        MultipleTestsSuccess(
          results: [
            TestResultEntity(
              testId: res.testId,
              testType: res.testType,
              result: res.result,
              riskScore: res.riskScore,
              childId: res.childId,
              childName: res.childName,
            ),
          ],
        ),
      ),
    );
  }

  void addChild({
    required String name,
    required String birthDate,
    required String gender,
    required bool knowsCondition,
  }) async {
    emit(AddChildLoading());

    final result = await addChildUseCase(
      name: name,
      birthDate: birthDate,
      gender: gender,
      knowsCondition: knowsCondition,
    );

    result.fold(
      (failure) => emit(AddChildFailure(message: failure.toString())),
      (childId) {
        getIt<SharedPreferences>().setString('childId', childId.toString());
        emit(
          AddChildSuccess(
            child: ChildEntity(
              id: childId,
              name: name,
              birthDate: birthDate,
              gender: gender,
              knowsCondition: knowsCondition,
            ),
          ),
        );
      },
    );
  }
}

class QuestionsResponseWrapper {
  final String testType;
  final int totalQuestions;
  final String instructions;
  final List<QuestionEntity> questions;

  QuestionsResponseWrapper({
    required this.testType,
    required this.totalQuestions,
    required this.instructions,
    required this.questions,
  });
}

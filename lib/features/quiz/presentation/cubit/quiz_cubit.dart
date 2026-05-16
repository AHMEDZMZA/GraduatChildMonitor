import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/quiz/domain/usecases/quiz_usecases.dart';
import 'quiz_state.dart';

class QuizCubit extends Cubit<QuizState> {
  final GetQuizQuestionsUseCase getQuizQuestionsUseCase;
  final SubmitQuizUseCase submitQuizUseCase;

  QuizCubit({
    required this.getQuizQuestionsUseCase,
    required this.submitQuizUseCase,
  }) : super(QuizInitial());

  Future<void> getQuizQuestions() async {
    emit(QuizLoading());
    final result = await getQuizQuestionsUseCase.call();

    result.fold(
      (failure) => emit(QuizError(failure.message)),
      (data) => emit(QuizQuestionsLoaded(data)),
    );
  }

  Future<void> submitQuiz(String childId, Map<String, dynamic> answers) async {
    emit(QuizLoading());
    final result = await submitQuizUseCase.call(childId, answers);

    result.fold(
      (failure) => emit(QuizError(failure.message)),
      (response) => emit(QuizSubmitSuccess(response)),
    );
  }
}

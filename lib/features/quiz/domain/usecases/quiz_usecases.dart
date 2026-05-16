import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/quiz/domain/entities/quiz_entity.dart';
import 'package:child_monitor_app/features/quiz/domain/repositories/quiz_repository.dart';

class GetQuizQuestionsUseCase {
  final QuizRepository repository;

  GetQuizQuestionsUseCase({required this.repository});

  Future<Either<Failure, QuizEntity>> call() {
    return repository.getQuizQuestions();
  }
}

class SubmitQuizUseCase {
  final QuizRepository repository;

  SubmitQuizUseCase({required this.repository});

  Future<Either<Failure, QuizResultEntity>> call(String childId, Map<String, dynamic> answers) {
    return repository.submitQuiz(childId, answers);
  }
}

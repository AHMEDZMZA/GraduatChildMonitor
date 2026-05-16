import 'package:dartz/dartz.dart';
import 'package:child_monitor_app/core/network/failures.dart';
import 'package:child_monitor_app/features/quiz/domain/entities/quiz_entity.dart';

abstract class QuizRepository {
  Future<Either<Failure, QuizEntity>> getQuizQuestions();
  Future<Either<Failure, QuizResultEntity>> submitQuiz(String childId, Map<String, dynamic> answers);
}

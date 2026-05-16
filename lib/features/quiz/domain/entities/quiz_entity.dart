import 'package:equatable/equatable.dart';

class QuizEntity extends Equatable {
  final String title;
  final String description;
  final int totalQuestions;
  final List<QuizQuestionEntity> questions;

  const QuizEntity({
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.questions,
  });

  @override
  List<Object?> get props => [title, description, totalQuestions, questions];
}

class QuizQuestionEntity extends Equatable {
  final int id;
  final String question;
  final String type;

  const QuizQuestionEntity({
    required this.id,
    required this.question,
    required this.type,
  });

  @override
  List<Object?> get props => [id, question, type];
}

class QuizResultEntity extends Equatable {
  final String message;
  final int score;
  final String feedback;
  final int resultId;

  const QuizResultEntity({
    required this.message,
    required this.score,
    required this.feedback,
    required this.resultId,
  });

  @override
  List<Object?> get props => [message, score, feedback, resultId];
}

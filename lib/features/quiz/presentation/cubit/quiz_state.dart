import 'package:equatable/equatable.dart';
import 'package:child_monitor_app/features/quiz/domain/entities/quiz_entity.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizQuestionsLoaded extends QuizState {
  final QuizEntity data;

  const QuizQuestionsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class QuizSubmitSuccess extends QuizState {
  final QuizResultEntity result;

  const QuizSubmitSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}

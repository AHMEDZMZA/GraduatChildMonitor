import 'package:equatable/equatable.dart';

class QuestionEntity extends Equatable {
  final int qId;
  final String question;
  final List<String> options;
  final String instructions;

  const QuestionEntity({
    required this.qId,
    required this.question,
    this.options = const [],
    this.instructions = '',
  });

  @override
  List<Object?> get props => [qId, question, options, instructions];
}

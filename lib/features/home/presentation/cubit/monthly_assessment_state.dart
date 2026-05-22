import 'package:equatable/equatable.dart';
import '../../../../core/network/api_client.dart';

abstract class MonthlyAssessmentState extends Equatable {
  const MonthlyAssessmentState();

  @override
  List<Object?> get props => [];
}

class MonthlyAssessmentInitial extends MonthlyAssessmentState {}

// Fetch Questions
class MonthlyAssessmentQuestionsLoading extends MonthlyAssessmentState {}

class MonthlyAssessmentQuestionsLoaded extends MonthlyAssessmentState {
  final MonthlyAssessmentQuestionsResponse response;
  const MonthlyAssessmentQuestionsLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class MonthlyAssessmentQuestionsError extends MonthlyAssessmentState {
  final String message;
  const MonthlyAssessmentQuestionsError(this.message);

  @override
  List<Object?> get props => [message];
}

// Submit Assessment
class MonthlyAssessmentSubmitLoading extends MonthlyAssessmentState {}

class MonthlyAssessmentSubmitSuccess extends MonthlyAssessmentState {
  final SubmitMonthlyAssessmentResponse response;
  const MonthlyAssessmentSubmitSuccess(this.response);

  @override
  List<Object?> get props => [response];
}

class MonthlyAssessmentSubmitError extends MonthlyAssessmentState {
  final String message;
  const MonthlyAssessmentSubmitError(this.message);

  @override
  List<Object?> get props => [message];
}

// Fetch History
class MonthlyAssessmentHistoryLoading extends MonthlyAssessmentState {}

class MonthlyAssessmentHistoryLoaded extends MonthlyAssessmentState {
  final MonthlyAssessmentHistoryResponse response;
  const MonthlyAssessmentHistoryLoaded(this.response);

  @override
  List<Object?> get props => [response];
}

class MonthlyAssessmentHistoryError extends MonthlyAssessmentState {
  final String message;
  const MonthlyAssessmentHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}

part of 'test_cubit.dart';

abstract class TestState extends Equatable {
  const TestState();

  @override
  List<Object?> get props => [];
}

class TestInitial extends TestState {}

class QuestionsLoading extends TestState {}

class QuestionsLoaded extends TestState {
  final QuestionsResponseWrapper questionsResponse;

  const QuestionsLoaded({required this.questionsResponse});

  @override
  List<Object?> get props => [questionsResponse];
}

class QuestionsFailure extends TestState {
  final String message;

  const QuestionsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class SubmitTestLoading extends TestState {}

class SubmitTestSuccess extends TestState {
  final TestResultEntity result;

  const SubmitTestSuccess({required this.result});

  @override
  List<Object?> get props => [result];
}

class SubmitTestFailure extends TestState {
  final String message;

  const SubmitTestFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class MultipleTestsLoading extends TestState {}

class MultipleTestsSuccess extends TestState {
  final List<TestResultEntity> results;

  const MultipleTestsSuccess({required this.results});

  @override
  List<Object?> get props => [results];
}

class MultipleTestsFailure extends TestState {
  final String message;

  const MultipleTestsFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

class AddChildLoading extends TestState {}

class AddChildSuccess extends TestState {
  final ChildEntity child;

  const AddChildSuccess({required this.child});

  @override
  List<Object?> get props => [child];
}

class AddChildFailure extends TestState {
  final String message;

  const AddChildFailure({required this.message});

  @override
  List<Object?> get props => [message];
}

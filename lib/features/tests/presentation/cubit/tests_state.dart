import 'package:equatable/equatable.dart';
import '../../domain/entities/test_entity.dart';

abstract class TestsState extends Equatable {
  const TestsState();

  @override
  List<Object?> get props => [];
}

class TestsInitial extends TestsState {
  const TestsInitial();
}

class TestsLoading extends TestsState {
  const TestsLoading();
}

class TestQuestionsLoaded extends TestsState {
  final TestEntity test;

  const TestQuestionsLoaded(this.test);

  @override
  List<Object?> get props => [test];
}

class TestSubmitting extends TestsState {
  const TestSubmitting();
}

class TestSubmissionSuccess extends TestsState {
  final TestResultEntity result;

  const TestSubmissionSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class TestHistoryLoaded extends TestsState {
  final List<TestResultEntity> history;

  const TestHistoryLoaded(this.history);

  @override
  List<Object?> get props => [history];
}

class TestsError extends TestsState {
  final String message;

  const TestsError(this.message);

  @override
  List<Object?> get props => [message];
}

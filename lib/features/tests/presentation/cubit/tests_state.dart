abstract class TestsState {
  const TestsState();
}

class TestsInitial extends TestsState {
  const TestsInitial();
}

class TestsLoading extends TestsState {
  const TestsLoading();
}

class TestQuestionsLoaded extends TestsState {
  final dynamic test;

  const TestQuestionsLoaded(this.test);
}

class TestSubmitting extends TestsState {
  const TestSubmitting();
}

class TestSubmissionSuccess extends TestsState {
  final dynamic result;

  const TestSubmissionSuccess(this.result);
}

class TestHistoryLoaded extends TestsState {
  final List<dynamic> history;

  const TestHistoryLoaded(this.history);
}

class TestsError extends TestsState {
  final String message;

  const TestsError(this.message);
}

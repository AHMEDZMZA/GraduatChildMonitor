import 'package:child_monitor_app/core/network/api_client.dart';

abstract class QuizRemoteDataSource {
  Future<QuizQuestionsResponse> getQuizQuestions();
  Future<QuizResultResponse> submitQuiz(QuizSubmitRequest request);
}

class QuizRemoteDataSourceImpl implements QuizRemoteDataSource {
  final ApiClient apiClient;

  QuizRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<QuizQuestionsResponse> getQuizQuestions() async {
    final response = await apiClient.getQuizQuestions();
    return response.data;
  }

  @override
  Future<QuizResultResponse> submitQuiz(QuizSubmitRequest request) async {
    final response = await apiClient.submitQuiz(request);
    return response.data;
  }
}

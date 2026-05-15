import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

class ApiConfig {
  static const String baseUrl = 'http://192.168.1.4:8086/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // ==================== AUTH ENDPOINTS ====================
  @POST('/auth/signup')
  Future<HttpResponse<AuthResponse>> signup(@Body() SignupRequest request);

  @POST('/auth/login')
  Future<HttpResponse<AuthResponse>> login(@Body() LoginRequest request);

  @POST('/auth/logout')
  Future<HttpResponse<MessageResponse>> logout();

  @POST('/auth/reset-password/request')
  Future<HttpResponse<MessageResponse>> requestPasswordReset(
    @Body() RequestPasswordResetRequest request,
  );

  @POST('/auth/reset-password/verify')
  Future<HttpResponse<MessageResponse>> verifyOtp(
    @Body() VerifyOtpRequest request,
  );

  @POST('/auth/reset-password/confirm')
  Future<HttpResponse<MessageResponse>> confirmPasswordReset(
    @Body() ConfirmPasswordResetRequest request,
  );

  // ==================== ARTICLES ENDPOINTS ====================
  @GET('/articles/all')
  Future<HttpResponse<ArticlesResponse>> getAllArticles();

  @GET('/articles/{articleId}')
  Future<HttpResponse<ArticleDetailResponse>> getArticleDetail(
    @Path('articleId') String articleId,
  );

  @GET('/articles/category/{category}')
  Future<HttpResponse<ArticlesResponse>> getArticlesByCategory(
    @Path('category') String category,
  );

  @POST('/articles/favorite/add')
  Future<HttpResponse<MessageResponse>> addArticleToFavorite(
    @Query('articleId') String articleId,
  );

  @DELETE('/articles/favorite/remove')
  Future<HttpResponse<MessageResponse>> removeArticleFromFavorite(
    @Query('articleId') String articleId,
  );

  @GET('/articles/favorites')
  Future<HttpResponse<FavoritesResponse>> getFavoriteArticles();

  @GET('/articles/favorite/check')
  Future<HttpResponse<IsFavoriteResponse>> checkIfArticleIsFavorite(
    @Query('articleId') String articleId,
  );

  // ==================== TODAY PLAN ENDPOINTS ====================
  @GET('/home/today-plan')
  Future<HttpResponse<TodayPlanResponse>> getTodayPlan(
    @Query('childId') String childId,
  );

  @POST('/home/plan/complete')
  Future<HttpResponse<MessageResponse>> completeTodayPlan(
    @Query('childId') String childId,
    @Query('date') String date,
  );

  @GET('/home/plan-history')
  Future<HttpResponse<PlanHistoryResponse>> getPlanHistory(
    @Query('childId') String childId,
  );

  @GET('/home/data')
  Future<HttpResponse<HomeDataResponse>> getHomeData(
    @Query('childId') String? childId,
  );

  // ==================== PROFILE/USER ENDPOINTS ====================
  @GET('/children/profile')
  Future<HttpResponse<UserProfileResponse>> getUserProfile();

  @PUT('/children/update-profile')
  Future<HttpResponse<MessageResponse>> updateUserProfile(
    @Body() UpdateProfileRequest request,
  );

  @DELETE('/children/delete-account')
  Future<HttpResponse<MessageResponse>> deleteAccount();

  @GET('/children/my-children')
  Future<HttpResponse<MyChildrenResponse>> getMyChildren();

  @GET('/children/{childId}')
  Future<HttpResponse<ChildDetailResponse>> getChildDetail(
    @Path('childId') String childId,
  );

  @POST('/children/add')
  Future<HttpResponse<AddChildResponse>> addChild(
    @Body() AddChildRequest request,
  );

  @PUT('/children/{childId}')
  Future<HttpResponse<MessageResponse>> updateChild(
    @Path('childId') String childId,
    @Body() AddChildRequest request,
  );

  @DELETE('/children/{childId}')
  Future<HttpResponse<MessageResponse>> deleteChild(
    @Path('childId') String childId,
  );

  @GET('/settings')
  Future<HttpResponse<SettingsResponse>> getSettings();

  @POST('/password/change')
  Future<HttpResponse<MessageResponse>> changePassword(
    @Body() ChangePasswordRequest request,
  );

  // ==================== ACTIVITIES ENDPOINTS ====================
  @GET('/activities/all')
  Future<HttpResponse<ActivitiesResponse>> getAllActivities();

  @GET('/activities/type/{type}')
  Future<HttpResponse<ActivitiesResponse>> getActivitiesByType(
    @Path('type') String type,
  );

  @GET('/activities/for-child/{childId}')
  Future<HttpResponse<ActivitiesResponse>> getActivitiesForChild(
    @Path('childId') String childId,
  );

  @GET('/activities/{activityId}')
  Future<HttpResponse<ActivityDetailResponse>> getActivityDetail(
    @Path('activityId') String activityId,
  );

  @POST('/activities/complete')
  Future<HttpResponse<ActivityCompletionResponse>> completeActivity(
    @Query('childId') String childId,
    @Query('activityId') String activityId,
  );

  @GET('/activities/stats/{childId}')
  Future<HttpResponse<ActivityStatsResponse>> getActivityStats(
    @Path('childId') String childId,
  );

  @GET('/activities/recommended/{childId}')
  Future<HttpResponse<RecommendedActivitiesResponse>> getRecommendedActivities(
    @Path('childId') String childId,
  );

  // ==================== CHATBOT ENDPOINTS ====================
  @POST('/chatbot/send')
  Future<HttpResponse<ChatbotResponse>> sendChatMessage(
    @Body() ChatMessageRequest request,
  );

  @GET('/chatbot/history')
  Future<HttpResponse<ChatHistoryResponse>> getChatHistory(
    @Query('conversationId') String? conversationId,
  );

  // ==================== QUIZ ENDPOINTS ====================
  @GET('/quiz/questions')
  Future<HttpResponse<QuizQuestionsResponse>> getQuizQuestions();

  @POST('/quiz/submit')
  Future<HttpResponse<QuizResultResponse>> submitQuiz(
    @Query('childId') String childId,
    @Body() QuizSubmitRequest request,
  );

  @GET('/quiz/history/{childId}')
  Future<HttpResponse<QuizHistoryResponse>> getQuizHistory(
    @Path('childId') String childId,
  );

  // ==================== ASSESSMENT ENDPOINTS ====================
  @POST('/monthly-assessment/submit')
  Future<HttpResponse<AssessmentResponse>> submitAssessment(
    @Query('childId') String childId,
    @Body() AssessmentRequest request,
  );

  @GET('/monthly-assessment/child/{childId}')
  Future<HttpResponse<AssessmentHistoryResponse>> getChildAssessments(
    @Path('childId') String childId,
  );

  @GET('/monthly-assessment/trend/{childId}')
  Future<HttpResponse<AssessmentTrendResponse>> getAssessmentTrend(
    @Path('childId') String childId,
  );

  @GET('/monthly-assessment/{assessmentId}')
  Future<HttpResponse<AssessmentDetailResponse>> getAssessmentDetail(
    @Path('assessmentId') String assessmentId,
  );

  // ==================== TESTS ENDPOINTS ====================
  @POST('/tests/submit')
  Future<HttpResponse<TestResultResponse>> submitTest(
    @Body() TestSubmitRequest request,
  );

  @GET('/tests/questions/{testType}')
  Future<HttpResponse<TestQuestionsResponse>> getTestQuestions(
    @Path('testType') String testType,
  );

  // ==================== HOME PROGRESS ENDPOINT ====================
  @GET('/home/progress')
  Future<HttpResponse<HomeProgressResponse>> getHomeProgress(
    @Query('childId') String childId,
  );
}

// ==================== AUTH DTOs ====================
class AuthResponse {
  final String message;
  final String email;
  final String token;

  AuthResponse({
    required this.message,
    required this.email,
    required this.token,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      message: json['message'] ?? '',
      email: json['email'] ?? '',
      token: json['token'] ?? '',
    );
  }
}

class SignupRequest {
  final String monitorName;
  final String email;
  final String password;
  final String confirmPassword;

  SignupRequest({
    required this.monitorName,
    required this.email,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'monitorName': monitorName,
    'email': email,
    'password': password,
    'confirmPassword': confirmPassword,
  };
}

class LoginRequest {
  final String email;
  final String password;

  LoginRequest({required this.email, required this.password});

  Map<String, dynamic> toJson() => {'email': email, 'password': password};
}

class RequestPasswordResetRequest {
  final String email;

  RequestPasswordResetRequest({required this.email});

  Map<String, dynamic> toJson() => {'email': email};
}

class VerifyOtpRequest {
  final String email;
  final String otp;

  VerifyOtpRequest({required this.email, required this.otp});

  Map<String, dynamic> toJson() => {'email': email, 'otp': otp};
}

class ConfirmPasswordResetRequest {
  final String email;
  final String otp;
  final String newPassword;
  final String confirmPassword;

  ConfirmPasswordResetRequest({
    required this.email,
    required this.otp,
    required this.newPassword,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'otp': otp,
    'newPassword': newPassword,
    'confirmPassword': confirmPassword,
  };
}

// ==================== ARTICLES DTOs ====================
class ArticlesResponse {
  final List<Article> articles;

  ArticlesResponse({required this.articles});

  factory ArticlesResponse.fromJson(Map<String, dynamic> json) {
    return ArticlesResponse(
      articles:
          (json['articles'] as List?)
              ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Article {
  final String id;
  final String title;
  final String content;
  final String? image;
  final String category;
  final String? author;
  final String? publishedDate;
  final String? description;

  Article({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.category,
    this.author,
    this.publishedDate,
    this.description,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'],
      category: json['category'] ?? '',
      author: json['author'],
      publishedDate: json['publishedDate'],
      description: json['description'],
    );
  }
}

class ArticleDetailResponse {
  final String id;
  final String title;
  final String content;
  final String? image;
  final String category;
  final String? author;
  final String? publishedDate;
  final String? description;

  ArticleDetailResponse({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.category,
    this.author,
    this.publishedDate,
    this.description,
  });

  factory ArticleDetailResponse.fromJson(Map<String, dynamic> json) {
    return ArticleDetailResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      content: json['content'] ?? '',
      image: json['image'],
      category: json['category'] ?? '',
      author: json['author'],
      publishedDate: json['publishedDate'],
      description: json['description'],
    );
  }
}

class FavoritesResponse {
  final List<Article> favorites;

  FavoritesResponse({required this.favorites});

  factory FavoritesResponse.fromJson(Map<String, dynamic> json) {
    return FavoritesResponse(
      favorites:
          (json['favorites'] as List?)
              ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class IsFavoriteResponse {
  final bool isFavorite;

  IsFavoriteResponse({required this.isFavorite});

  factory IsFavoriteResponse.fromJson(Map<String, dynamic> json) {
    return IsFavoriteResponse(isFavorite: json['is_favorite'] ?? false);
  }
}

// ==================== TODAY PLAN DTOs ====================
class TodayPlanResponse {
  final Plan? plan;
  final List<Activity> activities;

  TodayPlanResponse({this.plan, required this.activities});

  factory TodayPlanResponse.fromJson(Map<String, dynamic> json) {
    return TodayPlanResponse(
      plan: json['plan'] != null ? Plan.fromJson(json['plan']) : null,
      activities:
          (json['activities'] as List?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Plan {
  final String id;
  final String date;
  final String status;
  final List<Activity> activities;

  Plan({
    required this.id,
    required this.date,
    required this.status,
    required this.activities,
  });

  factory Plan.fromJson(Map<String, dynamic> json) {
    return Plan(
      id: json['id']?.toString() ?? '',
      date: json['date'] ?? '',
      status: json['status'] ?? '',
      activities:
          (json['activities'] as List?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Activity {
  final String id;
  final String title;
  final String? description;
  final String type;
  final bool completed;

  Activity({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.completed,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      completed: json['completed'] ?? false,
    );
  }
}

class PlanHistoryResponse {
  final List<Plan> plans;

  PlanHistoryResponse({required this.plans});

  factory PlanHistoryResponse.fromJson(Map<String, dynamic> json) {
    return PlanHistoryResponse(
      plans:
          (json as List?)
              ?.map((e) => Plan.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class HomeDataResponse {
  final String userName;
  final String greeting;
  final List<Child> children;
  final Plan? todayPlan;
  final List<Activity> todayActivities;
  final Map<String, dynamic>? progressStats;
  final List<Article> articles;

  HomeDataResponse({
    required this.userName,
    required this.greeting,
    required this.children,
    this.todayPlan,
    required this.todayActivities,
    this.progressStats,
    required this.articles,
  });

  factory HomeDataResponse.fromJson(Map<String, dynamic> json) {
    return HomeDataResponse(
      userName: json['user_name'] ?? '',
      greeting: json['greeting'] ?? '',
      children:
          (json['children'] as List?)
              ?.map((e) => Child.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      todayPlan:
          json['today_plan'] != null ? Plan.fromJson(json['today_plan']) : null,
      todayActivities:
          (json['today_activities'] as List?)
              ?.map((e) => Activity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      progressStats: json['progress_stats'],
      articles:
          (json['articles'] as List?)
              ?.map((e) => Article.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ==================== PROFILE/USER DTOs ====================
class UserProfileResponse {
  final String monitorName;
  final String email;
  final int userId;

  UserProfileResponse({
    required this.monitorName,
    required this.email,
    required this.userId,
  });

  factory UserProfileResponse.fromJson(Map<String, dynamic> json) {
    return UserProfileResponse(
      monitorName: json['monitor_name'] ?? '',
      email: json['email'] ?? '',
      userId: json['user_id'] ?? 0,
    );
  }
}

class UpdateProfileRequest {
  final String monitorName;
  final String email;

  UpdateProfileRequest({required this.monitorName, required this.email});

  Map<String, dynamic> toJson() => {'monitorName': monitorName, 'email': email};
}

class MyChildrenResponse {
  final List<Child> children;

  MyChildrenResponse({required this.children});

  factory MyChildrenResponse.fromJson(Map<String, dynamic> json) {
    return MyChildrenResponse(
      children:
          (json['children'] as List?)
              ?.map((e) => Child.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class Child {
  final String id;
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  Child({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  factory Child.fromJson(Map<String, dynamic> json) {
    return Child(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      birthDate: json['birthDate'] ?? json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      knowsCondition:
          json['knowsCondition'] ?? json['knows_condition'] ?? false,
      diagnosedCondition:
          json['diagnosedCondition'] ?? json['diagnosed_condition'],
    );
  }
}

class ChildDetailResponse {
  final String id;
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  ChildDetailResponse({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  factory ChildDetailResponse.fromJson(Map<String, dynamic> json) {
    return ChildDetailResponse(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      birthDate: json['birthDate'] ?? json['birth_date'] ?? '',
      gender: json['gender'] ?? '',
      knowsCondition:
          json['knowsCondition'] ?? json['knows_condition'] ?? false,
      diagnosedCondition:
          json['diagnosedCondition'] ?? json['diagnosed_condition'],
    );
  }
}

class AddChildRequest {
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  AddChildRequest({
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'birthDate': birthDate,
    'gender': gender,
    'knowsCondition': knowsCondition,
    'diagnosedCondition': diagnosedCondition,
  };
}

class AddChildResponse {
  final String message;
  final int childId;
  final String childName;

  AddChildResponse({
    required this.message,
    required this.childId,
    required this.childName,
  });

  factory AddChildResponse.fromJson(Map<String, dynamic> json) {
    return AddChildResponse(
      message: json['message'] ?? '',
      childId: json['child_id'] ?? 0,
      childName: json['child_name'] ?? '',
    );
  }
}

class SettingsResponse {
  final int userId;
  final String email;
  final String monitorName;
  final Map<String, dynamic> availableSettings;

  SettingsResponse({
    required this.userId,
    required this.email,
    required this.monitorName,
    required this.availableSettings,
  });

  factory SettingsResponse.fromJson(Map<String, dynamic> json) {
    return SettingsResponse(
      userId: json['user_id'] ?? 0,
      email: json['email'] ?? '',
      monitorName: json['monitor_name'] ?? '',
      availableSettings: json['available_settings'] ?? {},
    );
  }
}

class ChangePasswordRequest {
  final String currentPassword;
  final String newPassword;
  final String confirmNewPassword;

  ChangePasswordRequest({
    required this.currentPassword,
    required this.newPassword,
    required this.confirmNewPassword,
  });

  Map<String, dynamic> toJson() => {
    'currentPassword': currentPassword,
    'newPassword': newPassword,
    'confirmNewPassword': confirmNewPassword,
  };
}

// ==================== COMMON DTOs ====================
class MessageResponse {
  final String message;

  MessageResponse({required this.message});

  factory MessageResponse.fromJson(Map<String, dynamic> json) {
    return MessageResponse(message: json['message'] ?? '');
  }
}

// ==================== ACTIVITIES DTOs ====================
class ActivitiesResponse {
  final List<ActivityItem> activities;

  ActivitiesResponse({required this.activities});

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return ActivitiesResponse(
      activities:
          (json['activities'] as List?)
              ?.map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ActivityItem {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String? image;
  final int? duration;

  ActivityItem({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.image,
    this.duration,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    return ActivityItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      image: json['image'],
      duration: json['duration'],
    );
  }
}

class ActivityDetailResponse {
  final String id;
  final String title;
  final String? description;
  final String type;
  final String? image;
  final int? duration;
  final String? instructions;
  final List<String>? materials;

  ActivityDetailResponse({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.image,
    this.duration,
    this.instructions,
    this.materials,
  });

  factory ActivityDetailResponse.fromJson(Map<String, dynamic> json) {
    return ActivityDetailResponse(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      image: json['image'],
      duration: json['duration'],
      instructions: json['instructions'],
      materials: List<String>.from(json['materials'] ?? []),
    );
  }
}

class ActivityCompletionResponse {
  final String message;
  final int completedCount;

  ActivityCompletionResponse({
    required this.message,
    required this.completedCount,
  });

  factory ActivityCompletionResponse.fromJson(Map<String, dynamic> json) {
    return ActivityCompletionResponse(
      message: json['message'] ?? '',
      completedCount: json['completed_count'] ?? 0,
    );
  }
}

class ActivityStatsResponse {
  final int completedCount;
  final int totalActivities;
  final double completionPercentage;
  final List<ProgressItem> progress;

  ActivityStatsResponse({
    required this.completedCount,
    required this.totalActivities,
    required this.completionPercentage,
    required this.progress,
  });

  factory ActivityStatsResponse.fromJson(Map<String, dynamic> json) {
    return ActivityStatsResponse(
      completedCount: json['completed_count'] ?? 0,
      totalActivities: json['total_activities'] ?? 0,
      completionPercentage: (json['completion_percentage'] ?? 0).toDouble(),
      progress:
          (json['progress'] as List?)
              ?.map((e) => ProgressItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class ProgressItem {
  final String date;
  final int completed;
  final int total;

  ProgressItem({
    required this.date,
    required this.completed,
    required this.total,
  });

  factory ProgressItem.fromJson(Map<String, dynamic> json) {
    return ProgressItem(
      date: json['date'] ?? '',
      completed: json['completed'] ?? 0,
      total: json['total'] ?? 0,
    );
  }
}

class RecommendedActivitiesResponse {
  final List<ActivityItem> recommendedActivities;

  RecommendedActivitiesResponse({required this.recommendedActivities});

  factory RecommendedActivitiesResponse.fromJson(Map<String, dynamic> json) {
    return RecommendedActivitiesResponse(
      recommendedActivities:
          (json['recommended_activities'] as List?)
              ?.map((e) => ActivityItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ==================== CHATBOT DTOs ====================
class ChatbotResponse {
  final ChatMessage userMessage;
  final ChatMessage botResponse;
  final String conversationId;

  ChatbotResponse({
    required this.userMessage,
    required this.botResponse,
    required this.conversationId,
  });

  factory ChatbotResponse.fromJson(Map<String, dynamic> json) {
    return ChatbotResponse(
      userMessage: ChatMessage.fromJson(
        json['user_message'] as Map<String, dynamic>,
      ),
      botResponse: ChatMessage.fromJson(
        json['bot_response'] as Map<String, dynamic>,
      ),
      conversationId: json['conversation_id'] ?? '',
    );
  }
}

class ChatMessage {
  final String message;
  final String timestamp;

  ChatMessage({required this.message, required this.timestamp});

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      message: json['message'] ?? '',
      timestamp: json['timestamp'] ?? '',
    );
  }
}

class ChatMessageRequest {
  final String message;
  final String? conversationId;

  ChatMessageRequest({required this.message, this.conversationId});

  Map<String, dynamic> toJson() => {
    'message': message,
    if (conversationId != null) 'conversation_id': conversationId,
  };
}

class ChatHistoryResponse {
  final List<ChatMessage> messages;

  ChatHistoryResponse({required this.messages});

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) {
    return ChatHistoryResponse(
      messages:
          (json['messages'] as List?)
              ?.map((e) => ChatMessage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

// ==================== QUIZ DTOs ====================
class QuizQuestionsResponse {
  final String title;
  final int totalQuestions;
  final List<QuizQuestion> questions;

  QuizQuestionsResponse({
    required this.title,
    required this.totalQuestions,
    required this.questions,
  });

  factory QuizQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return QuizQuestionsResponse(
      title: json['title'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      questions:
          (json['questions'] as List?)
              ?.map((e) => QuizQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class QuizQuestion {
  final int id;
  final String question;
  final String type;

  QuizQuestion({required this.id, required this.question, required this.type});

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

class QuizSubmitRequest {
  final Map<String, dynamic> answers;

  QuizSubmitRequest({required this.answers});

  Map<String, dynamic> toJson() => answers;
}

class QuizResultResponse {
  final String message;
  final int score;
  final String feedback;
  final int resultId;

  QuizResultResponse({
    required this.message,
    required this.score,
    required this.feedback,
    required this.resultId,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultResponse(
      message: json['message'] ?? '',
      score: json['score'] ?? 0,
      feedback: json['feedback'] ?? '',
      resultId: json['result_id'] ?? 0,
    );
  }
}

class QuizHistoryResponse {
  final int childId;
  final List<QuizAttempt> history;
  final int totalAttempts;

  QuizHistoryResponse({
    required this.childId,
    required this.history,
    required this.totalAttempts,
  });

  factory QuizHistoryResponse.fromJson(Map<String, dynamic> json) {
    return QuizHistoryResponse(
      childId: json['child_id'] ?? 0,
      history:
          (json['history'] as List?)
              ?.map((e) => QuizAttempt.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      totalAttempts: json['total_attempts'] ?? 0,
    );
  }
}

class QuizAttempt {
  final int attemptNumber;
  final int score;
  final String date;
  final String feedback;

  QuizAttempt({
    required this.attemptNumber,
    required this.score,
    required this.date,
    required this.feedback,
  });

  factory QuizAttempt.fromJson(Map<String, dynamic> json) {
    return QuizAttempt(
      attemptNumber: json['attempt_number'] ?? 0,
      score: json['score'] ?? 0,
      date: json['date'] ?? '',
      feedback: json['feedback'] ?? '',
    );
  }
}

// ==================== ASSESSMENT DTOs ====================
class AssessmentRequest {
  final int q1Focus;
  final int q2Social;
  final int q3Communication;
  final int q4Behavior;
  final int q5Learning;

  AssessmentRequest({
    required this.q1Focus,
    required this.q2Social,
    required this.q3Communication,
    required this.q4Behavior,
    required this.q5Learning,
  });

  Map<String, dynamic> toJson() => {
    'q1_focus': q1Focus,
    'q2_social': q2Social,
    'q3_communication': q3Communication,
    'q4_behavior': q4Behavior,
    'q5_learning': q5Learning,
  };
}

class AssessmentResponse {
  final String message;
  final int assessmentId;
  final String result;

  AssessmentResponse({
    required this.message,
    required this.assessmentId,
    required this.result,
  });

  factory AssessmentResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResponse(
      message: json['message'] ?? '',
      assessmentId: json['assessment_id'] ?? 0,
      result: json['result'] ?? '',
    );
  }
}

class AssessmentHistoryResponse {
  final int childId;
  final List<Assessment> assessments;
  final int total;

  AssessmentHistoryResponse({
    required this.childId,
    required this.assessments,
    required this.total,
  });

  factory AssessmentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentHistoryResponse(
      childId: json['child_id'] ?? 0,
      assessments:
          (json['assessments'] as List?)
              ?.map((e) => Assessment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      total: json['total'] ?? 0,
    );
  }
}

class Assessment {
  final int id;
  final String date;
  final String result;
  final Map<String, dynamic> scores;

  Assessment({
    required this.id,
    required this.date,
    required this.result,
    required this.scores,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] ?? 0,
      date: json['date'] ?? '',
      result: json['result'] ?? '',
      scores: json['scores'] ?? {},
    );
  }
}

class AssessmentTrendResponse {
  final List<Assessment> assessments;
  final String trend;
  final int improvement;

  AssessmentTrendResponse({
    required this.assessments,
    required this.trend,
    required this.improvement,
  });

  factory AssessmentTrendResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentTrendResponse(
      assessments:
          (json['assessments'] as List?)
              ?.map((e) => Assessment.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      trend: json['trend'] ?? '',
      improvement: json['improvement'] ?? 0,
    );
  }
}

class AssessmentDetailResponse {
  final int id;
  final int childId;
  final String date;
  final String result;
  final Map<String, dynamic> scores;

  AssessmentDetailResponse({
    required this.id,
    required this.childId,
    required this.date,
    required this.result,
    required this.scores,
  });

  factory AssessmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailResponse(
      id: json['id'] ?? 0,
      childId: json['child_id'] ?? 0,
      date: json['date'] ?? '',
      result: json['result'] ?? '',
      scores: json['scores'] ?? {},
    );
  }
}

// ==================== TESTS DTOs ====================
class TestSubmitRequest {
  final int childId;
  final String testType;
  final int age;
  final String sex;
  final String jaundice;
  final String familyAsd;
  final List<TestAnswer> answers;

  TestSubmitRequest({
    required this.childId,
    required this.testType,
    required this.age,
    required this.sex,
    required this.jaundice,
    required this.familyAsd,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'testType': testType,
    'age': age,
    'sex': sex,
    'jaundice': jaundice,
    'familyAsd': familyAsd,
    'answers': answers.map((e) => e.toJson()).toList(),
  };
}

class TestAnswer {
  final int qId;
  final String answer;

  TestAnswer({required this.qId, required this.answer});

  Map<String, dynamic> toJson() => {'q_id': qId, 'answer': answer};
}

class TestResultResponse {
  final int testId;
  final String testType;
  final String result;
  final double riskScore;
  final int childId;

  TestResultResponse({
    required this.testId,
    required this.testType,
    required this.result,
    required this.riskScore,
    required this.childId,
  });

  factory TestResultResponse.fromJson(Map<String, dynamic> json) {
    return TestResultResponse(
      testId: json['test_id'] ?? 0,
      testType: json['test_type'] ?? '',
      result: json['result'] ?? '',
      riskScore: (json['risk_score'] ?? 0).toDouble(),
      childId: json['child_id'] ?? 0,
    );
  }
}

class TestQuestionsResponse {
  final String testType;
  final int totalQuestions;
  final String instructions;
  final List<TestQuestion> questions;

  TestQuestionsResponse({
    required this.testType,
    required this.totalQuestions,
    required this.instructions,
    required this.questions,
  });

  factory TestQuestionsResponse.fromJson(Map<String, dynamic> json) {
    return TestQuestionsResponse(
      testType: json['test_type'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      instructions: json['instructions'] ?? '',
      questions:
          (json['questions'] as List?)
              ?.map((e) => TestQuestion.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }
}

class TestQuestion {
  final int id;
  final String question;
  final List<String> options;

  TestQuestion({
    required this.id,
    required this.question,
    required this.options,
  });

  factory TestQuestion.fromJson(Map<String, dynamic> json) {
    return TestQuestion(
      id: json['id'] ?? 0,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
    );
  }
}

// ==================== HOME PROGRESS DTOs ====================
class HomeProgressResponse {
  final int assessmentImprovement;
  final String trend;
  final int completedActivities;
  final String progressSummary;

  HomeProgressResponse({
    required this.assessmentImprovement,
    required this.trend,
    required this.completedActivities,
    required this.progressSummary,
  });

  factory HomeProgressResponse.fromJson(Map<String, dynamic> json) {
    return HomeProgressResponse(
      assessmentImprovement: json['assessment_improvement'] ?? 0,
      trend: json['trend'] ?? '',
      completedActivities: json['completed_activities'] ?? 0,
      progressSummary: json['progress_summary'] ?? '',
    );
  }
}

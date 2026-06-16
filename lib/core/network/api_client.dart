import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

class ApiConfig {
  static const String baseUrl = 'http://192.168.1.14:8086/api/';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // ==================== AUTH ENDPOINTS ====================
  @POST('auth/signup')
  Future<HttpResponse<AuthResponse>> signup(@Body() SignupRequest request);

  @POST('auth/login')
  Future<HttpResponse<AuthResponse>> login(@Body() LoginRequest request);

  @POST('auth/logout')
  Future<HttpResponse<MessageResponse>> logout();

  @POST('auth/reset-password/request')
  Future<HttpResponse<MessageResponse>> requestPasswordReset(
    @Body() RequestPasswordResetRequest request,
  );

  @POST('auth/reset-password/verify')
  Future<HttpResponse<MessageResponse>> verifyOtp(
    @Body() VerifyOtpRequest request,
  );

  @POST('auth/reset-password/confirm')
  Future<HttpResponse<MessageResponse>> confirmPasswordReset(
    @Body() ConfirmPasswordResetRequest request,
  );

  // ==================== SOCIAL AUTH ENDPOINTS ====================
  @POST('auth/google-login')
  Future<HttpResponse<AuthResponse>> loginWithGoogle(
    @Body() GoogleLoginRequest request,
  );

  @POST('auth/facebook-login')
  Future<HttpResponse<AuthResponse>> loginWithFacebook(
    @Body() FacebookLoginRequest request,
  );

  // ==================== ARTICLES ENDPOINTS ====================
  @GET('articles/all')
  Future<HttpResponse<ArticlesResponse>> getAllArticles();

  @GET('articles/{articleId}')
  Future<HttpResponse<ArticleDetailResponse>> getArticleDetail(
    @Path('articleId') String articleId,
  );

  @GET('articles/category/{category}')
  Future<HttpResponse<ArticlesResponse>> getArticlesByCategory(
    @Path('category') String category,
  );

  @POST('articles/favorite/add')
  Future<HttpResponse<MessageResponse>> addArticleToFavorite(
    @Query('articleId') String articleId,
  );

  @DELETE('articles/favorite/remove')
  Future<HttpResponse<MessageResponse>> removeArticleFromFavorite(
    @Query('articleId') String articleId,
  );

  @GET('articles/favorites')
  Future<HttpResponse<FavoritesResponse>> getFavoriteArticles();

  @GET('articles/favorite/check')
  Future<HttpResponse<IsFavoriteResponse>> checkIfArticleIsFavorite(
    @Query('articleId') String articleId,
  );

  // ==================== TODAY PLAN ENDPOINTS ====================
  @GET('home/today-plan')
  Future<HttpResponse<TodayPlanResponse>> getTodayPlan(
    @Query('childId') String childId,
  );

  @POST('home/plan/complete')
  Future<HttpResponse<MessageResponse>> completeTodayPlan(
    @Query('childId') String childId,
    @Query('date') String date,
  );

  @GET('home/plan-history')
  Future<HttpResponse<PlanHistoryResponse>> getPlanHistory(
    @Query('childId') String childId,
  );

  @GET('home/data')
  Future<HttpResponse<HomeDataResponse>> getHomeData(
    @Query('childId') String? childId,
  );

  // ==================== PROFILE/USER ENDPOINTS ====================
  @GET('children/profile')
  Future<HttpResponse<UserProfileResponse>> getUserProfile();

  @PUT('children/update-profile')
  Future<HttpResponse<MessageResponse>> updateUserProfile(
    @Body() UpdateProfileRequest request,
  );

  @DELETE('children/delete-account')
  Future<HttpResponse<MessageResponse>> deleteAccount();

  @GET('children/my-children')
  Future<HttpResponse<List<Child>>> getMyChildren();

  @GET('children/{childId}')
  Future<HttpResponse<ChildDetailResponse>> getChildDetail(
    @Path('childId') String childId,
  );

  @POST('children/add')
  Future<HttpResponse<AddChildResponse>> addChild(
    @Body() AddChildRequest request,
  );

  @PUT('children/{childId}')
  Future<HttpResponse<MessageResponse>> updateChild(
    @Path('childId') String childId,
    @Body() AddChildRequest request,
  );

  @DELETE('children/{childId}')
  Future<HttpResponse<MessageResponse>> deleteChild(
    @Path('childId') String childId,
  );

  @GET('settings')
  Future<HttpResponse<SettingsResponse>> getSettings();

  @POST('password/change')
  Future<HttpResponse<MessageResponse>> changePassword(
    @Body() ChangePasswordRequest request,
  );

  // ==================== ACTIVITIES ENDPOINTS ====================
  @GET('activities/all')
  Future<HttpResponse<ActivitiesResponse>> getAllActivities();

  @GET('activities/type/{type}')
  Future<HttpResponse<ActivitiesResponse>> getActivitiesByType(
    @Path('type') String type,
  );

  @GET('activities/for-child/{childId}')
  Future<HttpResponse<ActivitiesResponse>> getActivitiesForChild(
    @Path('childId') String childId,
  );

  @GET('activities/{activityId}')
  Future<HttpResponse<ActivityDetailResponse>> getActivityDetail(
    @Path('activityId') String activityId,
  );

  @POST('activities/complete')
  Future<HttpResponse<ActivityCompletionResponse>> completeActivity(
    @Query('childId') String childId,
    @Query('activityId') String activityId,
  );

  @GET('activities/stats/{childId}')
  Future<HttpResponse<ActivityStatsResponse>> getActivityStats(
    @Path('childId') String childId,
  );

  @GET('activities/recommended/{childId}')
  Future<HttpResponse<RecommendedActivitiesResponse>> getRecommendedActivities(
    @Path('childId') String childId,
  );

  // ==================== CHATBOT ENDPOINTS ====================
  @POST('chatbot/send')
  Future<HttpResponse<ChatbotResponse>> sendChatMessage(
    @Body() ChatMessageRequest request,
  );

  @GET('chatbot/history')
  Future<HttpResponse<ChatHistoryResponse>> getChatHistory(
    @Query('conversationId') String? conversationId,
  );

  // ==================== QUIZ ENDPOINTS ====================
  @GET('quiz/questions')
  Future<HttpResponse<QuizQuestionsResponse>> getQuizQuestions();

  @POST('quiz/submit')
  Future<HttpResponse<QuizResultResponse>> submitQuiz(
    @Body() QuizSubmitRequest request,
  );

  @GET('quiz/history/{childId}')
  Future<HttpResponse<QuizHistoryResponse>> getQuizHistory(
    @Path('childId') String childId,
  );

  // ==================== ASSESSMENT ENDPOINTS ====================
  @POST('monthly-assessment/submit')
  Future<HttpResponse<AssessmentResponse>> submitAssessment(
    @Query('childId') String childId,
    @Body() AssessmentRequest request,
  );

  @GET('monthly-assessment/child/{childId}')
  Future<HttpResponse<AssessmentHistoryResponse>> getChildAssessments(
    @Path('childId') String childId,
  );

  @GET('monthly-assessment/trend/{childId}')
  Future<HttpResponse<AssessmentTrendResponse>> getAssessmentTrend(
    @Path('childId') String childId,
  );

  @GET('monthly-assessment/{assessmentId}')
  Future<HttpResponse<AssessmentDetailResponse>> getAssessmentDetail(
    @Path('assessmentId') String assessmentId,
  );

  // ==================== NEW MONTHLY ASSESSMENT ENDPOINTS ====================
  @GET('home/monthly-assessment/questions/{disorder}')
  Future<HttpResponse<MonthlyAssessmentQuestionsResponse>>
  getMonthlyAssessmentQuestions(@Path('disorder') String disorder);

  @POST('home/monthly-assessment/submit')
  Future<HttpResponse<SubmitMonthlyAssessmentResponse>> submitMonthlyAssessment(
    @Body() SubmitMonthlyAssessmentRequest request,
  );

  @GET('home/monthly-assessment/history/{childId}')
  Future<HttpResponse<MonthlyAssessmentHistoryResponse>>
  getMonthlyAssessmentHistory(@Path('childId') String childId);

  @GET('monthly-assessment/{assessmentId}')
  Future<HttpResponse<MonthlyAssessmentSingleDetailResponse>>
  getMonthlyAssessmentDetail(@Path('assessmentId') String assessmentId);

  @GET('monthly-assessment/child/{childId}')
  Future<HttpResponse<MonthlyAssessmentChildListResponse>>
  getMonthlyAssessmentChildList(@Path('childId') String childId);

  @GET('monthly-assessment/trend/{childId}')
  Future<HttpResponse<MonthlyAssessmentTrendResponse>>
  getMonthlyAssessmentTrend(@Path('childId') String childId);

  // ==================== TESTS ENDPOINTS ====================
  @POST('tests/submit')
  Future<HttpResponse<TestResultResponse>> submitTest(
    @Body() TestSubmitRequest request,
  );

  @GET('tests/questions/{testType}')
  Future<HttpResponse<TestQuestionsResponse>> getTestQuestions(
    @Path('testType') String testType,
  );

  // ==================== HOME PROGRESS ENDPOINT ====================
  @GET('home/progress')
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

// ==================== SOCIAL AUTH DTOs ====================
class GoogleLoginRequest {
  final String idToken;

  GoogleLoginRequest({required this.idToken});

  Map<String, dynamic> toJson() => {'idToken': idToken};
}

class FacebookLoginRequest {
  final String accessToken;

  FacebookLoginRequest({required this.accessToken});

  Map<String, dynamic> toJson() => {'accessToken': accessToken};
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
          (json['plans'] as List?)
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
      todayPlan: json['today_plan'] != null
          ? Plan.fromJson(json['today_plan'])
          : null,
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
  final int? durationMinutes;
  final String? difficultyLevel;
  final int? minAge;
  final int? maxAge;
  final List<String>? steps;
  final String? benefits;
  final String? exampleActivities;
  final bool? isActive;

  ActivityItem({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    this.image,
    this.duration,
    this.durationMinutes,
    this.difficultyLevel,
    this.minAge,
    this.maxAge,
    this.steps,
    this.benefits,
    this.exampleActivities,
    this.isActive,
  });

  factory ActivityItem.fromJson(Map<String, dynamic> json) {
    final stepsJson = json['steps'];
    List<String> steps = [];
    if (stepsJson is String) {
      // Handle JSON string that needs parsing
      try {
        steps = List<String>.from(jsonDecode(stepsJson) as List);
      } catch (e) {
        steps = [];
      }
    } else if (stepsJson is List) {
      steps = List<String>.from(stepsJson);
    }

    return ActivityItem(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'],
      type: json['type'] ?? '',
      image: json['image'],
      duration: json['duration'],
      durationMinutes: json['durationMinutes'],
      difficultyLevel: json['difficultyLevel'],
      minAge: json['minAge'],
      maxAge: json['maxAge'],
      steps: steps,
      benefits: json['benefits'],
      exampleActivities: json['exampleActivities'],
      isActive: json['isActive'],
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
      materials: (json['materials'] is List
          ? (json['materials'] as List).cast<String>()
          : null),
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
    final data = json['data'] ?? json;

    // Extract user message safely
    ChatMessage userMsg;
    if (data['user_message'] != null &&
        data['user_message'] is Map<String, dynamic>) {
      userMsg = ChatMessage.fromJson(
        data['user_message'] as Map<String, dynamic>,
      );
    } else {
      userMsg = ChatMessage(message: '', timestamp: '');
    }

    // Extract bot response safely, handling string or map
    ChatMessage botMsg;
    if (data['bot_response'] != null && data['bot_response'] is String) {
      botMsg = ChatMessage(
        message: data['bot_response'] as String,
        timestamp: '',
      );
    } else if (data['bot_response'] != null &&
        data['bot_response'] is Map<String, dynamic>) {
      botMsg = ChatMessage.fromJson(
        data['bot_response'] as Map<String, dynamic>,
      );
    } else {
      botMsg = ChatMessage(
        message:
            data['message'] ??
            data['response'] ??
            data['reply'] ??
            data['text'] ??
            'Sorry, I am not able to answer right now.',
        timestamp: data['timestamp'] ?? '',
      );
    }

    return ChatbotResponse(
      userMessage: userMsg,
      botResponse: botMsg,
      conversationId:
          data['conversation_id']?.toString() ??
          data['conversationId']?.toString() ??
          '',
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
      timestamp: json['timestamp'] ?? json['createdAt'] ?? '',
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
  final String description;
  final int totalQuestions;
  final List<QuizQuestion> questions;

  QuizQuestionsResponse({
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.questions,
  });

  factory QuizQuestionsResponse.fromJson(Map<String, dynamic> json) {
    final data = json['quiz'] ?? json;
    return QuizQuestionsResponse(
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      totalQuestions: data['total_questions'] ?? 0,
      questions:
          (data['questions'] as List?)
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
  final int childId;
  final Map<String, dynamic> answers;

  QuizSubmitRequest({required this.childId, required this.answers});

  Map<String, dynamic> toJson() => {'childId': childId, 'answers': answers};
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
    // Handle both direct response and wrapped response
    final data = json['data'] is Map ? json['data'] : json;

    return QuizResultResponse(
      message: data['message'] ?? json['message'] ?? '',
      score: _parseInt(data['score'] ?? json['score']),
      feedback: data['feedback'] ?? json['feedback'] ?? '',
      resultId: _parseInt(data['result_id'] ?? json['result_id']),
    );
  }

  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
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
    'child_id': childId,
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
class ChildProgressData {
  final int assessmentImprovement;
  final double assessmentImprovementPercentage;
  final int latestScore;
  final int previousScore;
  final String trend;
  final int completedActivities;
  final int totalActivitiesAttempted;
  final double activityCompletionRate;
  final String progressSummary;

  ChildProgressData({
    required this.assessmentImprovement,
    required this.assessmentImprovementPercentage,
    required this.latestScore,
    required this.previousScore,
    required this.trend,
    required this.completedActivities,
    required this.totalActivitiesAttempted,
    required this.activityCompletionRate,
    required this.progressSummary,
  });

  factory ChildProgressData.fromJson(Map<String, dynamic> json) {
    return ChildProgressData(
      assessmentImprovement: json['assessment_improvement'] ?? 0,
      assessmentImprovementPercentage:
          ((json['assessment_improvement_percentage'] ?? 0) as num).toDouble(),
      latestScore: json['latest_score'] ?? 0,
      previousScore: json['previous_score'] ?? 0,
      trend: json['trend'] ?? '',
      completedActivities: json['completed_activities'] ?? 0,
      totalActivitiesAttempted: json['total_activities_attempted'] ?? 0,
      activityCompletionRate: ((json['activity_completion_rate'] ?? 0.0) as num)
          .toDouble(),
      progressSummary: json['progress_summary'] ?? '',
    );
  }
}

class HomeProgressResponse {
  final ChildProgressData progress;
  final int statusCode;

  HomeProgressResponse({required this.progress, required this.statusCode});

  factory HomeProgressResponse.fromJson(Map<String, dynamic> json) {
    return HomeProgressResponse(
      progress: ChildProgressData.fromJson(json['progress'] ?? {}),
      statusCode: json['status_code'] ?? 200,
    );
  }
}

// ==================== NEW MONTHLY ASSESSMENT DTOs ====================

class MonthlyAssessmentQuestionOption {
  final String text;
  final int value;

  MonthlyAssessmentQuestionOption({required this.text, required this.value});

  factory MonthlyAssessmentQuestionOption.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentQuestionOption(
      text: json['text'] ?? '',
      value: json['value'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {'text': text, 'value': value};
}

class MonthlyAssessmentQuestion {
  final String id;
  final String text;
  final String type;
  final List<MonthlyAssessmentQuestionOption> options;

  MonthlyAssessmentQuestion({
    required this.id,
    required this.text,
    required this.type,
    required this.options,
  });

  factory MonthlyAssessmentQuestion.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentQuestion(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      type: json['type'] ?? '',
      options:
          (json['options'] as List?)
              ?.map(
                (e) => MonthlyAssessmentQuestionOption.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'text': text,
    'type': type,
    'options': options.map((e) => e.toJson()).toList(),
  };
}

class MonthlyAssessmentQuestionsGroup {
  final String title;
  final String scoringLogic;
  final Map<String, dynamic> interpretation;
  final List<MonthlyAssessmentQuestion> questions;

  MonthlyAssessmentQuestionsGroup({
    required this.title,
    required this.scoringLogic,
    required this.interpretation,
    required this.questions,
  });

  factory MonthlyAssessmentQuestionsGroup.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentQuestionsGroup(
      title: json['title'] ?? '',
      scoringLogic: json['scoring_logic'] ?? '',
      interpretation: json['interpretation'] ?? {},
      questions:
          (json['questions'] as List?)
              ?.map(
                (e) => MonthlyAssessmentQuestion.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
    );
  }
}

class MonthlyAssessmentQuestionsResponse {
  final MonthlyAssessmentQuestionsGroup questions;
  final String disorder;
  final int statusCode;

  MonthlyAssessmentQuestionsResponse({
    required this.questions,
    required this.disorder,
    required this.statusCode,
  });

  factory MonthlyAssessmentQuestionsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyAssessmentQuestionsResponse(
      questions: MonthlyAssessmentQuestionsGroup.fromJson(
        json['questions'] ?? {},
      ),
      disorder: json['disorder'] ?? '',
      statusCode: json['status_code'] ?? 200,
    );
  }
}

class MonthlyAssessmentAnswer {
  final String qId;
  final int value;

  MonthlyAssessmentAnswer({required this.qId, required this.value});

  Map<String, dynamic> toJson() => {'q_id': qId, 'value': value};
}

class SubmitMonthlyAssessmentRequest {
  final int childId;
  final String disorder;
  final List<MonthlyAssessmentAnswer> answers;

  SubmitMonthlyAssessmentRequest({
    required this.childId,
    required this.disorder,
    required this.answers,
  });

  Map<String, dynamic> toJson() => {
    'childId': childId,
    'disorder': disorder,
    'answers': answers.map((e) => e.toJson()).toList(),
  };
}

class SubmitMonthlyAssessmentResponse {
  final String message;
  final int assessmentId;
  final int currentScore;
  final int progressPercentage;
  final String trend;
  final String trendLabel;
  final String interpretation;
  final int statusCode;
  final String? error;

  SubmitMonthlyAssessmentResponse({
    required this.message,
    required this.assessmentId,
    required this.currentScore,
    required this.progressPercentage,
    required this.trend,
    required this.trendLabel,
    required this.interpretation,
    required this.statusCode,
    this.error,
  });

  factory SubmitMonthlyAssessmentResponse.fromJson(Map<String, dynamic> json) {
    return SubmitMonthlyAssessmentResponse(
      message: json['message'] ?? '',
      assessmentId: json['assessment_id'] ?? 0,
      currentScore: json['current_score'] ?? 0,
      progressPercentage: json['progress_percentage'] ?? 0,
      trend: json['trend'] ?? '',
      trendLabel: json['trend_label'] ?? '',
      interpretation: json['interpretation'] ?? '',
      statusCode: json['status_code'] ?? 200,
      error: json['error'],
    );
  }
}

class MonthlyAssessmentHistoryChild {
  final int id;
  final String name;

  MonthlyAssessmentHistoryChild({required this.id, required this.name});

  factory MonthlyAssessmentHistoryChild.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentHistoryChild(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}

class MonthlyAssessmentHistoryItem {
  final int id;
  final MonthlyAssessmentHistoryChild child;
  final String assessmentDate;
  final String monthYear;
  final int q1Focus;
  final int q2Social;
  final int q3Communication;
  final int q4Behavior;
  final int q5Learning;
  final int totalScore;
  final String resultLabel;
  final String recommendations;

  MonthlyAssessmentHistoryItem({
    required this.id,
    required this.child,
    required this.assessmentDate,
    required this.monthYear,
    required this.q1Focus,
    required this.q2Social,
    required this.q3Communication,
    required this.q4Behavior,
    required this.q5Learning,
    required this.totalScore,
    required this.resultLabel,
    required this.recommendations,
  });

  factory MonthlyAssessmentHistoryItem.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentHistoryItem(
      id: json['id'] ?? 0,
      child: MonthlyAssessmentHistoryChild.fromJson(json['child'] ?? {}),
      assessmentDate: json['assessmentDate'] ?? '',
      monthYear: json['monthYear'] ?? '',
      q1Focus: json['q1Focus'] ?? 0,
      q2Social: json['q2Social'] ?? 0,
      q3Communication: json['q3Communication'] ?? 0,
      q4Behavior: json['q4Behavior'] ?? 0,
      q5Learning: json['q5Learning'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      resultLabel: json['resultLabel'] ?? '',
      recommendations: json['recommendations'] ?? '',
    );
  }
}

class MonthlyAssessmentChartData {
  final String month;
  final int score;
  final String resultLabel;
  final String date;

  MonthlyAssessmentChartData({
    required this.month,
    required this.score,
    required this.resultLabel,
    required this.date,
  });

  factory MonthlyAssessmentChartData.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentChartData(
      month: json['month'] ?? '',
      score: json['score'] ?? 0,
      resultLabel: json['result_label'] ?? '',
      date: json['date'] ?? '',
    );
  }
}

class MonthlyAssessmentHistoryResponse {
  final List<MonthlyAssessmentHistoryItem> history;
  final List<MonthlyAssessmentChartData> chartData;
  final int totalAssessments;
  final int statusCode;

  MonthlyAssessmentHistoryResponse({
    required this.history,
    required this.chartData,
    required this.totalAssessments,
    required this.statusCode,
  });

  factory MonthlyAssessmentHistoryResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentHistoryResponse(
      history:
          (json['history'] as List?)
              ?.map(
                (e) => MonthlyAssessmentHistoryItem.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      chartData:
          (json['chart_data'] as List?)
              ?.map(
                (e) => MonthlyAssessmentChartData.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      totalAssessments: json['total_assessments'] ?? 0,
      statusCode: json['status_code'] ?? 200,
    );
  }
}

class MonthlyAssessmentSingleDetailResponse {
  final MonthlyAssessmentHistoryItem assessment;
  final int statusCode;

  MonthlyAssessmentSingleDetailResponse({
    required this.assessment,
    required this.statusCode,
  });

  factory MonthlyAssessmentSingleDetailResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyAssessmentSingleDetailResponse(
      assessment: MonthlyAssessmentHistoryItem.fromJson(
        json['assessment'] ?? {},
      ),
      statusCode: json['status_code'] ?? 200,
    );
  }
}

class MonthlyAssessmentChildItem {
  final int id;
  final String assessmentDate;
  final String monthYear;
  final int totalScore;
  final String resultLabel;

  MonthlyAssessmentChildItem({
    required this.id,
    required this.assessmentDate,
    required this.monthYear,
    required this.totalScore,
    required this.resultLabel,
  });

  factory MonthlyAssessmentChildItem.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentChildItem(
      id: json['id'] ?? 0,
      assessmentDate: json['assessmentDate'] ?? '',
      monthYear: json['monthYear'] ?? '',
      totalScore: json['totalScore'] ?? 0,
      resultLabel: json['resultLabel'] ?? '',
    );
  }
}

class MonthlyAssessmentChildListResponse {
  final int childId;
  final List<MonthlyAssessmentChildItem> assessments;
  final int total;
  final int statusCode;

  MonthlyAssessmentChildListResponse({
    required this.childId,
    required this.assessments,
    required this.total,
    required this.statusCode,
  });

  factory MonthlyAssessmentChildListResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MonthlyAssessmentChildListResponse(
      childId: json['child_id'] ?? 0,
      assessments:
          (json['assessments'] as List?)
              ?.map(
                (e) => MonthlyAssessmentChildItem.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      total: json['total'] ?? 0,
      statusCode: json['status_code'] ?? 200,
    );
  }
}

class MonthlyAssessmentTrendItem {
  final int id;
  final int totalScore;
  final String monthYear;

  MonthlyAssessmentTrendItem({
    required this.id,
    required this.totalScore,
    required this.monthYear,
  });

  factory MonthlyAssessmentTrendItem.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentTrendItem(
      id: json['id'] ?? 0,
      totalScore: json['totalScore'] ?? 0,
      monthYear: json['monthYear'] ?? '',
    );
  }
}

class MonthlyAssessmentTrendData {
  final List<MonthlyAssessmentTrendItem> assessments;
  final String trend;
  final int improvement;

  MonthlyAssessmentTrendData({
    required this.assessments,
    required this.trend,
    required this.improvement,
  });

  factory MonthlyAssessmentTrendData.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentTrendData(
      assessments:
          (json['assessments'] as List?)
              ?.map(
                (e) => MonthlyAssessmentTrendItem.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList() ??
          [],
      trend: json['trend'] ?? '',
      improvement: json['improvement'] ?? 0,
    );
  }
}

class MonthlyAssessmentTrendResponse {
  final MonthlyAssessmentTrendData data;
  final int statusCode;

  MonthlyAssessmentTrendResponse({
    required this.data,
    required this.statusCode,
  });

  factory MonthlyAssessmentTrendResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentTrendResponse(
      data: MonthlyAssessmentTrendData.fromJson(json['data'] ?? {}),
      statusCode: json['status_code'] ?? 200,
    );
  }
}

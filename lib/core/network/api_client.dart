import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

class ApiConfig {
  static const String baseUrl = 'http://10.0.2.2:8086/api';
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

import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import 'package:child_monitor_app/core/network/api_client.dart';
import 'package:child_monitor_app/core/network/token_storage.dart';

// ==================== AUTH ====================
import 'package:child_monitor_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:child_monitor_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:child_monitor_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:child_monitor_app/features/auth/domain/usecases/auth_usecases.dart';
import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';

// ==================== ARTICLES ====================
import 'package:child_monitor_app/features/articles/data/datasources/articles_remote_data_source.dart';
import 'package:child_monitor_app/features/articles/data/repositories/articles_repository_impl.dart';
import 'package:child_monitor_app/features/articles/domain/repositories/articles_repository.dart';
import 'package:child_monitor_app/features/articles/domain/usecases/articles_usecases.dart';
import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';

// ==================== TODAY PLAN ====================
import 'package:child_monitor_app/features/today_plan/data/datasources/today_plan_remote_data_source.dart';
import 'package:child_monitor_app/features/today_plan/data/repositories/today_plan_repository_impl.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/today_plan_repository.dart';
import 'package:child_monitor_app/features/today_plan/domain/usecases/today_plan_usecases.dart';
import 'package:child_monitor_app/features/today_plan/presentation/cubit/today_plan_cubit.dart';

// ==================== ACTIVITY ====================
import 'package:child_monitor_app/features/today_plan/data/datasources/activity_remote_data_source.dart';
import 'package:child_monitor_app/features/today_plan/data/repositories/activity_repository_impl.dart';
import 'package:child_monitor_app/features/today_plan/domain/repositories/activity_repository.dart';
import 'package:child_monitor_app/features/today_plan/domain/usecases/activity_usecases.dart';
import 'package:child_monitor_app/features/today_plan/presentation/cubit/activity_cubit.dart';

// ==================== HOME ====================
import 'package:child_monitor_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:child_monitor_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:child_monitor_app/features/home/data/repositories/monthly_assessment_repository_impl.dart';
import 'package:child_monitor_app/features/home/domain/repositories/home_repository.dart';
import 'package:child_monitor_app/features/home/domain/repositories/monthly_assessment_repository.dart';
import 'package:child_monitor_app/features/home/domain/usecases/get_home_data_usecase.dart'
    as child_home;
import 'package:child_monitor_app/features/home/domain/usecases/monthly_assessment_usecases.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/monthly_assessment_cubit.dart';

// ==================== PROFILE ====================
import 'package:child_monitor_app/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:child_monitor_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:child_monitor_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:child_monitor_app/features/profile/domain/usecases/profile_usecases.dart';
import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';

// ==================== NOTIFICATION ====================
import 'package:child_monitor_app/features/notification/data/data_source/notification_remote_data_source.dart';
import 'package:child_monitor_app/features/notification/data/repos/notification_repo_impl.dart';
import 'package:child_monitor_app/features/notification/domain/repos/notification_repo.dart';
import 'package:child_monitor_app/features/notification/presentation/cubit/notification_cubit.dart';

// ==================== PROGRESS ====================
import 'package:child_monitor_app/features/progress/data/datasources/progress_remote_data_source.dart';
import 'package:child_monitor_app/features/progress/data/repositories/progress_repository_impl.dart';
import 'package:child_monitor_app/features/progress/domain/repositories/progress_repository.dart';
import 'package:child_monitor_app/features/progress/domain/usecases/get_child_progress_usecase.dart';
import 'package:child_monitor_app/features/progress/presentation/cubit/progress_cubit.dart';

// ==================== CHAT ====================
import 'package:child_monitor_app/features/chat/data/datasources/chat_remote_data_source.dart';
import 'package:child_monitor_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:child_monitor_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:child_monitor_app/features/chat/presentation/cubit/chat_cubit.dart';

// ==================== TESTS ====================
import 'package:child_monitor_app/features/tests/data/datasources/tests_remote_data_source.dart';
import 'package:child_monitor_app/features/tests/data/repositories/tests_repository_impl.dart';
import 'package:child_monitor_app/features/tests/domain/repositories/tests_repository.dart';
import 'package:child_monitor_app/features/tests/domain/usecases/test_usecases.dart';
import 'package:child_monitor_app/features/tests/presentation/cubit/tests_cubit.dart';
import 'package:child_monitor_app/features/tests/presentation/bloc/test_cubit.dart';

// ==================== QUIZ ====================
import 'package:child_monitor_app/features/quiz/data/datasources/quiz_remote_data_source.dart';
import 'package:child_monitor_app/features/quiz/data/repositories/quiz_repository_impl.dart';
import 'package:child_monitor_app/features/quiz/domain/repositories/quiz_repository.dart';
import 'package:child_monitor_app/features/quiz/domain/usecases/quiz_usecases.dart';
import 'package:child_monitor_app/features/quiz/presentation/cubit/quiz_cubit.dart';

import 'package:child_monitor_app/core/managers/theme_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(SharedPreferences prefs) async {
  // ==================== Storage ====================
  // H-2: Register SharedPreferences so feature code can resolve it via DI.
  getIt.registerSingleton<SharedPreferences>(prefs);

  const flutterSecureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
  );
  getIt.registerSingleton<FlutterSecureStorage>(flutterSecureStorage);

  final tokenStorage = TokenStorage(secureStorage: flutterSecureStorage);
  getIt.registerSingleton<TokenStorage>(tokenStorage);

  // ==================== Network & HTTP ====================
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      contentType: 'application/json',
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add auth token interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        try {
          final tokenStorage = getIt<TokenStorage>();
          final token = await tokenStorage.getToken();
          if (token != null && token.isNotEmpty) {
            // Add Authorization header
            options.headers['Authorization'] = 'Bearer $token';
            // Ensure header is applied
            debugPrint(
              '🔑 [Auth] Adding token to ${options.method} ${options.path}',
            );
            debugPrint(
              '🔑 [Auth] Full headers after adding token: ${options.headers.toString()}',
            );
          } else {
            debugPrint(
              '⚠️ [Auth] NO TOKEN for ${options.method} ${options.path} - token is ${token == null ? 'NULL' : 'EMPTY'}',
            );
          }
        } catch (e, stackTrace) {
          debugPrint(
            '❌ [Auth] Error reading token: $e\n$stackTrace',
          );
        }
        return handler.next(options);
      },
      onResponse: (response, handler) async {
        if (response.statusCode == 403) {
          debugPrint(
            '🚫 [API] 403 Forbidden on ${response.requestOptions.path}',
          );
          debugPrint(
            '🚫 [API] Response headers: ${response.headers.toString()}',
          );
          debugPrint(
            '🚫 [API] Response body: ${response.data}',
          );
        }
        return handler.next(response);
      },
      onError: (error, handler) async {
        debugPrint(
          '❌ [API] ${error.response?.statusCode} on ${error.requestOptions.path}',
        );
        if (error.response?.statusCode == 401) {
          final path = error.requestOptions.path;
          final data = error.response?.data;
          bool isAiError = false;

          if (path.contains('chatbot')) {
            isAiError = true;
          } else if (data != null) {
            final dataStr = data.toString().toLowerCase();
            if (dataStr.contains('ai service') ||
                dataStr.contains('temporarily unavailable') ||
                dataStr.contains('auth_error')) {
              isAiError = true;
            }
          }

          if (!isAiError) {
            // Token expired — clear stored auth data and notify the app.
            debugPrint(
              '🚪 [Auth] 401 received — clearing token and redirecting to login.',
            );
            await getIt<TokenStorage>().clearAuth();
            // Notify the singleton AuthCubit so the UI can redirect to login.
            if (getIt.isRegistered<AuthCubit>()) {
              getIt<AuthCubit>().handleUnauthenticated();
            }
          }
        } else if (error.response?.statusCode == 403) {
          // Forbidden — user doesn't have permission to access this resource
          debugPrint(
            '🚫 [Permission] 403 Forbidden on ${error.requestOptions.path}',
          );
          debugPrint(
            '🚫 [Permission] Request headers: ${error.requestOptions.headers.toString()}',
          );
          final errorData = error.response?.data;
          String errorMessage = 'ليس لديك صلاحية للوصول إلى هذا المورد';

          if (errorData != null) {
            if (errorData is Map && errorData.containsKey('message')) {
              errorMessage = errorData['message'] ?? errorMessage;
            } else if (errorData is String) {
              errorMessage = errorData;
            }
          }

          debugPrint('📛 Permission error: $errorMessage');
        }
        return handler.next(error);
      },
    ),
  );

  getIt.registerSingleton<Dio>(dio);

  // ==================== API Client ====================
  final apiClient = ApiClient(dio, baseUrl: ApiConfig.baseUrl);
  getIt.registerSingleton<ApiClient>(apiClient);

  // ==================== Social Auth ====================
  getIt.registerSingleton<GoogleSignIn>(GoogleSignIn());
  getIt.registerSingleton<FacebookAuth>(FacebookAuth.instance);

  // ==================== Features ====================
  _setupAuthFeature();
  _setupArticlesFeature();
  _setupTodayPlanFeature();
  _setupActivityFeature();
  _setupHomeFeature();
  _setupProfileFeature();
  _setupNotificationFeature();
  _setupProgressFeature();
  _setupChatFeature();
  _setupTestsFeature();
  _setupQuizFeature();
  // Theme cubit (singleton so theme state is shared and persisted)
  getIt.registerSingleton<ThemeCubit>(ThemeCubit(prefs));
}

// ==================== AUTH Feature ====================
void _setupAuthFeature() {
  // Data Sources
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: getIt<AuthRemoteDataSource>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => SignupUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LoginUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LogoutUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => RequestPasswordResetUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => VerifyOtpUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => ConfirmPasswordResetUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LoginWithGoogleUseCase(repository: getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton(
    () => LoginWithFacebookUseCase(repository: getIt<AuthRepository>()),
  );

  // Cubit (lazySingleton — single source of auth truth across the whole app)
  getIt.registerLazySingleton<AuthCubit>(
    () => AuthCubit(
      signupUseCase: getIt<SignupUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      requestPasswordResetUseCase: getIt<RequestPasswordResetUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      confirmPasswordResetUseCase: getIt<ConfirmPasswordResetUseCase>(),
      loginWithGoogleUseCase: getIt<LoginWithGoogleUseCase>(),
      loginWithFacebookUseCase: getIt<LoginWithFacebookUseCase>(),
      googleSignIn: getIt<GoogleSignIn>(),
      facebookAuth: getIt<FacebookAuth>(),
      tokenStorage: getIt<TokenStorage>(),
    ),
  );
}

// ==================== ARTICLES Feature ====================
void _setupArticlesFeature() {
  // Data Sources
  getIt.registerLazySingleton<ArticlesRemoteDataSource>(
    () => ArticlesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ArticlesRepository>(
    () => ArticlesRepositoryImpl(
      remoteDataSource: getIt<ArticlesRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetAllArticlesUseCase(repository: getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetArticleDetailUseCase(repository: getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetArticlesByCategoryUseCase(repository: getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddArticleToFavoriteUseCase(repository: getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton(
    () => RemoveArticleFromFavoriteUseCase(
      repository: getIt<ArticlesRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetFavoriteArticlesUseCase(repository: getIt<ArticlesRepository>()),
  );
  getIt.registerLazySingleton(
    () => CheckIfArticleIsFavoriteUseCase(
      repository: getIt<ArticlesRepository>(),
    ),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider, must be shared.
  getIt.registerLazySingleton<ArticlesCubit>(
    () => ArticlesCubit(
      getAllArticlesUseCase: getIt<GetAllArticlesUseCase>(),
      getArticleDetailUseCase: getIt<GetArticleDetailUseCase>(),
      getArticlesByCategoryUseCase: getIt<GetArticlesByCategoryUseCase>(),
      addArticleToFavoriteUseCase: getIt<AddArticleToFavoriteUseCase>(),
      removeArticleFromFavoriteUseCase:
          getIt<RemoveArticleFromFavoriteUseCase>(),
      getFavoriteArticlesUseCase: getIt<GetFavoriteArticlesUseCase>(),
      checkIfArticleIsFavoriteUseCase: getIt<CheckIfArticleIsFavoriteUseCase>(),
    ),
  );
}

// ==================== TODAY PLAN Feature ====================
void _setupTodayPlanFeature() {
  // Data Sources
  getIt.registerLazySingleton<TodayPlanRemoteDataSource>(
    () => TodayPlanRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<TodayPlanRepository>(
    () => TodayPlanRepositoryImpl(
      remoteDataSource: getIt<TodayPlanRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetTodayPlanUseCase(repository: getIt<TodayPlanRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteTodayPlanUseCase(repository: getIt<TodayPlanRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetPlanHistoryUseCase(repository: getIt<TodayPlanRepository>()),
  );
  // H-9: Renamed to GetTodayPlanHomeDataUseCase to avoid collision with home feature.
  getIt.registerLazySingleton(
    () => GetTodayPlanHomeDataUseCase(repository: getIt<TodayPlanRepository>()),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<TodayPlanCubit>(
    () => TodayPlanCubit(
      getTodayPlanUseCase: getIt<GetTodayPlanUseCase>(),
      completeTodayPlanUseCase: getIt<CompleteTodayPlanUseCase>(),
      getPlanHistoryUseCase: getIt<GetPlanHistoryUseCase>(),
      getHomeDataUseCase: getIt<GetTodayPlanHomeDataUseCase>(),
    ),
  );
}

// ==================== ACTIVITY Feature ====================
void _setupActivityFeature() {
  // Data Sources
  getIt.registerLazySingleton<ActivityRemoteDataSource>(
    () => ActivityRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ActivityRepository>(
    () => ActivityRepositoryImpl(
      remoteDataSource: getIt<ActivityRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetAllActivitiesUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetActivitiesByTypeUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetActivitiesForChildUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetActivityDetailUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => CompleteActivityUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetActivityStatsUseCase(repository: getIt<ActivityRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetRecommendedActivitiesUseCase(
      repository: getIt<ActivityRepository>(),
    ),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<ActivityCubit>(
    () => ActivityCubit(
      getAllActivitiesUseCase: getIt<GetAllActivitiesUseCase>(),
      getActivitiesByTypeUseCase: getIt<GetActivitiesByTypeUseCase>(),
      getActivitiesForChildUseCase: getIt<GetActivitiesForChildUseCase>(),
      getActivityDetailUseCase: getIt<GetActivityDetailUseCase>(),
      completeActivityUseCase: getIt<CompleteActivityUseCase>(),
      getActivityStatsUseCase: getIt<GetActivityStatsUseCase>(),
      getRecommendedActivitiesUseCase: getIt<GetRecommendedActivitiesUseCase>(),
    ),
  );
}

// ==================== HOME Feature ====================
void _setupHomeFeature() {
  // Data Sources
  getIt.registerLazySingleton<HomeRemoteDataSource>(
    () => HomeRemoteDataSourceImpl(getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<HomeRepository>(
    () => HomeRepositoryImpl(getIt<HomeRemoteDataSource>()),
  );
  // C-5: MonthlyAssessment repository — clean architecture chain now complete.
  getIt.registerLazySingleton<MonthlyAssessmentRepository>(
    () => MonthlyAssessmentRepositoryImpl(apiClient: getIt<ApiClient>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => child_home.GetHomeDataUseCase(getIt<HomeRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMonthlyAssessmentQuestionsUseCase(
      repository: getIt<MonthlyAssessmentRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => SubmitMonthlyAssessmentUseCase(
      repository: getIt<MonthlyAssessmentRepository>(),
    ),
  );
  getIt.registerLazySingleton(
    () => GetMonthlyAssessmentHistoryUseCase(
      repository: getIt<MonthlyAssessmentRepository>(),
    ),
  );

  // Cubits
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<child_home.GetHomeDataUseCase>()),
  );
  // C-5: Cubit now receives use cases, not ApiClient directly.
  getIt.registerFactory<MonthlyAssessmentCubit>(
    () => MonthlyAssessmentCubit(
      getQuestionsUseCase: getIt<GetMonthlyAssessmentQuestionsUseCase>(),
      submitAssessmentUseCase: getIt<SubmitMonthlyAssessmentUseCase>(),
      getHistoryUseCase: getIt<GetMonthlyAssessmentHistoryUseCase>(),
    ),
  );
}

// ==================== PROFILE Feature ====================
void _setupProfileFeature() {
  // Data Sources
  getIt.registerLazySingleton<ProfileRemoteDataSource>(
    () => ProfileRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      remoteDataSource: getIt<ProfileRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetUserProfileUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateUserProfileUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteAccountUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetMyChildrenUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetChildDetailUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => AddChildUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => UpdateChildUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => DeleteChildUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetSettingsUseCase(repository: getIt<ProfileRepository>()),
  );
  getIt.registerLazySingleton(
    () => ChangePasswordUseCase(repository: getIt<ProfileRepository>()),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<ProfileCubit>(
    () => ProfileCubit(
      getUserProfileUseCase: getIt<GetUserProfileUseCase>(),
      updateUserProfileUseCase: getIt<UpdateUserProfileUseCase>(),
      deleteAccountUseCase: getIt<DeleteAccountUseCase>(),
      getMyChildrenUseCase: getIt<GetMyChildrenUseCase>(),
      getChildDetailUseCase: getIt<GetChildDetailUseCase>(),
      addChildUseCase: getIt<AddChildUseCase>(),
      updateChildUseCase: getIt<UpdateChildUseCase>(),
      deleteChildUseCase: getIt<DeleteChildUseCase>(),
      getSettingsUseCase: getIt<GetSettingsUseCase>(),
      changePasswordUseCase: getIt<ChangePasswordUseCase>(),
    ),
  );
}

// ==================== NOTIFICATION Feature ====================
void _setupNotificationFeature() {
  // Data Sources
  getIt.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(),
  );

  // Repositories
  getIt.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(
      remoteDataSource: getIt<NotificationRemoteDataSource>(),
    ),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<NotificationCubit>(
    () => NotificationCubit(repository: getIt<NotificationRepository>()),
  );
}

// ==================== PROGRESS Feature ====================
void _setupProgressFeature() {
  // Data Sources
  // C-6 Proper Fix: Uses the existing ProgressRemoteDataSource (Retrofit client)
  // instead of the intermediate shim. Requires Dio from the container.
  getIt.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSource(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(
      remoteDataSource: getIt<ProgressRemoteDataSource>(),
    ),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetChildProgressUseCase(getIt<ProgressRepository>()),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<ProgressCubit>(
    () => ProgressCubit(
      getChildProgressUseCase: getIt<GetChildProgressUseCase>(),
    ),
  );
}

// ==================== CHAT Feature ====================
void _setupChatFeature() {
  // Data Sources
  getIt.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: getIt<ChatRemoteDataSource>()),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<ChatCubit>(
    () => ChatCubit(repository: getIt<ChatRepository>()),
  );
}

// ==================== QUIZ Feature ====================
void _setupQuizFeature() {
  // Data Sources
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<QuizRepository>(
    () => QuizRepositoryImpl(remoteDataSource: getIt<QuizRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetQuizQuestionsUseCase(repository: getIt<QuizRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubmitQuizUseCase(repository: getIt<QuizRepository>()),
  );

  // Cubit
  getIt.registerFactory<QuizCubit>(
    () => QuizCubit(
      getQuizQuestionsUseCase: getIt<GetQuizQuestionsUseCase>(),
      submitQuizUseCase: getIt<SubmitQuizUseCase>(),
    ),
  );
}

// ==================== TESTS Feature ====================
void _setupTestsFeature() {
  // Data Sources
  getIt.registerLazySingleton<TestsRemoteDataSource>(
    () => TestsRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
  );

  // Repositories
  getIt.registerLazySingleton<TestsRepository>(
    () => TestsRepositoryImpl(remoteDataSource: getIt<TestsRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetTestQuestionsUseCase(repository: getIt<TestsRepository>()),
  );
  getIt.registerLazySingleton(
    () => SubmitTestUseCase(repository: getIt<TestsRepository>()),
  );
  getIt.registerLazySingleton(
    () => GetTestHistoryUseCase(repository: getIt<TestsRepository>()),
  );

  // M-2: lazySingleton — lives in root MultiBlocProvider.
  getIt.registerLazySingleton<TestsCubit>(
    () => TestsCubit(
      getTestQuestionsUseCase: getIt<GetTestQuestionsUseCase>(),
      submitTestUseCase: getIt<SubmitTestUseCase>(),
      getTestHistoryUseCase: getIt<GetTestHistoryUseCase>(),
    ),
  );
  // M-2: lazySingleton — TestCubit is also in root MultiBlocProvider.
  getIt.registerLazySingleton<TestCubit>(
    () => TestCubit(
      getTestQuestionsUseCase: getIt<GetTestQuestionsUseCase>(),
      submitTestUseCase: getIt<SubmitTestUseCase>(),
      addChildUseCase: getIt<AddChildUseCase>(),
    ),
  );
}

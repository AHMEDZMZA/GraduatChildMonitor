import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

// ==================== HOME ====================
import 'package:child_monitor_app/features/home/data/datasources/home_remote_data_source.dart';
import 'package:child_monitor_app/features/home/data/repositories/home_repository_impl.dart';
import 'package:child_monitor_app/features/home/domain/repositories/home_repository.dart';
import 'package:child_monitor_app/features/home/domain/usecases/get_home_data_usecase.dart'
    as child_home;
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';

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
import 'package:child_monitor_app/core/managers/theme_cubit.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator(SharedPreferences prefs) async {
  // ==================== Storage ====================
  const flutterSecureStorage = FlutterSecureStorage();
  getIt.registerSingleton<FlutterSecureStorage>(flutterSecureStorage);

  final tokenStorage = TokenStorage(secureStorage: flutterSecureStorage);
  getIt.registerSingleton<TokenStorage>(tokenStorage);

  // ==================== Network & HTTP ====================
  final dio = Dio(
    BaseOptions(
      baseUrl: ApiConfig.baseUrl,
      connectTimeout: ApiConfig.connectTimeout,
      receiveTimeout: ApiConfig.receiveTimeout,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  // Add auth token interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        final token = await getIt<TokenStorage>().getToken();
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          // Token expired - clear stored auth data
          await getIt<TokenStorage>().clearAuth();
        }
        return handler.next(error);
      },
    ),
  );

  getIt.registerSingleton<Dio>(dio);

  // ==================== API Client ====================
  final apiClient = ApiClient(dio);
  getIt.registerSingleton<ApiClient>(apiClient);

  // ==================== Features ====================
  _setupAuthFeature();
  _setupArticlesFeature();
  _setupTodayPlanFeature();
  _setupHomeFeature();
  _setupProfileFeature();
  _setupNotificationFeature();
  _setupProgressFeature();
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

  // Cubit (factory so each screen gets a fresh instance)
  getIt.registerFactory<AuthCubit>(
    () => AuthCubit(
      signupUseCase: getIt<SignupUseCase>(),
      loginUseCase: getIt<LoginUseCase>(),
      logoutUseCase: getIt<LogoutUseCase>(),
      requestPasswordResetUseCase: getIt<RequestPasswordResetUseCase>(),
      verifyOtpUseCase: getIt<VerifyOtpUseCase>(),
      confirmPasswordResetUseCase: getIt<ConfirmPasswordResetUseCase>(),
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

  // Cubit
  getIt.registerFactory<ArticlesCubit>(
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
  getIt.registerLazySingleton(
    () => GetHomeDataUseCase(repository: getIt<TodayPlanRepository>()),
  );

  // Cubit
  getIt.registerFactory<TodayPlanCubit>(
    () => TodayPlanCubit(
      getTodayPlanUseCase: getIt<GetTodayPlanUseCase>(),
      completeTodayPlanUseCase: getIt<CompleteTodayPlanUseCase>(),
      getPlanHistoryUseCase: getIt<GetPlanHistoryUseCase>(),
      getHomeDataUseCase: getIt<GetHomeDataUseCase>(),
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

  // Use Cases
  getIt.registerLazySingleton(
    () => child_home.GetHomeDataUseCase(getIt<HomeRepository>()),
  );

  // Cubit
  getIt.registerFactory<HomeCubit>(
    () => HomeCubit(getIt<child_home.GetHomeDataUseCase>()),
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

  // Cubit
  getIt.registerFactory<ProfileCubit>(
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

  // Cubit
  getIt.registerFactory<NotificationCubit>(
    () => NotificationCubit(repository: getIt<NotificationRepository>()),
  );
}

// ==================== PROGRESS Feature ====================
void _setupProgressFeature() {
  // Data Sources
  getIt.registerLazySingleton<ProgressRemoteDataSource>(
    () => ProgressRemoteDataSource(getIt<Dio>()),
  );

  // Repositories
  getIt.registerLazySingleton<ProgressRepository>(
    () => ProgressRepositoryImpl(getIt<ProgressRemoteDataSource>()),
  );

  // Use Cases
  getIt.registerLazySingleton(
    () => GetChildProgressUseCase(getIt<ProgressRepository>()),
  );

  // Cubit
  getIt.registerFactory<ProgressCubit>(
    () => ProgressCubit(
      getChildProgressUseCase: getIt<GetChildProgressUseCase>(),
    ),
  );
}

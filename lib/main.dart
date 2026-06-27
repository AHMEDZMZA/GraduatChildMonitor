import 'package:child_monitor_app/core/di/service_locator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:child_monitor_app/features/auth/presentation/state/auth_state.dart';
import 'package:child_monitor_app/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:child_monitor_app/core/navigation/app_routes.dart';
import 'package:child_monitor_app/core/navigation/routing_manager.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';
import 'package:child_monitor_app/features/today_plan/presentation/cubit/today_plan_cubit.dart';
import 'package:child_monitor_app/features/today_plan/presentation/cubit/activity_cubit.dart';
import 'package:child_monitor_app/features/progress/presentation/cubit/progress_cubit.dart';
import 'package:child_monitor_app/features/chat/presentation/cubit/chat_cubit.dart';
import 'package:child_monitor_app/features/tests/presentation/cubit/tests_cubit.dart';
import 'package:child_monitor_app/features/tests/presentation/bloc/test_cubit.dart';
import 'package:child_monitor_app/features/notification/presentation/cubit/notification_cubit.dart';
// H-3: Consolidated — LocalNotificationService is the single notification service.
// NotificationHelper has been removed from startup init.
import 'package:child_monitor_app/core/managers/local_notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/managers/theme_cubit.dart';
import 'core/managers/app_theme.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Timezone init only once — LocalNotificationService uses this.
  tz.initializeTimeZones();

  final prefs = await SharedPreferences.getInstance();
  await setupServiceLocator(prefs);

  await EasyLocalization.ensureInitialized();

  // H-3: Single notification service — no more double-init.
  final notificationService = LocalNotificationService();
  await notificationService.initializeNotifications();
  await notificationService.scheduleDailyNotifications();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
        BlocProvider<ArticlesCubit>(create: (_) => getIt<ArticlesCubit>()),
        BlocProvider<TodayPlanCubit>(create: (_) => getIt<TodayPlanCubit>()),
        BlocProvider<ActivityCubit>(create: (_) => getIt<ActivityCubit>()),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<ProgressCubit>(create: (_) => getIt<ProgressCubit>()),
        BlocProvider<ChatCubit>(create: (_) => getIt<ChatCubit>()),
        BlocProvider<TestsCubit>(create: (_) => getIt<TestsCubit>()),
        BlocProvider<TestCubit>(create: (_) => getIt<TestCubit>()),
        BlocProvider<NotificationCubit>(
          create: (_) => getIt<NotificationCubit>(),
        ),
        BlocProvider<ThemeCubit>(create: (_) => getIt<ThemeCubit>()),
      ],
      // C-4: Global AuthUnauthenticated listener — when the network layer
      // detects an expired token (401), it calls AuthCubit.handleUnauthenticated()
      // which emits AuthUnauthenticated. This listener catches it at the root
      // and redirects to login from anywhere in the app.
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              AppRoutes.login,
              (route) => false,
            );
          }
        },
        child: BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return ScreenUtilInit(
              designSize: const Size(375, 812),
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (context, child) {
                return MaterialApp(
                  localizationsDelegates: context.localizationDelegates,
                  supportedLocales: context.supportedLocales,
                  locale: context.locale,
                  theme: AppTheme.lightTheme(),
                  darkTheme: AppTheme.darkTheme(),
                  themeMode: themeMode,
                  debugShowCheckedModeBanner: false,
                  initialRoute: AppRoutes.splash,
                  onGenerateRoute: RoutingManager.generateRoute,
                );
              },
            );
          },
        ),
      ),
    );
  }
}

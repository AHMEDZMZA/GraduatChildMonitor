import 'package:flutter/material.dart';

// Core
import '../../features/splash/presentation/view/splash_view.dart';
import '../../features/onboarding/presentation/view/onboarding_view.dart';
import '../../features/bottom_nav/presentation/views/app_bottom_nav_view.dart';
import '../../features/home/presentation/view/home_view.dart';

// Auth
import '../../features/auth/presentation/views/login_view.dart';
import '../../features/auth/presentation/views/signup_view.dart';
import '../../features/auth/presentation/views/reset_password_request_view.dart';
import '../../features/auth/presentation/views/reset_password_verify_view.dart';
import '../../features/auth/presentation/views/reset_password_confirm_view.dart';
import '../../features/auth/presentation/views/reset_passowrd_finished_view.dart';
import '../../features/auth/presentation/views/success_otp_verify_view.dart';
// Notification
import '../../features/notification/presentation/view/notification_view.dart';
import '../../features/notification/presentation/view/single_notification_screen.dart';
import '../../features/notification/data/model/notification_item_model.dart';
// Articles
import '../../features/articles/presentation/view/articles_view.dart';
import '../../features/articles/presentation/view/article_details_view.dart';
import '../../features/articles/presentation/view/favourites_view.dart';

// Profile
import '../../features/profile/presentation/view/profile_view.dart';
import '../../features/profile/presentation/view/children_profiles_view.dart';
import '../../features/profile/presentation/view/edit_child_profile_view.dart';
import '../../features/profile/presentation/view/edit_profile_view.dart';
import '../../features/profile/presentation/view/notification_setting_view.dart';
import '../../features/profile/presentation/view/password_manager_view.dart';
import '../../features/profile/presentation/view/settings_view.dart';

// Today Plan
import '../../features/today_plan/presentation/views/today_view.dart';
import '../../features/today_plan/presentation/views/activity_details_view.dart';
import '../../features/today_plan/presentation/views/activity_steps_view.dart';
import '../../features/today_plan/presentation/views/activity_done_view.dart';
import '../../features/today_plan/presentation/views/parent_child_activities_view.dart';
import '../../features/today_plan/presentation/views/physical_activities_view.dart';

// Quiz
import '../../features/quiz/presentation/view/interactive_quiz_today_view.dart';
import '../../features/quiz/presentation/view/result_quiz_view.dart';
import '../../features/quiz/presentation/view/test_quiz_view.dart';

// Home / Progress Tracker
import '../../features/home/presentation/view/progress_tracker_view.dart';
import '../../features/home/presentation/view/monthly_progress_details_view.dart';
import '../../features/home/presentation/view/monthly_progress_view.dart';
import '../../features/home/presentation/view/progress_test_view.dart';
import '../../features/home/presentation/view/result_progress_view.dart';
import '../../features/progress/presentation/view/statistics_view.dart';

// Tests
import '../../features/tests/presentation/view/add_child_data_view.dart';
import '../../features/tests/presentation/view/select_test_view.dart';
import '../../features/tests/presentation/view/known_condition_view.dart';
import '../../features/tests/presentation/view/test_questions_known_view.dart';
import '../../features/tests/presentation/view/test_questions_unknown_view.dart';
import '../../features/tests/presentation/view/test_complete_view.dart';
import '../../features/tests/domain/entities/child_entity.dart';
import '../../features/tests/domain/entities/test_submission_entity.dart';

// App Routes
import 'app_routes.dart';

// Models
import '../../features/articles/domain/entities/article_entity.dart';
import '../../features/today_plan/data/activity_model.dart';
import '../../features/home/data/model.dart';

class RoutingManager {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // Core
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => const SplashView());
      case AppRoutes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingView());
      case AppRoutes.mainNav:
        return MaterialPageRoute(builder: (_) => const AppBottomNavBarView());
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => const HomeView());

      // Auth
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => const LoginView());
      case AppRoutes.signup:
        return MaterialPageRoute(builder: (_) => const SignupView());
      case AppRoutes.resetPasswordRequest:
        return MaterialPageRoute(builder: (_) => const ResetPasswordRequestView());
      case AppRoutes.resetPasswordVerify:
        if (settings.arguments is String) {
          return MaterialPageRoute(
            builder: (_) => ResetPasswordVerifyView(
              email: settings.arguments as String,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.resetPasswordConfirm:
        if (settings.arguments is Map<String, String>) {
          final args = settings.arguments as Map<String, String>;
          return MaterialPageRoute(
            builder: (_) => ResetPasswordConfirmView(
              email: args['email'] ?? '',
              otp: args['otp'] ?? '',
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.resetPasswordFinished:
        return MaterialPageRoute(builder: (_) => const ResetPassowrdFinishedView());
      case AppRoutes.successOtpVerify:
        return MaterialPageRoute(builder: (_) => const SuccessOtpVerifyView());

      // Articles
      case AppRoutes.articles:
        return MaterialPageRoute(builder: (_) => const ArticlesView());
      case AppRoutes.articleDetails:
        if (settings.arguments is ArticleEntity) {
          return MaterialPageRoute(
            builder: (_) => ArticleDetailsView(
              article: settings.arguments as ArticleEntity,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.favourites:
        return MaterialPageRoute(builder: (_) => const FavouritesView());

      // Profile
      case AppRoutes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case AppRoutes.childrenProfiles:
        return MaterialPageRoute(builder: (_) => const ChildrenProfilesView());
      case AppRoutes.editChildProfile:
        // Optional parameter for editing an existing child
        if (settings.arguments == null || settings.arguments is String) {
          return MaterialPageRoute(
            builder: (_) => EditChildProfileView(
              childId: settings.arguments as String?,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileView());
      case AppRoutes.notificationSettings:
        return MaterialPageRoute(builder: (_) => const NotificationSettingView());
      case AppRoutes.passwordManager:
        return MaterialPageRoute(builder: (_) => const PasswordManagerView());
      case AppRoutes.settings:
        return MaterialPageRoute(builder: (_) => const SettingsView());

      // Today Plan
      case AppRoutes.todayPlan:
        return MaterialPageRoute(builder: (_) => const TodayView());
      case AppRoutes.activityDetails:
        if (settings.arguments is ActivityModel) {
          return MaterialPageRoute<bool>(
            builder: (_) => ActivityDetailsView(
              activity: settings.arguments as ActivityModel,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.activitySteps:
        if (settings.arguments is ActivityModel) {
          return MaterialPageRoute<bool>(
            builder: (_) => ActivityStepsView(
              activity: settings.arguments as ActivityModel,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.activityDone:
        if (settings.arguments is Map<String, dynamic>) {
          final args = settings.arguments as Map<String, dynamic>;
          return MaterialPageRoute<bool>(
            builder: (_) => ActivityDoneView(
              title: args['title'] as String,
              image: args['image'] as String,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.interactiveQuizToday:
        return MaterialPageRoute(builder: (_) => const InteractiveQuizTodayView());
      case AppRoutes.parentChildActivities:
        return MaterialPageRoute(builder: (_) => const ParentChildActivitiesView());
      case AppRoutes.physicalActivities:
        return MaterialPageRoute(builder: (_) => const PhysicalActivitiesView());
      case AppRoutes.resultQuiz:
        return MaterialPageRoute(builder: (_) => const ResultQuizView());
      case AppRoutes.testQuiz:
        return MaterialPageRoute(builder: (_) => const TestQuizView());

      // Progress Tracker
      case AppRoutes.progressTracker:
        return MaterialPageRoute(builder: (_) => const ProgressTrackerView());
      case AppRoutes.monthlyProgressDetails:
        if (settings.arguments is MonthlyProgressModel) {
          return MaterialPageRoute(
            builder: (_) => MonthlyProgressDetailsView(
              item: settings.arguments as MonthlyProgressModel,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.monthlyProgress:
        return MaterialPageRoute(builder: (_) => const MonthlyProgressView());
      case AppRoutes.progressTest:
        return MaterialPageRoute(builder: (_) => const ProgressTestView());
      case AppRoutes.resultProgress:
        return MaterialPageRoute(builder: (_) => const ResultProgressView());
      case AppRoutes.statistics:
        if (settings.arguments is String) {
          return MaterialPageRoute(
            builder: (_) => StatisticsView(
              childId: settings.arguments as String,
            ),
          );
        }
        return _errorRoute(settings);

      // Tests
      case AppRoutes.addChildData:
        return MaterialPageRoute(builder: (_) => const AddChildDataView());
      case AppRoutes.selectTest:
        if (settings.arguments is ChildEntity) {
          return MaterialPageRoute(
            builder: (_) => SelectTestView(
              child: settings.arguments as ChildEntity,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.knownCondition:
        if (settings.arguments is ChildEntity) {
          return MaterialPageRoute(
            builder: (_) => KnownConditionView(
              child: settings.arguments as ChildEntity,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.testQuestionsKnown:
        if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (_) => TestQuestionsKnownView(
              child: args['child'] as ChildEntity,
              testType: args['testType'] as String,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.testQuestionsUnknown:
        if (settings.arguments is Map) {
          final args = settings.arguments as Map;
          return MaterialPageRoute(
            builder: (_) => TestQuestionsUnknownView(
              child: args['child'] as ChildEntity,
              selectedTypes: args['selectedTypes'] as List<String>,
            ),
          );
        }
        return _errorRoute(settings);
      case AppRoutes.testComplete:
        if (settings.arguments is TestResultEntity) {
          return MaterialPageRoute(
            builder: (_) => TestCompleteView(
              result: settings.arguments as TestResultEntity,
            ),
          );
        }
        return _errorRoute(settings);

      // Notification
      case AppRoutes.notification:
        return MaterialPageRoute(builder: (_) => const NotificationView());
      case AppRoutes.singleNotification:
        if (settings.arguments is NotificationItemModel) {
          return MaterialPageRoute(
            builder: (_) => SingleNotificationScreen(
              item: settings.arguments as NotificationItemModel,
            ),
          );
        }
        return MaterialPageRoute(builder: (_) => const SingleNotificationScreen());

      default:
        return _errorRoute(settings);
    }
  }

  static Route<dynamic> _errorRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        body: Center(
          child: Text('No route defined for ${settings.name} or invalid arguments'),
        ),
      ),
    );
  }
}

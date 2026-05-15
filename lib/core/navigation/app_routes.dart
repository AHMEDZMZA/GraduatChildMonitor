class AppRoutes {
  // Core
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String mainNav = '/mainNav';
  static const String home = '/home'; // Direct Home View if needed

  // Auth
  static const String login = '/login';
  static const String signup = '/signup';
  static const String resetPasswordRequest = '/resetPasswordRequest';
  static const String resetPasswordVerify = '/resetPasswordVerify';
  static const String resetPasswordConfirm = '/resetPasswordConfirm';
  static const String resetPasswordFinished = '/resetPasswordFinished';
  static const String successOtpVerify = '/successOtpVerify';
  static const String notification = '/notification';
  static const String singleNotification = '/singleNotification';

  // Articles
  static const String articles = '/articles';
  static const String articleDetails = '/articleDetails';
  static const String favourites = '/favourites';

  // Profile
  static const String profile = '/profile';
  static const String childrenProfiles = '/childrenProfiles';
  static const String editChildProfile = '/editChildProfile';
  static const String editProfile = '/editProfile';
  static const String notificationSettings = '/notificationSettings';
  static const String passwordManager = '/passwordManager';
  static const String settings = '/settings';

  // Today Plan
  static const String todayPlan = '/todayPlan';
  static const String activityDetails = '/activityDetails';
  static const String activitySteps = '/activitySteps';
  static const String activityDone = '/activityDone';
  static const String interactiveQuizToday = '/interactiveQuizToday';
  static const String parentChildActivities = '/parentChildActivities';
  static const String physicalActivities = '/physicalActivities';
  static const String resultQuiz = '/resultQuiz';
  static const String testQuiz = '/testQuiz';

  // Home / Progress Tracker
  static const String progressTracker = '/progressTracker';
  static const String monthlyProgressDetails = '/monthlyProgressDetails';
  static const String monthlyProgress = '/monthlyProgress';
  static const String progressTest = '/progressTest';
  static const String resultProgress = '/resultProgress';
  static const String statistics = '/statistics';
}

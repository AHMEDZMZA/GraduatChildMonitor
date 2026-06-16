# GraduatChildMonitor — Full Professional Audit & Implementation Plan

## Background

This is a Flutter child-development-monitoring app with ~13 features (auth, home, today_plan, articles, chat, profile, progress, quiz, tests, notification, onboarding, splash, bottom_nav).  
The architecture follows **Clean Architecture** with `data / domain / presentation` layers per feature, **Cubit/Bloc** state management, **Retrofit + Dio** for networking, and **GetIt** for dependency injection.

---

## PHASE 1 — FULL PROJECT AUDIT

---

### 🔴 CRITICAL Issues

---

#### C-1 · `google-services.json` is a Placeholder
- **Severity:** Critical  
- **Root Cause:** `android/app/google-services.json` is a dummy JSON with a comment (`"_comment": "PLACEHOLDER - REPLACE WITH YOUR ACTUAL google-services.json"`). It uses `"type": "service_account"` instead of the correct `"type": "service_account"` Firebase format.  
- **Impact:** Google Sign-In **will crash** at runtime when the Firebase SDK tries to read `client_id`. The app will fail to build with `google-services` Gradle plugin or produce a runtime `FirebaseApp is not initialized` error.  
- **Affected Files:** `android/app/google-services.json`  
- **Fix:** Replace with the real Firebase project's `google-services.json`. Until then the Google sign-in button should be disabled at build-time.

---

#### C-2 · Hardcoded Local IP Address (`192.168.1.14`) in Production Code
- **Severity:** Critical  
- **Root Cause:** `ApiConfig.baseUrl = 'http://192.168.1.14:8086/api/'` is hardcoded as a compile-time constant in `api_client.dart` line 8.  
- **Impact:**  
  - Breaks **all** network calls when the device is not on the same LAN.  
  - Uses plain **HTTP** (not HTTPS), exposing tokens and data to interception.  
  - There is no environment configuration (dev / staging / prod).  
- **Affected Files:** `lib/core/network/api_client.dart` (line 8)  
- **Fix:** Move base URL to a config file / env variable / `--dart-define`. Use HTTPS for production.

---

#### C-3 · `AuthCubit` is Registered as `Factory` but Provided Globally at Root
- **Severity:** Critical  
- **Root Cause:** In `service_locator.dart` line 215, `AuthCubit` is `registerFactory`, meaning each `getIt<AuthCubit>()` call creates a **new instance**. In `main.dart` line 47, a fresh instance is created and placed at the root `MultiBlocProvider`. Every `BlocListener<AuthCubit>` in login/signup views will share the **root** instance, but any call to `context.read<AuthCubit>()` inside those screens will look up the **same** root instance, which is correct — until a new page tries to `getIt<AuthCubit>()` again and gets a different instance. This creates silent state divergence.  
- **Impact:** Any feature that obtains a new `AuthCubit` via GetIt (e.g., after navigation) will have a detached state machine. Token state and auth events may not propagate.  
- **Affected Files:** `lib/core/di/service_locator.dart` (line 215), `lib/main.dart` (lines 47–60)  
- **Fix:** Register `AuthCubit` as `registerLazySingleton`, since it must be a single source of truth for auth state across the entire app lifetime.

---

#### C-4 · 401 Interceptor Clears Auth Without Navigating to Login
- **Severity:** Critical  
- **Root Cause:** In `service_locator.dart` lines 120–142, on a 401 the interceptor calls `tokenStorage.clearAuth()` but **does NOT emit a state change or trigger navigation**. The user's token is deleted silently, but they remain on whatever screen they were on. The next API call returns 401 again infinitely, and the UI never forces re-login.  
- **Impact:** The app enters a broken state where the user appears logged in but all API calls fail silently.  
- **Affected Files:** `lib/core/di/service_locator.dart` (lines 120–142)  
- **Fix:** Emit an unauthenticated event on the singleton `AuthCubit` (after C-3 is fixed) and navigate to the login screen.

---

#### C-5 · `MonthlyAssessmentCubit` Bypasses Clean Architecture — Direct `ApiClient` Dependency in Presentation Layer
- **Severity:** Critical  
- **Root Cause:** `monthly_assessment_cubit.dart` takes `ApiClient` directly in its constructor (line 7) and calls network methods directly (lines 14, 40, 57). This is a direct violation of Clean Architecture — the presentation layer should never reference the network/data layer.  
- **Impact:** Untestable, tightly coupled, breaks the architecture contract. Any API change directly breaks the cubit.  
- **Affected Files:** `lib/features/home/presentation/cubit/monthly_assessment_cubit.dart`  
- **Fix:** Create a proper `MonthlyAssessmentRepository` → `MonthlyAssessmentUseCase` chain. The cubit should only call use cases.

---

#### C-6 · `ProgressRepositoryImpl` Bypasses Data Source Layer
- **Severity:** Critical  
- **Root Cause:** In `service_locator.dart` line 493, `ProgressRepositoryImpl` is constructed with `getIt<ApiClient>()` directly — skipping the `ProgressRemoteDataSource` abstraction entirely.  
- **Impact:** Same as C-5. No abstraction, not testable. Any progress-related data source refactor is impossible without modifying the repository.  
- **Affected Files:** `lib/core/di/service_locator.dart` (line 493), `lib/features/progress/data/repositories/progress_repository_impl.dart`  
- **Fix:** Create a proper `ProgressRemoteDataSource` abstraction layer.

---

### 🟠 HIGH Issues

---

#### H-1 · Token Cache in `TokenStorage` is Stale After `clearAuth()`
- **Severity:** High  
- **Root Cause:** `TokenStorage` caches the token in memory (`_cachedToken`). After `clearAuth()` clears the cache, there is no mechanism to invalidate the cache if another part of the app still holds a reference. The interceptor calls `getToken()` which first checks `_cachedToken`. If cache is null after clear, it reads from secure storage — which is correct. But after login, `saveToken` updates the cache. The problem is if `clearAuth()` is called from the interceptor but the Cubit still has a copy of the old token in memory via another reference path.  
- **Impact:** Stale token may be used briefly after logout.  
- **Affected Files:** `lib/core/network/token_storage.dart`  
- **Fix:** The existing implementation is mostly correct. The real fix is ensuring C-4 is addressed so the app immediately redirects to login on 401.

---

#### H-2 · `SplashView` Creates a New `SharedPreferences` Instance Instead of Using DI
- **Severity:** High  
- **Root Cause:** `splash_view.dart` line 31 calls `SharedPreferences.getInstance()` directly, duplicating the `prefs` instance already managed by DI. This creates an unnecessary async call and breaks DI discipline.  
- **Impact:** Extra async overhead on startup, and it bypasses the DI container.  
- **Affected Files:** `lib/features/splash/presentation/view/splash_view.dart`  
- **Fix:** Inject `SharedPreferences` or (better) a `SessionChecker` use case through the DI container.

---

#### H-3 · Notification System is Doubly Initialized — Two Separate Plugin Instances
- **Severity:** High  
- **Root Cause:** Both `NotificationHelper` (a static class, `lib/core/helpers/notification_helper.dart`) and `LocalNotificationService` (a singleton, `lib/core/managers/local_notification_service.dart`) create their own `FlutterLocalNotificationsPlugin()` instances. `main.dart` calls `NotificationHelper.init()` AND `notificationService.initializeNotifications()` AND `notificationService.scheduleDailyQuoteNotification()`. This registers **two separate plugin instances** and calls `initializeTimeZones()` **twice** (already called in `main()` at line 26, and again in `NotificationHelper.init()` line 30).  
- **Impact:** Unpredictable notification behavior. Double initialization of timezone data. Wastes memory. Risk of conflicting notification channels.  
- **Affected Files:** `lib/main.dart`, `lib/core/helpers/notification_helper.dart`, `lib/core/managers/local_notification_service.dart`  
- **Fix:** Consolidate into a single `NotificationService` singleton. Remove `NotificationHelper` and replace its usages with `LocalNotificationService`.

---

#### H-4 · `AuthCubit.signInWithGoogle()` Always Signs Out Before Sign-In (UX Break)
- **Severity:** High  
- **Root Cause:** `auth_cubit.dart` line 122 calls `await googleSignIn.signOut()` before every sign-in attempt. This forces users to re-pick their Google account every single time, even if they were already signed in.  
- **Impact:** Poor UX. Silent data loss if the user had previously authorized the app but now has to re-consent. This also nullifies the "remember me" behavior of Google Sign-In.  
- **Affected Files:** `lib/features/auth/presentation/cubit/auth_cubit.dart` (line 122)  
- **Fix:** Remove the `signOut()` call. Only sign out on explicit user-initiated logout.

---

#### H-5 · `ProfileCubit` is a God Object — 10 Use Cases in One Cubit
- **Severity:** High  
- **Root Cause:** `ProfileCubit` manages user profile, account deletion, all children CRUD operations, settings, and password changes — 10 injected use cases. This violates the Single Responsibility Principle.  
- **Impact:** Any state change (e.g., `ProfileLoading`) affects all sub-features simultaneously. Impossible to test in isolation. Adding a new profile feature requires touching this already-large class.  
- **Affected Files:** `lib/features/profile/presentation/cubit/profile_cubit.dart`  
- **Fix (phased):** Extract `ChildrenCubit` for children CRUD and `AccountCubit` for password/delete operations. Keep `ProfileCubit` for user profile only.

---

#### H-6 · `ArticlesResponse` and `Article` are Duplicate DTOs
- **Severity:** High  
- **Root Cause:** `ArticleDetailResponse` (lines 435–468 in `api_client.dart`) is an exact field-for-field duplicate of `Article` (lines 400–433). They have identical fields, identical `fromJson` implementations, and no behavioral differences.  
- **Impact:** Maintenance burden. Any field change requires updating two identical classes. Increases compiled code size.  
- **Affected Files:** `lib/core/network/api_client.dart` (lines 400–468)  
- **Fix:** Delete `ArticleDetailResponse`. Use `Article` everywhere.

---

#### H-7 · `Child` and `ChildDetailResponse` are Duplicate DTOs
- **Severity:** High  
- **Root Cause:** `ChildDetailResponse` (lines 707–736) is an exact field-for-field duplicate of `Child` (lines 676–705). Same fields, same `fromJson` handling of both camelCase and snake_case keys.  
- **Impact:** Same as H-6.  
- **Affected Files:** `lib/core/network/api_client.dart` (lines 676–736)  
- **Fix:** Delete `ChildDetailResponse`. Use `Child` everywhere.

---

#### H-8 · `api_client.dart` is a God File — 2024 Lines
- **Severity:** High  
- **Root Cause:** All DTOs (request/response models for all features), the Retrofit `ApiClient` interface, and `ApiConfig` are packed into a single 2024-line file. The generated `api_client.g.dart` is 61,545 bytes.  
- **Impact:** Every feature's build depends on the entire file. Regeneration requires rebuilding all DTOs. Merge conflicts are guaranteed in team settings. Violates feature boundary isolation.  
- **Affected Files:** `lib/core/network/api_client.dart`  
- **Fix (phased):** Split DTOs per feature. Keep `ApiClient` as the single Retrofit interface but move DTOs to their respective feature `data/models/` directories.

---

#### H-9 · `GetHomeDataUseCase` Name Collision — Two Distinct Classes
- **Severity:** High  
- **Root Cause:** In `service_locator.dart` line 313, `GetHomeDataUseCase` is imported from `today_plan/domain/usecases/` and registered for `TodayPlanCubit`. Then line 394 imports `child_home.GetHomeDataUseCase` from `home/domain/usecases/` with an alias to avoid the collision. Two different classes with the same name serve different purposes.  
- **Impact:** Confusion, risk of registering wrong instance, difficult to maintain.  
- **Affected Files:** `lib/core/di/service_locator.dart` (lines 313, 394), feature use case files  
- **Fix:** Rename the `TodayPlan` one to `GetTodayHomeDataUseCase` or `GetTodayOverviewUseCase`.

---

#### H-10 · Login Form Performs No Email Validation Before Submission
- **Severity:** High  
- **Root Cause:** `login_view.dart` line 181 calls `formKey.currentState!.validate()` and then submits. The `CustomTextFormField` email validation uses `RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')`. However, the password field only validates length ≥ 6. No server-side trimming is done for password (though email IS trimmed on line 183). Password has `.trim()` missing. Submitting `"password "` (with trailing space) would pass client validation but fail server auth.  
- **Affected Files:** `lib/features/auth/presentation/views/login_view.dart` (line 184), `signup_view.dart` (line 212)  
- **Fix:** Trim password fields, or add a note to the validator.

---

### 🟡 MEDIUM Issues

---

#### M-1 · `ThemeCubit` Emits Initial State Then Immediately Re-Emits in `_loadTheme()`
- **Severity:** Medium  
- **Root Cause:** `ThemeCubit` constructor (line 9) sets `super(ThemeMode.light)` and immediately calls `_loadTheme()`. If the stored theme is also `light`, `emit(ThemeMode.light)` is called again, causing a redundant state emission that rebuilds `BlocBuilder<ThemeCubit>` twice at startup.  
- **Affected Files:** `lib/core/managers/theme_cubit.dart`  
- **Fix:** In the constructor, read the stored theme and pass it as the initial state directly: `super(_readThemeSync(prefs))`.

---

#### M-2 · All Cubits Registered as `registerFactory` but Used as Singletons at Root
- **Severity:** Medium  
- **Root Cause:** `ArticlesCubit`, `TodayPlanCubit`, `ActivityCubit`, `ProfileCubit`, `HomeCubit`, `ProgressCubit`, `ChatCubit`, `TestsCubit`, `TestCubit`, `NotificationCubit` are all `registerFactory`. They are created once in `main.dart` `MultiBlocProvider`. If any other code path calls `getIt<ArticlesCubit>()`, it gets a **detached instance** with no state. This is the same anti-pattern as C-3 but less critical for features other than auth.  
- **Affected Files:** `lib/core/di/service_locator.dart` (all `registerFactory` for cubits)  
- **Fix:** Register global cubits as `registerLazySingleton`. Reserve `registerFactory` for per-route cubits only (e.g., `QuizCubit` which has a clear lifecycle).

---

#### M-3 · Commented-Out Dead Code in `custom_text_form_field.dart`
- **Severity:** Medium  
- **Root Cause:** Lines 3–85 of `custom_text_form_field.dart` contain the **entire previous implementation** commented out. This is 83 lines of dead code checked into version control.  
- **Affected Files:** `lib/features/auth/presentation/views/widget/custom_text_form_field.dart`  
- **Fix:** Delete the commented block.

---

#### M-4 · Commented-Out Dead Code in `splash_view.dart`
- **Severity:** Medium  
- **Root Cause:** Lines 94–109 in `splash_view.dart` contain commented-out `Text` widgets referencing `AppStrings.appName` and `AppStrings.appSlogan`. Lines 94, 101 are empty `SizedBox` placeholders with no purpose.  
- **Affected Files:** `lib/features/splash/presentation/view/splash_view.dart`  
- **Fix:** Delete the commented blocks; keep the `SizedBox(height: 10)` only if a real widget will follow, otherwise remove.

---

#### M-5 · `LoginView` and `SignupView` Duplicate 50+ Lines of Social Auth + Divider Widget
- **Severity:** Medium  
- **Root Cause:** The "Sign in with Google", "Sign in with Facebook", and the "or sign in/up with" divider section are copy-pasted identically between `login_view.dart` (lines 86–130) and `signup_view.dart` (lines 90–135). Any change must be made in two places.  
- **Affected Files:** `lib/features/auth/presentation/views/login_view.dart`, `signup_view.dart`  
- **Fix:** Extract a `SocialAuthSection` widget.

---

#### M-6 · `signin` Cancellation Emits `AuthError('Sign-in cancelled')` — UX Issue
- **Severity:** Medium  
- **Root Cause:** `auth_cubit.dart` lines 128 and 184 emit `AuthError` when the user **cancels** the Google/Facebook flow. Cancellation is not an error — it is a normal user action. The `LoginView`/`SignupView` `BlocListener` reacts to `AuthError` by showing a red SnackBar error message.  
- **Impact:** Users who press "Cancel" see an error message, which is confusing.  
- **Affected Files:** `lib/features/auth/presentation/cubit/auth_cubit.dart` (lines 128, 184)  
- **Fix:** Introduce a dedicated `AuthCancelled` state. The listener should silently ignore this state (or show no UI).

---

#### M-7 · `signup_view.dart` — Password Mismatch Check is Done in the View, Not the Form Validator
- **Severity:** Medium  
- **Root Cause:** `signup_view.dart` lines 194–207 check `passwordController.text != confirmPasswordController.text` inside the button `onTap` callback **after** `formKey.currentState!.validate()`. This means the confirm-password field itself has no validator (it only validates "not empty"). If the user types `123456` and `1234567`, the form is "valid" on field level but fails on button tap — inconsistent UX.  
- **Affected Files:** `lib/features/auth/presentation/views/signup_view.dart`  
- **Fix:** Move the password-match check into the `CustomTextFormField`'s validator for the confirmPassword field.

---

#### M-8 · `MyChildrenResponse` DTO is Defined but Never Used — `getMyChildren()` Returns `List<Child>` Directly
- **Severity:** Medium  
- **Root Cause:** `MyChildrenResponse` (lines 660–674 in `api_client.dart`) wraps a `List<Child>`. However, the Retrofit method `getMyChildren()` (line 120) returns `HttpResponse<List<Child>>` directly, bypassing `MyChildrenResponse`. This dead class takes up space.  
- **Affected Files:** `lib/core/network/api_client.dart` (lines 660–674)  
- **Fix:** Delete `MyChildrenResponse`.

---

#### M-9 · `data_connection_checker_tv` Package Imported but Never Used
- **Severity:** Medium  
- **Root Cause:** `pubspec.yaml` line 35 includes `data_connection_checker_tv: ^0.3.5-nullsafety`. Searching the codebase reveals zero usages in any Dart file. The package is fetched and compiled but provides zero value.  
- **Affected Files:** `pubspec.yaml`  
- **Fix:** Remove the dependency.

---

#### M-10 · `hive` and `hive_flutter` Packages Imported but Never Used
- **Severity:** Medium  
- **Root Cause:** `pubspec.yaml` lines 47–48 include `hive` and `hive_flutter`. No Hive box, adapter, or `Hive.initFlutter()` is present anywhere in the project.  
- **Affected Files:** `pubspec.yaml`  
- **Fix:** Remove both dependencies.

---

#### M-11 · Release Build Signed with Debug Keys
- **Severity:** Medium  
- **Root Cause:** `android/app/build.gradle.kts` line 39: `signingConfig = signingConfigs.getByName("debug")`. This means `flutter run --release` signs with the debug keystore. Play Store submission with debug keys is rejected.  
- **Affected Files:** `android/app/build.gradle.kts`  
- **Fix:** Create a release signing configuration and apply it to the `release` build type. Store keystore credentials securely (not in version control).

---

#### M-12 · `ThemeCubit` Uses `ThemeMode` as State (Primitive) — Not Equatable
- **Severity:** Medium  
- **Root Cause:** `ThemeCubit` emits `ThemeMode` (a Flutter enum). Bloc/Cubit requires `==` comparisons to determine if a state changed. `ThemeMode` is an enum, so `==` works correctly. However, the cubit does NOT extend `Equatable`, which is fine since enums have value equality. This is a low-risk issue but worth documenting.  
- **Affected Files:** `lib/core/managers/theme_cubit.dart`  
- **Fix:** No action needed — enums have structural equality by default.

---

### 🟢 LOW Issues

---

#### L-1 · `replace_colors.dart` at Project Root is a Developer Script Not Part of the App
- **Severity:** Low  
- **Root Cause:** `replace_colors.dart` sits at the root alongside `pubspec.yaml`. It's a one-off script, not part of the app source.  
- **Fix:** Move to a `scripts/` directory or delete.

---

#### L-2 · `font_manger.dart` — Typo in Filename
- **Severity:** Low  
- **Root Cause:** `lib/core/managers/font_manger.dart` — missing `a` in "manager".  
- **Fix:** Rename to `font_manager.dart` and update imports.

---

#### L-3 · `reset_passowrd_finished_view.dart` — Typo in Filename
- **Severity:** Low  
- **Root Cause:** `lib/features/auth/presentation/views/reset_passowrd_finished_view.dart` — "passowrd" instead of "password".  
- **Fix:** Rename file and its class, update all imports.

---

#### L-4 · `app_description` in `pubspec.yaml` is a Template Default
- **Severity:** Low  
- **Root Cause:** `description: "A new Flutter project."` — never updated from the Flutter template.  
- **Fix:** Set to a meaningful description.

---

#### L-5 · `applicationId` Still Uses Default `com.example.child_monitor_app`
- **Severity:** Low  
- **Root Cause:** `android/app/build.gradle.kts` line 26: `applicationId = "com.example.child_monitor_app"`. The `com.example` namespace is reserved for samples and will be rejected by the Play Store.  
- **Affected Files:** `android/app/build.gradle.kts`  
- **Fix:** Change to a real reverse-domain identifier (e.g., `com.yourcompany.childmonitor`).

---

#### L-6 · Asset Path Duplication in `pubspec.yaml`
- **Severity:** Low  
- **Root Cause:** `pubspec.yaml` lines 86–87 list both `assets/images/logo/logo.png` and `assets/images/logo/` — the individual file is redundant because the directory listing already includes it.  
- **Fix:** Remove `assets/images/logo/logo.png` (keep only `assets/images/logo/`).

---

#### L-7 · `SplashView` `initState` Starts a `Future` Without Awaiting / Cancellation Safety
- **Severity:** Low  
- **Root Cause:** `_navigateAfterDelay()` is called from `initState` without `await` (correct since `initState` is sync), but the `Future` holds a reference to `context` via `Navigator`. The `!mounted` checks on lines 28 and 44 are correct. However, there's no cancellation token — if `dispose()` is called during the `await Future.delayed`, the timer still runs. In practice Flutter's framework handles this, but a `Timer` would be cleaner.  
- **Fix:** Use a `Timer` stored in a field that gets cancelled in `dispose()`.

---

#### L-8 · Inline Magic Colors Instead of `ColorManager`
- **Severity:** Low  
- **Root Cause:** `login_view.dart` line 109 and 197 use `Color(0xFFCBD2E0)` and `Color(0xFF131111)` inline. `signup_view.dart` has similar patterns. These colors should be in `ColorManager`.  
- **Fix:** Add named constants to `ColorManager` and replace inline usages.

---

#### L-9 · Inconsistent Import Styles (Relative vs. Package Imports)
- **Severity:** Low  
- **Root Cause:** Some files use relative imports (`import '../../../../core/...'`) while others use package imports (`import 'package:child_monitor_app/...'`). `main.dart` lines 20–21 use relative imports while lines 1–19 use package imports.  
- **Fix:** Standardize on package imports for better refactoring safety.

---

## PHASE 2 — PRIORITIZED EXECUTION PLAN

### Priority 1: Critical (App-Breaking)

| # | Fix | Risk | Files Touched |
|---|-----|------|---------------|
| C-2 | Move `baseUrl` to config / env | 🟢 Low | `api_client.dart` |
| C-3 | Register `AuthCubit` as `lazySingleton` | 🟡 Medium | `service_locator.dart` |
| C-4 | Handle 401 → emit AuthEvent + navigate | 🟡 Medium | `service_locator.dart`, `auth_cubit.dart` |
| H-3 | Consolidate notification init (one service) | 🟢 Low | `main.dart`, `notification_helper.dart` |
| H-4 | Remove forced Google signOut before sign-in | 🟢 Low | `auth_cubit.dart` |

> **C-1** (fake `google-services.json`) requires real Firebase project credentials from the developer — cannot be automated.

### Priority 2: High (Architecture & Quality)

| # | Fix | Risk | Files Touched |
|---|-----|------|---------------|
| C-5 | Create `MonthlyAssessmentRepository` + use case | 🟡 Medium | 3 new files, 2 modified |
| C-6 | Add `ProgressRemoteDataSource` abstraction | 🟡 Medium | 1 new file, 2 modified |
| H-6 | Delete `ArticleDetailResponse`, use `Article` | 🟢 Low | `api_client.dart` + consumers |
| H-7 | Delete `ChildDetailResponse`, use `Child` | 🟢 Low | `api_client.dart` + consumers |
| M-8 | Delete unused `MyChildrenResponse` | 🟢 Low | `api_client.dart` |
| M-3 | Remove 83-line commented block | 🟢 Low | `custom_text_form_field.dart` |
| M-4 | Remove commented-out code in `splash_view.dart` | 🟢 Low | `splash_view.dart` |

### Priority 3: Medium (State & UX)

| # | Fix | Risk | Files Touched |
|---|-----|------|---------------|
| M-2 | Register global cubits as `lazySingleton` | 🟡 Medium | `service_locator.dart` |
| M-6 | Add `AuthCancelled` state | 🟢 Low | `auth_state.dart`, `auth_cubit.dart`, `login_view.dart`, `signup_view.dart` |
| M-7 | Move password-match validation into field validator | 🟢 Low | `signup_view.dart` |
| H-2 | Fix `SplashView` DI for `SharedPreferences` | 🟢 Low | `splash_view.dart` |
| M-1 | Fix `ThemeCubit` double-emit | 🟢 Low | `theme_cubit.dart` |
| M-5 | Extract `SocialAuthSection` widget | 🟢 Low | 1 new file, 2 modified |

### Priority 4: Low (Cleanup & Polish)

| # | Fix | Risk | Files Touched |
|---|-----|------|---------------|
| M-9 | Remove `data_connection_checker_tv` dependency | 🟢 Low | `pubspec.yaml` |
| M-10 | Remove `hive` / `hive_flutter` dependencies | 🟢 Low | `pubspec.yaml` |
| H-9 | Rename duplicate `GetHomeDataUseCase` | 🟡 Medium | 2 use case files, `service_locator.dart` |
| L-2 | Rename `font_manger.dart` → `font_manager.dart` | 🟢 Low | 1 file rename + imports |
| L-3 | Rename `reset_passowrd_finished_view.dart` | 🟢 Low | 1 file rename + imports |
| L-6 | Remove duplicate asset path in `pubspec.yaml` | 🟢 Low | `pubspec.yaml` |
| L-4 | Update `pubspec.yaml` description | 🟢 Low | `pubspec.yaml` |
| L-8 | Move inline colors to `ColorManager` | 🟢 Low | 2 view files, `color_manager.dart` |
| L-9 | Standardize import style | 🟢 Low | multiple files |

---

## Open Questions for User

> [!IMPORTANT]
> **C-1: Real `google-services.json`** — The current file is a placeholder. Do you have a real Firebase project configured? If yes, please place the actual `google-services.json` in `android/app/` before Phase 5 (authentication) work begins.

> [!IMPORTANT]
> **C-2: Backend URL** — What is the production base URL? Should it be an HTTPS endpoint? Should we use `--dart-define` for environment separation (dev/staging/prod)?

> [!WARNING]
> **M-11: Release Signing** — The release build is signed with the debug keystore. Please provide your release keystore (or create one) before any distribution. The keystore path should be kept out of version control.

> [!IMPORTANT]
> **L-5: Application ID** — The current `applicationId` is `com.example.child_monitor_app`. What should it be changed to?

> [!NOTE]
> **H-5: ProfileCubit Refactoring** — Splitting `ProfileCubit` into 2–3 smaller cubits is a safe architectural improvement, but requires careful routing review. Do you want this done in Phase 4 or deferred?

---

## Verification Plan

### After Each Fix
1. `flutter analyze` — zero new errors
2. App starts and splash navigation works
3. Login/logout flow works
4. No regression in API calls

### Key Test Scenarios
- Cold start → correct route (onboarding vs. main app vs. login)
- Email/password login → main nav
- Google/Facebook sign-in → main nav (requires real `google-services.json`)
- Logout → login screen
- Session persistence across app restart
- 401 response → redirect to login (after C-4 fix)

# Child Monitor App — Project Map

**Generated**: May 2026 | **App**: `child_monitor_app` | **Monorepo**: `neon-garden`
**Last updated**: May 15, 2026

## CHANGELOG (May 15, 2026)

- **URL fix**: All 45 ApiClient paths changed from absolute (`/auth/login`) to relative (`auth/login`) so Retrofit appends to base URL path, preserving `/api` prefix.
- **Notification schedule**: Changed from 09:00 → 14:00 (2:00 PM).
- **Deps upgraded**: bloc → 9.2.0, json_annotation → ^4.11.0.
- **Syntax fix**: `notification_cubit.dart` — removed 2 extra braces.
- **API fixes**: `local_notification_service.dart` — named params for v21.0.0; `Icons.quote` → `Icons.format_quote`; `withOpacity` → `withValues`.
- **Cleanup**: Removed unused imports/fields (`tests_cubit.dart`, `app_theme.dart`).
- **Double-throw fix**: `home_remote_data_source.dart` — `_handleDioException → _mapDioException` returns Exception instead of throwing directly.
- **Tests**: 10 notification tests created and passing.
- **Test bug**: `getNotifications()` returns `_localNotifications` reference (not a copy); test must capture length before mutation.

---

## TECH_STACK

| Layer | Technology | Version |
|-------|-----------|---------|
| **Framework** | Flutter | 3.41 (stable) |
| **Language** | Dart | 3.11.5 |
| **Architecture** | Clean Architecture (Domain/Data/Presentation) | — |
| **State Mgmt** | flutter_bloc (Cubit) | 9.2.0 |
| **HTTP** | Retrofit + Dio | 4.9.2 / 5.9.2 |
| **DI** | get_it | 9.2.1 |
| **Auth** | JWT + flutter_secure_storage | 9.2.4 |
| **Local DB** | Hive | 2.2.3 |
| **Notifications** | flutter_local_notifications (local only) | 21.0.0 |
| **Build** | build_runner / json_serializable | 2.6.0 / 6.10.0 |

---

## SYSTEM_FLOW

```
┌─────────────────────────────────────────────────────────┐
│                    PRESENTATION LAYER                    │
│  Screen (Widget) ←→ Cubit (BlocBuilder)                 │
│  State: Loading | Loaded(data) | Error(message)         │
├─────────────────────────────────────────────────────────┤
│                     DOMAIN LAYER                         │
│  UseCase → Repository(interface) → Entity               │
│  (business logic, no framework deps)                    │
├─────────────────────────────────────────────────────────┤
│                      DATA LAYER                          │
│  RepositoryImpl → RemoteDataSource → ApiClient(DTOs)    │
│  (JSON serialization, API calls, error mapping)         │
├─────────────────────────────────────────────────────────┤
│                      CORE LAYER                          │
│  get_it(DI) → Dio(HTTP) → SecureStorage(JWT)            │
│  SharedPreferences → Hive → LocalNotificationService   │
└─────────────────────────────────────────────────────────┘

Authentication Flow:
  Login → JWT token → FlutterSecureStorage → Dio interceptor
  → Bearer token on all requests → 401 → clear → redirect login

Notification Flow (local — no API):
  App start → Schedule daily quote @ 14:00
  → DailyQuoteManager picks quote → LocalNotificationService shows
  → In-app: NotificationCubit → NotificationRepository
  → DailyQuoteManager.getDailyQuote() → UI

DI Flow:
  getIt singleton: Storage, HTTP, ApiClient
  getIt lazySingleton: DataSources, Repositories, UseCases
  getIt factory: Cubits
```

---

## FEATURES STATUS

| Feature | Status | API | Notes |
|---------|--------|-----|-------|
| Auth | ✅ Complete | 6 endpoints | Login, signup, password reset, OTP |
| Articles | ✅ Complete | 7 endpoints | CRUD, categories, favorites |
| Today Plan | ✅ Complete | 4 endpoints | Daily plan, activities, history |
| Home | ✅ Complete | 1 endpoint | Aggregated dashboard data |
| Profile | ✅ Complete | 8 endpoints | Profile, children CRUD, settings |
| Progress | ⚠️ PARTIAL | 3 endpoints | Uses separate Retrofit client - needs migration |
| Notifications | ✅ Complete | **NONE (local)** | Daily quotes @ 14:00 via `DailyQuoteManager` |
| Chat | ✅ Complete | 2 endpoints | AI chatbot integration |
| Tests | ✅ Complete | 3 endpoints | ADHD, Autism, Dyslexia screening |
| Onboarding | 🎨 UI only | — | No backend needed |
| Splash | 🎨 UI only | — | Loading screen |
| Bottom Nav | 🎨 UI only | — | Navigation container |

---

## KEY RULES

- **No feature without a cubit.** Every screen gets a Cubit + State.
- **No API calls from UI.** Always through UseCase → Repository → DataSource.
- **DI only via getIt.** No manual instantiation of services.
- **Tokens in secure storage only.** Never in SharedPreferences.
- **Local notifications are free of API dependency.** Quotes managed entirely on-device.

---

## ORPHANS & PENDING

- **`override_on_non_overriding_member` warnings (150+)**: Pre-existing UI code incompatible with Flutter 3.41 API changes (e.g., `build` signature, `State` lifecycle). Cannot fix without modifying UI files.
- **`dead_code_on_catch_subtype` warnings**: Repository impls catch `ServerException` and `NetworkException` separately, but the analyzer considers one a subtype of the other. Pre-existing in data layer.
- **`dead_code` warnings**: Pre-existing in UI views (`setState` after `return`, unreachable branches, etc.).
- **Progress feature**: separate Retrofit client (`ProgressRemoteDataSource`) not using central `ApiClient`. Needs migration to consolidate base URL + interceptors (deferred — works correctly).
- **Chat tests**: data layer exists, no unit tests yet.
- **Tests feature**: no UI views yet (only widgets).
- **Hive caching**: offline cache layer not wired.

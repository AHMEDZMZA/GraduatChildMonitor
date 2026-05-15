# Flutter Project Architecture Analysis
## GraduatChildMonitor - Complete Overview

---

## 📋 EXECUTIVE SUMMARY

**Project Type**: Flutter Mobile App (Parent/Monitor Application)  
**Architecture Pattern**: Clean Architecture (Domain/Data/Presentation)  
**State Management**: Cubit (flutter_bloc)  
**HTTP Client**: Retrofit + Dio  
**DI Container**: GetIt  
**Status**: 60% complete - Core features working, Progress & Notifications need refinement

---

## 🏗️ TECHNOLOGY STACK

| Component | Library | Version |
|-----------|---------|---------|
| **Framework** | Flutter | 3.7.2+ |
| **State Mgmt** | flutter_bloc | 9.1.1 |
| **HTTP** | Retrofit | 4.1.0 |
| **HTTP** | Dio | 5.9.0 |
| **DI** | get_it | 9.0.5 |
| **Secure Storage** | flutter_secure_storage | 9.2.4 |
| **Local Storage** | SharedPreferences | 2.5.3 |
| **Local DB** | Hive | 2.2.3 |
| **Build Tools** | build_runner | 2.4.13 |
| **Serialization** | json_serializable | 6.7.1 |
| **Auth** | google_sign_in | 6.2.1 |
| **Auth** | flutter_facebook_auth | 7.0.0 |
| **Notifications** | flutter_local_notifications | 21.0.0 |

---

## 📁 PROJECT STRUCTURE

```
lib/
├── core/                          # Shared application logic
│   ├── constants/                 # App strings, constants
│   ├── di/                        # Dependency Injection (GetIt setup)
│   │   └── service_locator.dart   # Main DI configuration
│   ├── helpers/                   # Utility functions
│   ├── managers/                  # Theme management
│   ├── navigation/                # App routing
│   ├── network/                   # HTTP client setup
│   │   ├── api_client.dart        # Retrofit API definitions + DTOs
│   │   ├── token_storage.dart     # Auth token management
│   │   └── exceptions.dart        # Custom exceptions
│   └── widgets/                   # Reusable UI widgets
│
├── features/                      # Feature modules
│   ├── auth/                      # ✅ Authentication (COMPLETE)
│   ├── articles/                  # ✅ Articles (COMPLETE)
│   ├── today_plan/                # ✅ Today Plan (COMPLETE)
│   ├── home/                      # ✅ Home Dashboard (COMPLETE)
│   ├── profile/                   # ✅ Profile Management (COMPLETE)
│   ├── progress/                  # ⚠️ Progress Tracking (PARTIAL)
│   ├── notification/              # ⚠️ Notifications (MOCK)
│   ├── chat/                      # ❌ Chat (NOT IMPLEMENTED)
│   ├── onboarding/                # 🎨 UI Only
│   ├── splash/                    # 🎨 UI Only
│   └── bottom_nav/                # 🎨 UI Container Only
│
├── main.dart                      # App entry point
└── generated/                     # Auto-generated files

# Complete Feature Structure:
features/[feature]/
├── data/                          # Data layer
│   ├── datasources/               # Remote/Local data sources
│   ├── models/                    # Data models with serialization
│   └── repositories/              # Repository implementations
├── domain/                        # Business logic layer
│   ├── entities/                  # Business entities
│   ├── repositories/              # Repository interfaces
│   └── usecases/                  # Use cases
└── presentation/                  # UI layer
    ├── cubit/                     # State management
    ├── state/                     # Cubit states
    ├── view/                      # Screen widgets
    └── widgets/                   # Feature-specific widgets
```

---

## 🎯 FEATURE BREAKDOWN

### ✅ 1. AUTHENTICATION (Fully Implemented)
**Location**: `lib/features/auth/`

**UI Screens**:
- Sign up screen
- Login screen
- Password reset flow (OTP verification)

**State Management**: `AuthCubit`
- Methods: signup(), login(), logout(), requestPasswordReset(), verifyOtp(), confirmPasswordReset()
- Use cases: Dedicated use case for each operation

**API Endpoints** (6 total):
```
POST   /auth/signup                          - Register new parent/monitor
POST   /auth/login                           - Login with credentials
POST   /auth/logout                          - Logout user
POST   /auth/reset-password/request          - Request password reset
POST   /auth/reset-password/verify           - Verify OTP
POST   /auth/reset-password/confirm          - Confirm new password
```

**Data Models**:
- `AuthResponse` - Contains token, email, message
- `SignupRequest`, `LoginRequest`, `RequestPasswordResetRequest`
- `VerifyOtpRequest`, `ConfirmPasswordResetRequest`

**Data Flow**: 
```
Cubit → UseCase → Repository → RemoteDataSource → ApiClient → Server
```

**Token Management**: 
- Tokens stored in `FlutterSecureStorage`
- Auto-included in request headers via Dio interceptor
- Auto-cleared on 401 response

---

### ✅ 2. ARTICLES (Fully Implemented)
**Location**: `lib/features/articles/`

**UI Screens**:
- Articles list view
- Article detail view
- Favorites view

**State Management**: `ArticlesCubit`
- Use cases: GetAllArticles, GetArticleDetail, GetArticlesByCategory, AddArticleToFavorite, RemoveArticleFromFavorite, GetFavoriteArticles, CheckIfArticleIsFavorite

**API Endpoints** (7 total):
```
GET    /articles/all                        - Get all articles
GET    /articles/{articleId}                - Get single article detail
GET    /articles/category/{category}        - Filter by category
POST   /articles/favorite/add                - Add to favorites
DELETE /articles/favorite/remove             - Remove from favorites
GET    /articles/favorites                   - Get favorite articles
GET    /articles/favorite/check              - Check if article is favorited
```

**Data Models**:
- `Article` - Main article model
- `ArticleDetailResponse` - Detail view with extra fields
- `ArticlesResponse`, `FavoritesResponse`, `IsFavoriteResponse`

**Data Flow**: Same as Auth

---

### ✅ 3. TODAY PLAN (Fully Implemented)
**Location**: `lib/features/today_plan/`

**UI Screens**:
- Today's plan view with activities

**State Management**: `TodayPlanCubit`
- Use cases: GetTodayPlan, CompleteTodayPlan, GetPlanHistory

**API Endpoints** (4 total):
```
GET    /home/today-plan                     - Get today's plan + activities for child
POST   /home/plan/complete                  - Mark plan as completed
GET    /home/plan-history                   - Get historical plans for child
GET    /home/data                           - Get combined home data
```

**Data Models**:
- `TodayPlanResponse` - Contains plan + activities list
- `Plan` - Plan object with status
- `Activity` - Individual activity with completion status
- `PlanHistoryResponse` - List of historical plans

**Parameters**:
- `childId` (query param) - Required to fetch child-specific data

---

### ✅ 4. HOME DASHBOARD (Fully Implemented)
**Location**: `lib/features/home/`

**UI Screens**:
- Home dashboard with multiple progress views
- Monthly progress details
- Progress tracker
- Result progress view
- Progress test view

**State Management**: `HomeCubit`
- Use case: GetHomeData

**API Endpoints** (1 primary + 1 shared):
```
GET    /home/data                           - Get comprehensive home data
       (Returns: userName, greeting, children list, todayPlan, 
                 todayActivities, progressStats, articles)
```

**Data Models**:
- `HomeDataResponse` - Aggregated dashboard data
- Contains: Child list, Plan, Activities, Progress stats, Articles

**Note**: Shares `getHomeData` endpoint with TodayPlan feature

---

### ✅ 5. PROFILE MANAGEMENT (Fully Implemented)
**Location**: `lib/features/profile/`

**UI Screens**:
- User profile view
- Child management (add/edit/delete)
- Settings page
- Password change

**State Management**: `ProfileCubit`
- Use cases: GetUserProfile, UpdateUserProfile, DeleteAccount, GetMyChildren, GetChildDetail, AddChild, UpdateChild, DeleteChild, GetSettings, ChangePassword

**API Endpoints** (10 total):
```
GET    /children/profile                    - Get parent/monitor profile
PUT    /children/update-profile             - Update parent profile
DELETE /children/delete-account             - Delete account
GET    /children/my-children                - List all children
GET    /children/{childId}                  - Get specific child details
POST   /children/add                        - Create new child profile
PUT    /children/{childId}                  - Update child details
DELETE /children/{childId}                  - Delete child
GET    /settings                            - Get user settings
POST   /password/change                     - Change password
```

**Data Models**:
- `UserProfileResponse` - Parent profile
- `MyChildrenResponse` - List of children
- `Child`, `ChildDetailResponse` - Child information
- `AddChildRequest`, `AddChildResponse`
- `UpdateProfileRequest`, `ChangePasswordRequest`
- `SettingsResponse`

**Child Data Fields**:
- name, birthDate, gender, knowsCondition, diagnosedCondition

---

### ⚠️ 6. PROGRESS TRACKING (Partially Implemented)
**Location**: `lib/features/progress/`

**UI Screens**:
- Monthly progress view
- Monthly progress details
- Progress tracker
- Result progress view
- Progress test view

**State Management**: `ProgressCubit`
- Use cases: GetChildProgress

**Data Models**:
- `ProgressSummaryModel` - Summary text + improvement percentage
- `TrendModel` - Status + trend data (array of numbers)
- `ActivityStatsModel` - completed/total activities + completion percentage

**⚠️ ISSUES**:
1. **Separate Retrofit Client**: Uses own `@RestApi()` decorated data source instead of central `ApiClient`
   - Located in: `progress_remote_data_source.dart`
   - NOT using common API base URL or interceptors
2. **Inconsistent Endpoint Pattern**: 
   ```
   @GET('/api/home/progress')                    # Different base path
   @GET('/api/monthly-assessment/trend/{childId}')
   @GET('/api/activities/stats/{childId}')
   ```
   - Should be: `/progress`, `/monthly-assessment/trend/{childId}`, `/activities/stats/{childId}`
3. **Not integrated with central token management**
4. **Uses json_annotation instead of consistent DTO pattern**

**Recommendation**: Migrate to central ApiClient

---

### ⚠️ 7. NOTIFICATIONS (Mock Implementation)
**Location**: `lib/features/notification/`

**UI Screens**:
- Notifications list

**State Management**: `NotificationCubit`
- With `NotificationState` (separate state file)

**⚠️ ISSUES**:
1. **Mock Data Only**: `NotificationRemoteDataSourceImpl` returns hardcoded local data
   - Simulates API calls with `Future.delayed()`
   - Not connected to real backend
2. **No real API endpoints** implemented in `ApiClient`
3. **Data source**:
   ```dart
   final List<NotificationEntity> _localNotifications = 
       notifications.map((e) => NotificationEntity(...)).toList();
   ```

**Expected Endpoints** (Missing):
```
GET    /notifications                       - Get notifications
POST   /notifications/{id}/read              - Mark as read
DELETE /notifications/{id}                   - Delete notification
POST   /notifications/clear                  - Clear all
```

**Recommendation**: Implement real API calls and integrate with Firebase Cloud Messaging

---

### ❌ 8. CHAT (Not Implemented)
**Location**: `lib/features/chat/`

**Status**: UI Skeleton only

**Issues**:
1. **No data layer** - No repositories, data sources, or use cases
2. **Mock data** - `ChatMessageModel` contains hardcoded conversation
3. **No API integration** - No endpoints defined
4. **No DI setup** - Not registered in service_locator

**Expected Implementation**:
```
GET    /chat/conversations                  - List user conversations
GET    /chat/{conversationId}/messages      - Get messages for conversation
POST   /chat/{conversationId}/message       - Send new message
POST   /chat/start                          - Start new conversation
```

**Recommendation**: Implement full data layer with Cubit state management

---

### 🎨 9. ONBOARDING (UI Only)
**Location**: `lib/features/onboarding/`
- No backend integration
- Presentation layer only

---

### 🎨 10. SPLASH (UI Only)
**Location**: `lib/features/splash/`
- No backend integration
- Initial app loading screen

---

### 🎨 11. BOTTOM NAVIGATION (UI Container)
**Location**: `lib/features/bottom_nav/`
- Navigation wrapper
- No backend integration

---

## 🔧 DEPENDENCY INJECTION SETUP

**Location**: `lib/core/di/service_locator.dart`

### Pattern:
- **Singletons**: Storage, HTTP client, theme
- **Lazy Singletons**: Repositories, data sources, use cases
- **Factory**: Cubits (fresh instance per screen)

### Setup Flow:
```dart
// 1. Storage
registerSingleton<FlutterSecureStorage>()
registerSingleton<TokenStorage>()

// 2. HTTP Client with Interceptors
Dio() → add auth token interceptor → registerSingleton<Dio>()

// 3. API Client
ApiClient(dio) → registerSingleton<ApiClient>()

// 4. For Each Feature:
//    - Remote Data Source (lazy singleton)
//    - Repository (lazy singleton)
//    - Use Cases (lazy singletons)
//    - Cubit (factory)
```

### Registered Features:
| Feature | Data Source | Repository | Use Cases | Cubit |
|---------|-------------|-----------|-----------|-------|
| Auth | ✓ | ✓ | ✓ (6 use cases) | ✓ |
| Articles | ✓ | ✓ | ✓ (7 use cases) | ✓ |
| Today Plan | ✓ | ✓ | ✓ | ✓ |
| Home | ✓ | ✓ | ✓ | ✓ |
| Profile | ✓ | ✓ | ✓ (10 use cases) | ✓ |
| Notification | ✗ | ✗ | ✗ | ✓ (Cubit only) |
| Progress | ⚠️ Partial | ⚠️ Partial | ⚠️ Minimal | ✓ |
| Chat | ✗ | ✗ | ✗ | ✗ |
| Onboarding | ✗ | ✗ | ✗ | ✗ |

---

## 🌐 API CLIENT STRUCTURE

**Location**: `lib/core/network/api_client.dart`

### Configuration:
```dart
class ApiConfig {
  static const String baseUrl = 'http://192.168.1.4:8086/api';
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
```

### Implementation:
- **Framework**: Retrofit + Dio
- **Code Generation**: Uses `build_runner` for generating `api_client.g.dart`
- **HTTP Methods**: GET, POST, PUT, DELETE
- **Response Format**: HttpResponse<T> from retrofit
- **Error Handling**: Custom exception classes in `core/network/exceptions.dart`

### Current Endpoints Summary

| Category | Endpoint Count | Status |
|----------|---|--------|
| Auth | 6 | ✅ Complete |
| Articles | 7 | ✅ Complete |
| Today Plan | 4 | ✅ Complete |
| Profile/Children | 8 | ✅ Complete |
| **Total Implemented** | **25** | |
| Notifications | 0 | ❌ Missing |
| Chat | 0 | ❌ Missing |
| Progress | 3* | ⚠️ Separate Client |

*Progress endpoints are in separate Retrofit client, not central ApiClient

---

## 📊 API ENDPOINTS COMPLETE LIST

### AUTH ENDPOINTS (6)
```
POST   /auth/signup
       Body: {monitorName, email, password, confirmPassword}
       Response: {message, email, token}

POST   /auth/login
       Body: {email, password}
       Response: {message, email, token}

POST   /auth/logout
       Response: {message}

POST   /auth/reset-password/request
       Body: {email}
       Response: {message}

POST   /auth/reset-password/verify
       Body: {email, otp}
       Response: {message}

POST   /auth/reset-password/confirm
       Body: {email, otp, newPassword, confirmPassword}
       Response: {message}
```

### ARTICLES ENDPOINTS (7)
```
GET    /articles/all
       Response: {articles: [{id, title, content, image, category, author, publishedDate, description}]}

GET    /articles/{articleId}
       Response: Article detail

GET    /articles/category/{category}
       Response: {articles: [...]}

POST   /articles/favorite/add
       Query: articleId
       Response: {message}

DELETE /articles/favorite/remove
       Query: articleId
       Response: {message}

GET    /articles/favorites
       Response: {favorites: [...]}

GET    /articles/favorite/check
       Query: articleId
       Response: {is_favorite: boolean}
```

### TODAY PLAN ENDPOINTS (4)
```
GET    /home/today-plan
       Query: childId
       Response: {plan: {id, date, status, activities}, activities: [...]}

POST   /home/plan/complete
       Query: childId, date
       Response: {message}

GET    /home/plan-history
       Query: childId
       Response: [{id, date, status, activities}]

GET    /home/data
       Query: childId (optional)
       Response: {userName, greeting, children, todayPlan, todayActivities, progressStats, articles}
```

### PROFILE/CHILDREN ENDPOINTS (8)
```
GET    /children/profile
       Response: {monitor_name, email, user_id}

PUT    /children/update-profile
       Body: {monitorName, email}
       Response: {message}

DELETE /children/delete-account
       Response: {message}

GET    /children/my-children
       Response: {children: [{id, name, birthDate, gender, knowsCondition, diagnosedCondition}]}

GET    /children/{childId}
       Response: Child detail

POST   /children/add
       Body: {name, birthDate, gender, knowsCondition, diagnosedCondition}
       Response: {message, child_id, child_name}

PUT    /children/{childId}
       Body: {name, birthDate, gender, knowsCondition, diagnosedCondition}
       Response: {message}

DELETE /children/{childId}
       Response: {message}

GET    /settings
       Response: {user_id, email, monitor_name, available_settings}

POST   /password/change
       Body: {currentPassword, newPassword, confirmNewPassword}
       Response: {message}
```

### PROGRESS ENDPOINTS (3) ⚠️ SEPARATE CLIENT
```
GET    /api/home/progress                    ← Different base path!
GET    /api/monthly-assessment/trend/{childId}
GET    /api/activities/stats/{childId}
```

---

## 🚨 MISSING ENDPOINTS

### 1. NOTIFICATIONS (Completely Missing)
```
GET    /notifications                       - List notifications
GET    /notifications/{id}                  - Get single notification
POST   /notifications/{id}/read              - Mark as read
DELETE /notifications/{id}                   - Delete notification
POST   /notifications/clear-all             - Clear all notifications
```

### 2. CHAT (Completely Missing)
```
GET    /chat/conversations                  - List conversations
GET    /chat/{conversationId}/messages      - Get messages
POST   /chat/{conversationId}/message       - Send message
POST   /chat/start                          - Start conversation
DELETE /chat/{conversationId}               - Delete conversation
```

### 3. FILE UPLOADS (Potentially Missing)
```
POST   /upload/profile-picture              - Upload parent profile picture
POST   /upload/child-picture                - Upload child profile picture
```

### 4. REAL-TIME/WEBSOCKET (Missing)
```
WS     /notifications/stream                - Real-time notifications
WS     /chat/stream/{conversationId}        - Real-time chat messages
```

### 5. PROGRESS ENDPOINTS (Need Consolidation)
Currently using separate Retrofit client with different base paths:
- Needs migration to central ApiClient
- Needs path consolidation: `/progress/summary`, `/progress/trend/{childId}`, `/progress/stats/{childId}`

---

## 🏛️ ARCHITECTURE PATTERNS

### 1. Clean Architecture Implementation
```
Presentation Layer (Cubit + View)
         ↓
Domain Layer (UseCases + Repositories Interface)
         ↓
Data Layer (Repositories Impl + DataSources)
         ↓
Network Layer (ApiClient + DTOs)
```

### 2. Error Handling
**Exception Hierarchy** (in `core/network/exceptions.dart`):
```dart
- AppException (base)
  - ServerException
  - NetworkException
  - UnauthorizedException
  - CacheException
```

### 3. State Management Pattern
```dart
// Cubit with defined states
class FeatureCubit extends Cubit {
  emit(LoadingState());      // Loading
  emit(SuccessState(data));  // Success
  emit(ErrorState(error));   // Error
}

// Usage in widgets
BlocBuilder<FeatureCubit, FeatureState>(
  builder: (context, state) {
    if (state is LoadingState) return LoadingWidget();
    if (state is SuccessState) return SuccessWidget();
    if (state is ErrorState) return ErrorWidget();
  }
)
```

### 4. Token Management
```
Login → Token returned → TokenStorage (secure storage)
                      ↓
             Attached to all requests via Dio interceptor
                      ↓
401 Response → Token cleared → User redirected to login
```

---

## 📋 CHECKLIST FOR COMPLETION

### Must Do
- [ ] Migrate Progress feature to central ApiClient
- [ ] Implement real Notification API calls
- [ ] Add Chat feature with full data layer
- [ ] Implement Notification use cases and DI
- [ ] Add missing endpoints (file uploads, real-time)

### Should Do
- [ ] Add WebSocket support for real-time features
- [ ] Implement offline caching with Hive
- [ ] Add unit tests for data layer
- [ ] Add widget tests for UI layer
- [ ] Implement pagination for articles/notifications

### Nice to Have
- [ ] Add Firebase Cloud Messaging integration
- [ ] Implement analytics
- [ ] Add crash reporting
- [ ] Implement A/B testing

---

## 🎯 KEY FINDINGS

### Strengths ✅
1. **Consistent Architecture**: Clean Architecture well-implemented across all complete features
2. **Good DI Setup**: GetIt properly configured with lazy singletons and factories
3. **Type Safety**: Strong typing throughout, good use of DTOs
4. **Token Management**: Secure storage and automatic header injection
5. **Error Handling**: Custom exception hierarchy and proper error propagation
6. **Separation of Concerns**: Clear boundaries between layers

### Weaknesses ❌
1. **Incomplete Features**: Progress and Notifications are half-implemented
2. **Chat Not Started**: Completely missing implementation
3. **Separate Clients**: Progress uses separate Retrofit client instead of central ApiClient
4. **No Real-time**: Missing WebSocket support
5. **Limited Caching**: No offline support via Hive
6. **No Tests**: No unit or widget tests visible

### Inconsistencies ⚠️
1. **Progress endpoints** have different base path (`/api/` prefix missing in central client)
2. **Notification data source** uses mock data with `Future.delayed()` simulation
3. **Different DTO patterns**: Progress uses `json_annotation` while others use factory constructors
4. **Notification state file** separate but others inline in cubit

---

## 📝 RECOMMENDATIONS

### Immediate Actions
1. **Move Progress to central ApiClient**
   - Remove separate `@RestApi()` client
   - Add endpoints to main `ApiClient`
   - Fix base URL paths

2. **Implement Notification real API**
   - Add endpoints to `ApiClient`
   - Implement use cases in DI
   - Remove mock data

3. **Add Chat implementation**
   - Create domain/data/presentation layers
   - Implement repository pattern
   - Setup DI for Chat feature
   - Add endpoints to ApiClient

### Medium-term
1. Implement Firebase Cloud Messaging
2. Add WebSocket support for real-time features
3. Implement Hive caching for offline support
4. Add comprehensive error handling UI

### Long-term
1. Add unit tests (target: 70%+ coverage)
2. Add widget/integration tests
3. Implement analytics
4. Setup CI/CD pipeline

---

## 🔗 REFERENCE LOCATIONS

| Item | Location |
|------|----------|
| API Client & DTOs | `lib/core/network/api_client.dart` |
| DI Setup | `lib/core/di/service_locator.dart` |
| Exception Classes | `lib/core/network/exceptions.dart` |
| Token Storage | `lib/core/network/token_storage.dart` |
| Auth Feature | `lib/features/auth/` |
| Articles Feature | `lib/features/articles/` |
| Today Plan Feature | `lib/features/today_plan/` |
| Home Feature | `lib/features/home/` |
| Profile Feature | `lib/features/profile/` |
| Progress Feature | `lib/features/progress/` |
| Notification Feature | `lib/features/notification/` |
| Chat Feature | `lib/features/chat/` |
| Constants | `lib/core/constants/` |

---

**Document Generated**: May 15, 2026  
**Project Status**: Active Development  
**Last Updated**: Current Session

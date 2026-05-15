# Currently Implemented API Endpoints - Quick Reference

## 📌 API Base Configuration
```
Base URL: http://192.168.1.4:8086/api
Connection Timeout: 30 seconds
Receive Timeout: 30 seconds
```

---

## ✅ FULLY IMPLEMENTED ENDPOINTS (25 Total)

### 🔐 AUTH ENDPOINTS (6)

| Method | Endpoint | Function | Auth Required |
|--------|----------|----------|---|
| POST | `/auth/signup` | Register new parent/monitor | ❌ |
| POST | `/auth/login` | Login with credentials | ❌ |
| POST | `/auth/logout` | Logout current user | ✅ |
| POST | `/auth/reset-password/request` | Request password reset OTP | ❌ |
| POST | `/auth/reset-password/verify` | Verify OTP code | ❌ |
| POST | `/auth/reset-password/confirm` | Confirm new password | ❌ |

**Implementation Location**: 
- API: `lib/core/network/api_client.dart` (lines 16-40)
- Data Source: `lib/features/auth/data/datasources/auth_remote_data_source.dart`
- Cubit: `lib/features/auth/presentation/cubit/auth_cubit.dart`

---

### 📰 ARTICLES ENDPOINTS (7)

| Method | Endpoint | Function | Auth Required |
|--------|----------|----------|---|
| GET | `/articles/all` | Get all articles | ✅ |
| GET | `/articles/{articleId}` | Get single article detail | ✅ |
| GET | `/articles/category/{category}` | Filter articles by category | ✅ |
| POST | `/articles/favorite/add` | Add article to favorites | ✅ |
| DELETE | `/articles/favorite/remove` | Remove article from favorites | ✅ |
| GET | `/articles/favorites` | Get favorite articles | ✅ |
| GET | `/articles/favorite/check` | Check if article is favorited | ✅ |

**Implementation Location**:
- API: `lib/core/network/api_client.dart` (lines 41-72)
- Data Source: `lib/features/articles/data/datasources/articles_remote_data_source.dart`
- Cubit: `lib/features/articles/presentation/cubit/articles_cubit.dart`

---

### 📅 TODAY PLAN ENDPOINTS (4)

| Method | Endpoint | Params | Function | Auth Required |
|--------|----------|--------|----------|---|
| GET | `/home/today-plan` | childId | Get today's plan + activities | ✅ |
| POST | `/home/plan/complete` | childId, date | Mark plan as completed | ✅ |
| GET | `/home/plan-history` | childId | Get historical plans | ✅ |
| GET | `/home/data` | childId (optional) | Get aggregated home data | ✅ |

**Implementation Location**:
- API: `lib/core/network/api_client.dart` (lines 73-94)
- Data Source: `lib/features/today_plan/data/datasources/today_plan_remote_data_source.dart`
- Cubit: `lib/features/today_plan/presentation/cubit/today_plan_cubit.dart`

---

### 👤 PROFILE & CHILDREN ENDPOINTS (8)

| Method | Endpoint | Function | Auth Required |
|--------|----------|----------|---|
| GET | `/children/profile` | Get parent/monitor profile | ✅ |
| PUT | `/children/update-profile` | Update parent profile | ✅ |
| DELETE | `/children/delete-account` | Delete parent account | ✅ |
| GET | `/children/my-children` | List all children | ✅ |
| GET | `/children/{childId}` | Get specific child details | ✅ |
| POST | `/children/add` | Create new child profile | ✅ |
| PUT | `/children/{childId}` | Update child details | ✅ |
| DELETE | `/children/{childId}` | Delete child | ✅ |

**Additional Endpoints**:

| Method | Endpoint | Function | Auth Required |
|--------|----------|----------|---|
| GET | `/settings` | Get user settings | ✅ |
| POST | `/password/change` | Change password | ✅ |

**Implementation Location**:
- API: `lib/core/network/api_client.dart` (lines 95-112)
- Data Source: `lib/features/profile/data/datasources/profile_remote_data_source.dart`
- Cubit: `lib/features/profile/presentation/cubit/profile_cubit.dart`

---

## ⚠️ PARTIALLY IMPLEMENTED ENDPOINTS (3)

### 📊 PROGRESS ENDPOINTS ⚠️ NEEDS CONSOLIDATION

**Current Implementation**: Separate Retrofit client (NOT using central ApiClient)

| Method | Endpoint | Location | Issue |
|--------|----------|----------|-------|
| GET | `/api/home/progress` | Separate @RestApi client | Wrong base path (/api/ prefix) |
| GET | `/api/monthly-assessment/trend/{childId}` | Separate @RestApi client | Wrong base path (/api/ prefix) |
| GET | `/api/activities/stats/{childId}` | Separate @RestApi client | Wrong base path (/api/ prefix) |

**Location**: `lib/features/progress/data/datasources/progress_remote_data_source.dart`

**Problem**: 
- Uses separate Dio/Retrofit client
- Doesn't use central token management
- Inconsistent endpoint paths
- Not integrated with DI properly

**Solution**: Migrate to central `ApiClient` (See `MISSING_ENDPOINTS.md` for migration guide)

---

## ❌ NOT IMPLEMENTED

### 🔔 NOTIFICATION ENDPOINTS (Currently Mock)
- Status: Using local mock data with `Future.delayed()` simulation
- Location: `lib/features/notification/data/data_source/notification_remote_data_source.dart`
- Needs: Real API endpoints + integration

### 💬 CHAT ENDPOINTS (Not Started)
- Status: Completely missing
- Location: `lib/features/chat/` (no data layer)
- Needs: Full implementation (data layer + API endpoints)

### 📁 FILE UPLOAD ENDPOINTS (Missing)
- Profile picture upload
- Child picture upload
- General file attachments

### 🔌 REAL-TIME/WEBSOCKET (Missing)
- Live notifications
- Real-time chat messages
- Live progress updates

---

## 📋 USAGE EXAMPLES

### Example 1: Get Articles
```dart
// Data Source
final response = await apiClient.getAllArticles();
final articles = response.data.articles;

// Cubit Usage
articlesCubit.getArticles();  // Emits Loading → Success(articles)

// UI
BlocBuilder<ArticlesCubit, ArticlesState>(
  builder: (context, state) {
    if (state is ArticlesLoadingState) return LoadingWidget();
    if (state is ArticlesSuccessState) return ListView(children: state.articles);
    if (state is ArticlesErrorState) return ErrorWidget(state.message);
  }
)
```

### Example 2: Get Child Data
```dart
// Data Source
final response = await apiClient.getChildDetail('child-id-123');
final child = response.data;

// With token management (automatic via interceptor)
// Authorization header automatically added
```

### Example 3: Update Child Profile
```dart
// Data Source
await apiClient.updateChild(
  'child-id-123',
  AddChildRequest(
    name: 'Updated Name',
    birthDate: '2015-05-20',
    gender: 'M',
    knowsCondition: true,
    diagnosedCondition: 'ADHD',
  ),
);

// Returns: MessageResponse with success message
```

---

## 🔐 TOKEN MANAGEMENT

**Automatic Features**:
- ✅ Token automatically included in `Authorization` header
- ✅ Token retrieved from `FlutterSecureStorage`
- ✅ 401 responses trigger token refresh/logout
- ✅ No manual token handling needed

**Implementation**: Dio interceptor in `service_locator.dart`

```dart
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
        await getIt<TokenStorage>().clearAuth();
      }
      return handler.next(error);
    },
  ),
);
```

---

## 📝 DTO REFERENCE

### Response DTOs
- `AuthResponse` - Auth operations
- `Article`, `ArticlesResponse`, `ArticleDetailResponse` - Articles
- `Plan`, `Activity`, `TodayPlanResponse`, `PlanHistoryResponse` - Plans
- `HomeDataResponse` - Dashboard data
- `UserProfileResponse`, `Child`, `ChildDetailResponse` - Profile
- `SettingsResponse` - Settings
- `ProgressSummaryModel`, `TrendModel`, `ActivityStatsModel` - Progress
- `MessageResponse` - Generic success messages
- `IsFavoriteResponse` - Boolean responses

### Request DTOs
- `SignupRequest`, `LoginRequest` - Auth
- `UpdateProfileRequest` - Profile updates
- `AddChildRequest` - Child creation
- `ChangePasswordRequest` - Password changes
- `RequestPasswordResetRequest`, `VerifyOtpRequest`, `ConfirmPasswordResetRequest` - Password reset

---

## 🛠️ COMMON PATTERNS

### Pattern 1: Fetch & Display
```dart
@override
Future<List<Article>> getAllArticles() async {
  try {
    final response = await apiClient.getAllArticles();
    return response.data.articles;  // Extract from wrapper
  } on DioException catch (e) {
    throw _handleDioException(e);
  } catch (e) {
    throw ServerException(message: 'Error: ${e.toString()}');
  }
}
```

### Pattern 2: Action (Create/Update/Delete)
```dart
@override
Future<void> addChild({
  required String name,
  required String birthDate,
  required String gender,
  required bool knowsCondition,
  String? diagnosedCondition,
}) async {
  try {
    await apiClient.addChild(
      AddChildRequest(
        name: name,
        birthDate: birthDate,
        gender: gender,
        knowsCondition: knowsCondition,
        diagnosedCondition: diagnosedCondition,
      ),
    );
  } on DioException catch (e) {
    throw _handleDioException(e);
  } catch (e) {
    throw ServerException(message: 'Error: ${e.toString()}');
  }
}
```

### Pattern 3: Error Handling
```dart
Exception _handleDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.receiveTimeout:
      return NetworkException(message: 'Connection timeout');
    case DioExceptionType.badResponse:
      if (e.response?.statusCode == 401) {
        return UnauthorizedException(
          message: e.response?.data['message'] ?? 'Unauthorized',
        );
      }
      return ServerException(
        message: e.response?.data['message'] ?? 'Server error',
        statusCode: e.response?.statusCode,
      );
    default:
      return ServerException(message: 'Unknown error: ${e.message}');
  }
}
```

---

## 🚀 TO IMPLEMENT NEXT

Priority Order:

1. **HIGH**: Fix Progress endpoints (consolidate to central client)
   - Effort: 1-2 hours
   - Impact: Consistency, token management

2. **HIGH**: Implement Notification API endpoints
   - Effort: 2-3 hours
   - Impact: Remove mock data

3. **HIGH**: Implement Chat endpoints & data layer
   - Effort: 4-5 hours
   - Impact: Feature completion

4. **MEDIUM**: Add file upload endpoints
   - Effort: 2-3 hours
   - Impact: Enhanced UX (profile pictures)

5. **MEDIUM**: Add Assessment/Test endpoints
   - Effort: 3-4 hours
   - Impact: Completeness for progress testing

6. **LOW**: WebSocket support (real-time)
   - Effort: 6-8 hours
   - Impact: Enhanced UX

---

**Document Version**: 1.0  
**Last Updated**: May 15, 2026  
**Status**: Current (API endpoints as of today)

# API Integration Implementation Guide

## Overview

This document outlines how API data is integrated into the Graduate Child Monitor application. All features now fetch real data from the API endpoints and handle errors gracefully.

## Architecture Pattern

The application follows **Clean Architecture** with the following layers:

1. **Presentation Layer** (Cubits & UI)
   - Manages UI state using BLoC/Cubit pattern
   - Handles user interactions and displays data

2. **Domain Layer** (Entities, Repositories, UseCases)
   - Contains business logic
   - Defines repository interfaces
   - Independent of implementation details

3. **Data Layer** (DataSources, Models, Repositories)
   - Implements repository interfaces
   - Fetches data from remote APIs
   - Handles data transformations

4. **Core Layer** (API Client, Network)
   - Handles HTTP requests
   - Manages authentication tokens
   - Defines DTOs for API responses

## Features Integration

### 1. **Articles Feature** ✅

**API Endpoint**: `GET /api/articles/all`

**Flow**:

```
UI (ArticlesView)
  ↓
ArticlesCubit (handles state)
  ↓
GetAllArticlesUseCase
  ↓
ArticlesRepository
  ↓
ArticlesRemoteDataSource
  ↓
ApiClient (HTTP request)
```

**Usage in UI**:

```dart
BlocBuilder<ArticlesCubit, ArticlesState>(
  builder: (context, state) {
    if (state is ArticlesLoading) {
      return CircularProgressIndicator();
    } else if (state is ArticlesSuccess) {
      return ListView.builder(
        itemCount: state.articles.length,
        itemBuilder: (context, index) {
          return ArticleCard(article: state.articles[index]);
        },
      );
    } else if (state is ArticlesError) {
      return ErrorWidget(message: state.message);
    }
    return SizedBox.shrink();
  },
)
```

**Cubits Methods**:

- `getArticles()` - Fetch all articles
- `getArticlesByCategory(category)` - Filter by category
- `getArticleDetail(id)` - Get single article
- `addToFavorite(id)` - Add to favorites
- `removeFromFavorite(id)` - Remove from favorites

---

### 2. **Home Feature** ✅

**API Endpoint**: `GET /api/home/data`

**Data Returned**:

- User greeting
- Children list
- Today's plan
- Today's activities
- Progress statistics
- Recommended articles

**Usage in UI**:

```dart
BlocBuilder<HomeCubit, HomeState>(
  builder: (context, state) {
    if (state is HomeLoading) {
      return LoadingWidget();
    } else if (state is HomeDataLoaded) {
      return Column(
        children: [
          GreetingCard(userName: state.data.userName),
          ChildrenList(children: state.data.children),
          TodayPlanCard(plan: state.data.todayPlan),
          ProgressStats(stats: state.data.progressStats),
          RecommendedArticles(articles: state.data.articles),
        ],
      );
    }
    return Container();
  },
)
```

---

### 3. **Today Plan Feature** ✅

**API Endpoints**:

- `GET /api/home/today-plan` - Get today's plan
- `POST /api/home/plan/complete` - Mark as completed
- `GET /api/home/plan-history` - Get plan history

**Cubits Methods**:

- `getTodayPlan(childId)` - Fetch today's plan
- `completePlan(childId, date)` - Mark completed
- `getPlanHistory(childId)` - Get historical plans

**Usage Example**:

```dart
context.read<TodayPlanCubit>().getTodayPlan('child_id_123');

// Listen for completion
BlocBuilder<TodayPlanCubit, TodayPlanState>(
  builder: (context, state) {
    if (state is TodayPlanCompleted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Plan completed! 🎉')),
      );
    }
  },
)
```

---

### 4. **Chat Feature** ✅

**API Endpoints**:

- `POST /api/chatbot/send` - Send message to AI
- `GET /api/chatbot/history` - Get chat history

**Cubits Methods**:

- `sendMessage(message)` - Send user message
- `getChatHistory()` - Load conversation history

**Usage in UI**:

```dart
BlocBuilder<ChatCubit, ChatState>(
  builder: (context, state) {
    if (state is ChatSuccess) {
      return ListView.builder(
        reverse: true,
        itemCount: state.messages.length,
        itemBuilder: (context, index) {
          final msg = state.messages[index];
          return ChatBubble(
            message: msg.text,
            isSent: msg.sender == 'user',
          );
        },
      );
    }
    return SizedBox.shrink();
  },
)

// Send message
ElevatedButton(
  onPressed: () {
    context.read<ChatCubit>().sendMessage(messageController.text);
  },
  child: Text('Send'),
)
```

---

### 5. **Progress Feature** ✅

**API Endpoints**:

- `GET /api/home/progress` - Get progress summary
- `GET /api/monthly-assessment/trend/{childId}` - Get improvement trend
- `GET /api/activities/stats/{childId}` - Get activity statistics

**Cubits Methods**:

- `getProgressSummary()` - Fetch overall progress
- `getTrend(childId)` - Get improvement trend
- `getActivityStats(childId)` - Get activity completion stats

**Usage Example**:

```dart
BlocBuilder<ProgressCubit, ProgressState>(
  builder: (context, state) {
    if (state is ProgressLoaded) {
      return Column(
        children: [
          ProgressChart(data: state.trendData),
          StatisticsCard(stats: state.stats),
          ImprovementIndicator(trend: state.trend),
        ],
      );
    }
    return SizedBox.shrink();
  },
)
```

---

### 6. **Tests Feature** ✅

**API Endpoints**:

- `GET /api/tests/questions/{testType}` - Get test questions
- `POST /api/tests/submit` - Submit test answers
- `GET /api/quiz/history/{childId}` - Get test history

**Supported Test Types**: `autism`, `adhd`, `dyslexia`

**Cubits Methods**:

- `loadTestQuestions(testType)` - Load test questions
- `submitTest(...)` - Submit test answers
- `loadTestHistory(childId)` - Get all test results

**Usage Example**:

```dart
// Load test questions
context.read<TestsCubit>().loadTestQuestions('autism');

// Submit test
context.read<TestsCubit>().submitTest(
  childId: 1,
  testType: 'autism',
  age: 5,
  sex: 'm',
  jaundice: 'yes',
  familyAsd: 'no',
  answers: [
    {'q_id': 1, 'answer': 'yes'},
    {'q_id': 2, 'answer': 'no'},
    // ... more answers
  ],
);

// Listen for results
BlocBuilder<TestsCubit, TestsState>(
  builder: (context, state) {
    if (state is TestSubmissionSuccess) {
      showDialog(
        context: context,
        builder: (_) => ResultDialog(result: state.result),
      );
    }
  },
)
```

---

### 7. **Notifications Feature** (LOCAL - NO API) ✅

**Local Notifications with Daily Quotes**

The notification system is completely local and sends daily motivational quotes to users.

#### How It Works:

1. **Daily Quote Manager** (`lib/core/managers/daily_quote_manager.dart`)
   - Stores 60+ motivational quotes
   - Rotates quotes daily based on day of year
   - Supports categories: parenting, encouragement, learning, behavior, development

2. **Local Notification Service** (`lib/core/managers/local_notification_service.dart`)
   - Initializes Flutter Local Notifications plugin
   - Schedules daily quote notifications
   - Handles Android and iOS permissions

3. **Quote Scheduling**
   - Default: 9:00 AM daily
   - Customizable time via `scheduleDailyQuoteNotification(hour, minute)`
   - Uses timezone-aware scheduling

#### Usage in Code:

```dart
// In main.dart - already initialized
final notificationService = LocalNotificationService();
await notificationService.initializeNotifications();
await notificationService.scheduleDailyQuoteNotification(hour: 9, minute: 0);

// Show immediate notification
await notificationService.showDailyQuoteNotification();

// Get today's quote
final quote = DailyQuoteManager.getDailyQuote();
```

#### Display in Notification View:

```dart
BlocBuilder<NotificationCubit, NotificationState>(
  builder: (context, state) {
    if (state is NotificationSuccess) {
      return ListView(
        children: state.notifications.map((notif) {
          return NotificationCard(
            title: notif.title,
            message: notif.message,
            timestamp: notif.timestamp,
            category: notif.category,
          );
        }).toList(),
      );
    }
    return SizedBox.shrink();
  },
)
```

#### Sample Quotes:

- "The days are long, but the years are short. Embrace every moment with your child."
- "Your child does not need to be perfect. They need to be heard."
- "Progress, not perfection, is the goal!"
- "You are enough. Your effort is enough."
- "Every child learns at their own pace. Trust the process."

---

## Error Handling

All features handle errors consistently:

```dart
// Possible error states
if (state is ArticlesError) {
  return ErrorWidget(
    message: state.message,
    onRetry: () => context.read<ArticlesCubit>().getArticles(),
  );
}
```

**Common Error Types**:

- `ServerException` - API server error (5xx)
- `NetworkException` - Network connectivity issue
- `UnauthorizedException` - Authentication failed (401)
- `ValidationException` - Invalid input
- `UnknownFailure` - Unexpected error

---

## Authentication Flow

All API requests include JWT token in header:

```
Authorization: Bearer <token>
```

Token is automatically added by the Dio interceptor:

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
  ),
);
```

---

## Dependency Injection

All dependencies are registered in `service_locator.dart`:

```dart
// Example: Articles Feature
getIt.registerLazySingleton<ArticlesRemoteDataSource>(
  () => ArticlesRemoteDataSourceImpl(apiClient: getIt<ApiClient>()),
);

getIt.registerLazySingleton<ArticlesRepository>(
  () => ArticlesRepositoryImpl(remoteDataSource: getIt<ArticlesRemoteDataSource>()),
);

getIt.registerFactory<ArticlesCubit>(
  () => ArticlesCubit(
    getAllArticlesUseCase: getIt<GetAllArticlesUseCase>(),
    // ... other use cases
  ),
);
```

---

## API Response Models

All API responses are mapped to DTOs for type safety:

**Example Article DTO**:

```dart
class ArticleDto {
  final int id;
  final String title;
  final String content;
  final String image;
  final String category;
  final String author;
  final DateTime publishedDate;
  final String description;

  ArticleDto({
    required this.id,
    required this.title,
    // ... other fields
  });
}
```

---

## Testing API Endpoints

### Using API Documentation:

1. **Get Home Data**

   ```
   GET http://api.example.com/api/home/data
   Headers: Authorization: Bearer <token>
   ```

   Response: User data, children list, today's plan, progress stats

2. **Get Articles**

   ```
   GET http://api.example.com/api/articles/all
   Headers: Authorization: Bearer <token>
   ```

3. **Send Chat Message**

   ```
   POST http://api.example.com/api/chatbot/send
   Body: {"message": "string", "conversation_id": "optional-uuid"}
   ```

4. **Submit Test**
   ```
   POST http://api.example.com/api/tests/submit
   Query: childId
   Body: {
     "testType": "adhd",
     "age": 5,
     "sex": "m",
     "jaundice": "yes",
     "familyAsd": "no",
     "answers": [{"q_id": 1, "answer": "yes"}]
   }
   ```

---

## Next Steps

1. **Update UI Views** - Integrate Cubits into existing views
2. **Add Loading States** - Show progress indicators while fetching
3. **Implement Offline Mode** - Cache data locally with Hive
4. **Add Real-time Updates** - Use WebSockets for live notifications
5. **Performance Optimization** - Add pagination and lazy loading

---

## File Structure Summary

```
lib/
├── core/
│   ├── network/
│   │   ├── api_client.dart (all API endpoints)
│   │   ├── failures.dart (error handling)
│   │   └── exceptions.dart (exception types)
│   ├── managers/
│   │   ├── daily_quote_manager.dart (quote management)
│   │   └── local_notification_service.dart (local notifications)
│   └── di/
│       └── service_locator.dart (dependency injection)
│
├── features/
│   ├── articles/
│   │   ├── data/
│   │   │   ├── datasources/articles_remote_data_source.dart
│   │   │   ├── repositories/articles_repository_impl.dart
│   │   │   └── models/article_dto.dart
│   │   ├── domain/
│   │   │   ├── entities/article_entity.dart
│   │   │   ├── repositories/articles_repository.dart
│   │   │   └── usecases/articles_usecases.dart
│   │   └── presentation/
│   │       ├── cubit/articles_cubit.dart
│   │       └── view/articles_view.dart
│   │
│   ├── home/
│   ├── chat/
│   ├── tests/
│   ├── progress/
│   ├── today_plan/
│   └── notification/
│
└── main.dart (initialization & providers)
```

---

**Version**: 1.0  
**Last Updated**: May 2026  
**Status**: All features integrated and ready for UI implementation

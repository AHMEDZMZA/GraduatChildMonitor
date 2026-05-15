# Missing & Incomplete API Endpoints

## Summary
- **Total Currently Implemented**: 25 endpoints ✅
- **Missing**: 12+ endpoints ❌
- **Separate Implementation**: 3 endpoints ⚠️

---

## 📋 MISSING ENDPOINTS TO ADD

### 1. NOTIFICATION ENDPOINTS (Priority: HIGH)
Currently using mock data - needs real API integration

```dart
// Add to ApiClient in lib/core/network/api_client.dart

// ==================== NOTIFICATION ENDPOINTS ====================
@GET('/notifications')
Future<HttpResponse<NotificationsResponse>> getNotifications(
  @Query('page') int page,
  @Query('limit') int limit,
);

@GET('/notifications/{notificationId}')
Future<HttpResponse<NotificationDetailResponse>> getNotificationDetail(
  @Path('notificationId') String notificationId,
);

@POST('/notifications/{notificationId}/read')
Future<HttpResponse<MessageResponse>> markAsRead(
  @Path('notificationId') String notificationId,
);

@DELETE('/notifications/{notificationId}')
Future<HttpResponse<MessageResponse>> deleteNotification(
  @Path('notificationId') String notificationId,
);

@POST('/notifications/clear-all')
Future<HttpResponse<MessageResponse>> clearAllNotifications();
```

**Add DTOs**:
```dart
class NotificationsResponse {
  final List<NotificationItem> notifications;
  final int total;
  final int page;
  final int limit;

  NotificationsResponse({
    required this.notifications,
    required this.total,
    required this.page,
    required this.limit,
  });

  factory NotificationsResponse.fromJson(Map<String, dynamic> json) {
    return NotificationsResponse(
      notifications: (json['notifications'] as List?)
          ?.map((e) => NotificationItem.fromJson(e))
          .toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
    );
  }
}

class NotificationItem {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;

  NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
    this.metadata,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'],
    );
  }
}

class NotificationDetailResponse {
  final String id;
  final String title;
  final String message;
  final String type;
  final bool read;
  final DateTime createdAt;
  final Map<String, dynamic>? metadata;
  final Map<String, dynamic>? relatedData;

  NotificationDetailResponse({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.read,
    required this.createdAt,
    this.metadata,
    this.relatedData,
  });

  factory NotificationDetailResponse.fromJson(Map<String, dynamic> json) {
    return NotificationDetailResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      message: json['message'] ?? '',
      type: json['type'] ?? '',
      read: json['read'] ?? false,
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
      metadata: json['metadata'],
      relatedData: json['related_data'],
    );
  }
}
```

---

### 2. CHAT ENDPOINTS (Priority: HIGH)
Not implemented at all

```dart
// Add to ApiClient

// ==================== CHAT ENDPOINTS ====================
@GET('/chat/conversations')
Future<HttpResponse<ConversationsResponse>> getConversations(
  @Query('page') int page,
  @Query('limit') int limit,
);

@GET('/chat/conversations/{conversationId}')
Future<HttpResponse<ConversationDetailResponse>> getConversationDetail(
  @Path('conversationId') String conversationId,
);

@GET('/chat/conversations/{conversationId}/messages')
Future<HttpResponse<MessagesResponse>> getMessages(
  @Path('conversationId') String conversationId,
  @Query('page') int page,
  @Query('limit') int limit,
);

@POST('/chat/conversations/start')
Future<HttpResponse<ConversationResponse>> startConversation(
  @Body() StartConversationRequest request,
);

@POST('/chat/conversations/{conversationId}/message')
Future<HttpResponse<MessageResponse>> sendMessage(
  @Path('conversationId') String conversationId,
  @Body() SendMessageRequest request,
);

@PUT('/chat/conversations/{conversationId}')
Future<HttpResponse<MessageResponse>> updateConversation(
  @Path('conversationId') String conversationId,
  @Body() UpdateConversationRequest request,
);

@DELETE('/chat/conversations/{conversationId}')
Future<HttpResponse<MessageResponse>> deleteConversation(
  @Path('conversationId') String conversationId,
);

@POST('/chat/messages/{messageId}/read')
Future<HttpResponse<MessageResponse>> markMessageAsRead(
  @Path('messageId') String messageId,
);
```

**Add DTOs**:
```dart
class ConversationsResponse {
  final List<Conversation> conversations;
  final int total;
  final int page;

  ConversationsResponse({
    required this.conversations,
    required this.total,
    required this.page,
  });

  factory ConversationsResponse.fromJson(Map<String, dynamic> json) {
    return ConversationsResponse(
      conversations: (json['conversations'] as List?)
          ?.map((e) => Conversation.fromJson(e))
          .toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
    );
  }
}

class Conversation {
  final String id;
  final String title;
  final String? lastMessage;
  final DateTime? lastMessageTime;
  final int unreadCount;
  final List<String> participants;

  Conversation({
    required this.id,
    required this.title,
    this.lastMessage,
    this.lastMessageTime,
    required this.unreadCount,
    required this.participants,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null 
          ? DateTime.parse(json['last_message_time']) 
          : null,
      unreadCount: json['unread_count'] ?? 0,
      participants: List<String>.from(json['participants'] ?? []),
    );
  }
}

class ConversationDetailResponse {
  final String id;
  final String title;
  final List<String> participants;
  final DateTime createdAt;

  ConversationDetailResponse({
    required this.id,
    required this.title,
    required this.participants,
    required this.createdAt,
  });

  factory ConversationDetailResponse.fromJson(Map<String, dynamic> json) {
    return ConversationDetailResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
      createdAt: DateTime.parse(json['created_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class MessagesResponse {
  final List<ChatMessage> messages;
  final int total;
  final int page;

  MessagesResponse({
    required this.messages,
    required this.total,
    required this.page,
  });

  factory MessagesResponse.fromJson(Map<String, dynamic> json) {
    return MessagesResponse(
      messages: (json['messages'] as List?)
          ?.map((e) => ChatMessage.fromJson(e))
          .toList() ?? [],
      total: json['total'] ?? 0,
      page: json['page'] ?? 1,
    );
  }
}

class ChatMessage {
  final String id;
  final String conversationId;
  final String senderId;
  final String senderName;
  final String text;
  final DateTime sentAt;
  final bool read;
  final List<String>? attachments;

  ChatMessage({
    required this.id,
    required this.conversationId,
    required this.senderId,
    required this.senderName,
    required this.text,
    required this.sentAt,
    required this.read,
    this.attachments,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? '',
      conversationId: json['conversation_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      senderName: json['sender_name'] ?? '',
      text: json['text'] ?? '',
      sentAt: DateTime.parse(json['sent_at'] ?? DateTime.now().toIso8601String()),
      read: json['read'] ?? false,
      attachments: (json['attachments'] as List?)?.cast<String>(),
    );
  }
}

class StartConversationRequest {
  final String title;
  final List<String> participantIds;

  StartConversationRequest({
    required this.title,
    required this.participantIds,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'participant_ids': participantIds,
  };
}

class SendMessageRequest {
  final String text;
  final List<String>? attachmentUrls;

  SendMessageRequest({
    required this.text,
    this.attachmentUrls,
  });

  Map<String, dynamic> toJson() => {
    'text': text,
    if (attachmentUrls != null) 'attachment_urls': attachmentUrls,
  };
}

class UpdateConversationRequest {
  final String title;

  UpdateConversationRequest({required this.title});

  Map<String, dynamic> toJson() => {'title': title};
}

class ConversationResponse {
  final String id;
  final String title;
  final List<String> participants;

  ConversationResponse({
    required this.id,
    required this.title,
    required this.participants,
  });

  factory ConversationResponse.fromJson(Map<String, dynamic> json) {
    return ConversationResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      participants: List<String>.from(json['participants'] ?? []),
    );
  }
}
```

---

### 3. FILE UPLOAD ENDPOINTS (Priority: MEDIUM)
For profile pictures and media attachments

```dart
// Add to ApiClient

// ==================== FILE UPLOAD ENDPOINTS ====================
@MultipartRequest()
@POST('/upload/profile-picture')
Future<HttpResponse<UploadResponse>> uploadProfilePicture(
  @Part() File file,
);

@MultipartRequest()
@POST('/upload/child-picture/{childId}')
Future<HttpResponse<UploadResponse>> uploadChildPicture(
  @Path('childId') String childId,
  @Part() File file,
);

@MultipartRequest()
@POST('/upload/attachment')
Future<HttpResponse<UploadResponse>> uploadAttachment(
  @Part() File file,
  @Part(name: 'type') String type,
);

// Add DTOs
class UploadResponse {
  final String message;
  final String fileUrl;
  final String fileId;

  UploadResponse({
    required this.message,
    required this.fileUrl,
    required this.fileId,
  });

  factory UploadResponse.fromJson(Map<String, dynamic> json) {
    return UploadResponse(
      message: json['message'] ?? '',
      fileUrl: json['file_url'] ?? '',
      fileId: json['file_id'] ?? '',
    );
  }
}
```

---

### 4. PROGRESS ENDPOINTS (Priority: HIGH)
Currently using separate client - **NEEDS CONSOLIDATION**

```dart
// CURRENT (Wrong - in separate Retrofit client):
// @GET('/api/home/progress')                           ← Wrong base path
// @GET('/api/monthly-assessment/trend/{childId}')     ← Wrong base path
// @GET('/api/activities/stats/{childId}')             ← Wrong base path

// SHOULD BE (Add to central ApiClient):
// ==================== PROGRESS ENDPOINTS ====================
@GET('/progress/summary')
Future<HttpResponse<ProgressSummaryModel>> getProgressSummary(
  @Query('childId') String childId,
);

@GET('/progress/trend/{childId}')
Future<HttpResponse<TrendModel>> getTrend(
  @Path('childId') String childId,
  @Query('period') String period,  // 'week', 'month', 'year'
);

@GET('/progress/stats/{childId}')
Future<HttpResponse<ActivityStatsModel>> getActivityStats(
  @Path('childId') String childId,
);

@GET('/monthly-assessment/{childId}')
Future<HttpResponse<MonthlyAssessmentResponse>> getMonthlyAssessment(
  @Path('childId') String childId,
  @Query('month') String month,
);

// Add DTOs if not already present
class MonthlyAssessmentResponse {
  final String month;
  final int score;
  final List<String> improvements;
  final List<String> areasForDevelopment;

  MonthlyAssessmentResponse({
    required this.month,
    required this.score,
    required this.improvements,
    required this.areasForDevelopment,
  });

  factory MonthlyAssessmentResponse.fromJson(Map<String, dynamic> json) {
    return MonthlyAssessmentResponse(
      month: json['month'] ?? '',
      score: json['score'] ?? 0,
      improvements: List<String>.from(json['improvements'] ?? []),
      areasForDevelopment: List<String>.from(json['areas_for_development'] ?? []),
    );
  }
}
```

---

### 5. ASSESSMENT/TEST ENDPOINTS (Priority: MEDIUM)
For the progress test feature

```dart
// Add to ApiClient

// ==================== ASSESSMENT ENDPOINTS ====================
@GET('/assessments')
Future<HttpResponse<AssessmentsResponse>> getAssessments(
  @Query('childId') String childId,
  @Query('page') int page,
);

@GET('/assessments/{assessmentId}')
Future<HttpResponse<AssessmentDetailResponse>> getAssessmentDetail(
  @Path('assessmentId') String assessmentId,
);

@POST('/assessments/{assessmentId}/start')
Future<HttpResponse<AssessmentSessionResponse>> startAssessment(
  @Path('assessmentId') String assessmentId,
);

@POST('/assessments/sessions/{sessionId}/submit')
Future<HttpResponse<AssessmentResultResponse>> submitAssessmentAnswers(
  @Path('sessionId') String sessionId,
  @Body() SubmitAnswersRequest request,
);

// Add DTOs
class AssessmentsResponse {
  final List<Assessment> assessments;
  final int total;

  AssessmentsResponse({required this.assessments, required this.total});

  factory AssessmentsResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentsResponse(
      assessments: (json['assessments'] as List?)
          ?.map((e) => Assessment.fromJson(e))
          .toList() ?? [],
      total: json['total'] ?? 0,
    );
  }
}

class Assessment {
  final String id;
  final String title;
  final String description;
  final int totalQuestions;
  final String category;

  Assessment({
    required this.id,
    required this.title,
    required this.description,
    required this.totalQuestions,
    required this.category,
  });

  factory Assessment.fromJson(Map<String, dynamic> json) {
    return Assessment(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      totalQuestions: json['total_questions'] ?? 0,
      category: json['category'] ?? '',
    );
  }
}

class AssessmentDetailResponse {
  final String id;
  final String title;
  final List<Question> questions;
  final int timeLimit;

  AssessmentDetailResponse({
    required this.id,
    required this.title,
    required this.questions,
    required this.timeLimit,
  });

  factory AssessmentDetailResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentDetailResponse(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      questions: (json['questions'] as List?)
          ?.map((e) => Question.fromJson(e))
          .toList() ?? [],
      timeLimit: json['time_limit'] ?? 0,
    );
  }
}

class Question {
  final String id;
  final String text;
  final List<String> options;
  final String type;  // 'multiple_choice', 'true_false', 'text'

  Question({
    required this.id,
    required this.text,
    required this.options,
    required this.type,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      id: json['id'] ?? '',
      text: json['text'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      type: json['type'] ?? 'multiple_choice',
    );
  }
}

class AssessmentSessionResponse {
  final String sessionId;
  final String assessmentId;
  final DateTime startedAt;

  AssessmentSessionResponse({
    required this.sessionId,
    required this.assessmentId,
    required this.startedAt,
  });

  factory AssessmentSessionResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentSessionResponse(
      sessionId: json['session_id'] ?? '',
      assessmentId: json['assessment_id'] ?? '',
      startedAt: DateTime.parse(json['started_at'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class SubmitAnswersRequest {
  final Map<String, String> answers;  // questionId -> answer

  SubmitAnswersRequest({required this.answers});

  Map<String, dynamic> toJson() => {'answers': answers};
}

class AssessmentResultResponse {
  final String sessionId;
  final int score;
  final int totalPoints;
  final double percentage;
  final String feedback;

  AssessmentResultResponse({
    required this.sessionId,
    required this.score,
    required this.totalPoints,
    required this.percentage,
    required this.feedback,
  });

  factory AssessmentResultResponse.fromJson(Map<String, dynamic> json) {
    return AssessmentResultResponse(
      sessionId: json['session_id'] ?? '',
      score: json['score'] ?? 0,
      totalPoints: json['total_points'] ?? 0,
      percentage: (json['percentage'] as num?)?.toDouble() ?? 0.0,
      feedback: json['feedback'] ?? '',
    );
  }
}
```

---

## 📊 IMPLEMENTATION PRIORITY

### Phase 1: Essential (Sprint 1)
- [ ] Fix Progress endpoints (consolidate to central ApiClient)
- [ ] Add Notification endpoints
- [ ] Remove mock data from Notification data source
- [ ] Update Notification DI setup

### Phase 2: Important (Sprint 2)
- [ ] Implement Chat endpoints
- [ ] Create Chat data layer (repository, data source, entities)
- [ ] Setup Chat DI
- [ ] Create Chat use cases

### Phase 3: Enhancement (Sprint 3)
- [ ] Add Assessment/Test endpoints
- [ ] Add File upload endpoints
- [ ] Implement WebSocket support (real-time)

### Phase 4: Polish (Sprint 4)
- [ ] Add pagination handling
- [ ] Implement caching with Hive
- [ ] Add offline support
- [ ] Unit tests

---

## 🔧 MIGRATION GUIDE: Progress Endpoints

**Current Structure** (Wrong):
```
ProgressRemoteDataSource uses separate @RestApi() decorator
- Separate Dio instance
- Different base path: /api/ prefix included in endpoints
- Not using central token management
```

**Target Structure** (Correct):
```
1. Remove separate ProgressRemoteDataSource Retrofit client
2. Add endpoints to central ApiClient
3. Update ProgressRemoteDataSourceImpl to use central ApiClient
4. Update DI to use central client
5. Fix endpoint paths (remove /api/ prefix)
```

**Steps**:
1. Copy these endpoints to central `ApiClient`:
   ```dart
   @GET('/progress/summary')
   @GET('/progress/trend/{childId}')
   @GET('/progress/stats/{childId}')
   ```

2. Update `lib/features/progress/data/datasources/progress_remote_data_source.dart`:
   - Remove `@RestApi()` decorator
   - Make it implement abstract class (like other data sources)
   - Inject central `ApiClient`
   - Call central endpoints

3. Delete old `progress_remote_data_source.g.dart` generated file

4. Update DI in `service_locator.dart`:
   ```dart
   // Remove: progress Dio setup
   // Update: ProgressRemoteDataSourceImpl(apiClient: getIt<ApiClient>())
   ```

---

## ✅ TESTING CHECKLIST

After implementing each endpoint set:
- [ ] Endpoint returns correct response type
- [ ] DTOs deserialize correctly
- [ ] Error responses handled properly
- [ ] Auth headers included in requests
- [ ] Tokens refreshed on 401
- [ ] Data layer correctly maps API response to domain models
- [ ] Cubit emits correct states (Loading → Success/Error)
- [ ] UI displays data correctly

---

**Last Updated**: May 15, 2026

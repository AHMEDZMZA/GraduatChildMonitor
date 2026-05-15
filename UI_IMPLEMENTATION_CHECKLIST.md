# UI Implementation Checklist

## Quick Start: Implementing Cubits in Your Views

This document provides ready-to-use code snippets for implementing each feature's API integration in the UI.

---

## 1️⃣ HOME VIEW

**File**: `lib/features/home/presentation/view/home_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/home/presentation/cubit/home_cubit.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Load home data when view initializes
    context.read<HomeCubit>().getHomeData();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is HomeError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is HomeDataLoaded) {
            final data = state.data;
            return RefreshIndicator(
              onRefresh: () => context.read<HomeCubit>().getHomeData(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Greeting Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: GreetingCard(
                        userName: data.userName,
                        greeting: data.greeting,
                      ),
                    ),

                    // Children List
                    if (data.children.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ChildrenSection(children: data.children),
                      ),

                    // Today's Plan
                    if (data.todayPlan != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TodayPlanCard(plan: data.todayPlan),
                      ),

                    // Progress Stats
                    if (data.progressStats != null)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: ProgressStatsCard(stats: data.progressStats),
                      ),

                    // Today's Activities
                    if (data.todayActivities.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TodayActivitiesSection(
                          activities: data.todayActivities,
                        ),
                      ),

                    // Recommended Articles
                    if (data.articles.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: RecommendedArticlesSection(
                          articles: data.articles,
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Add cubit method call in initState
- [ ] Handle loading state
- [ ] Handle error state with SnackBar
- [ ] Display all data from `HomeDataLoaded`
- [ ] Add RefreshIndicator for pull-to-refresh
- [ ] Test with real API data

---

## 2️⃣ ARTICLES VIEW

**File**: `lib/features/articles/presentation/view/articles_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/articles/presentation/cubit/articles_cubit.dart';

class ArticlesView extends StatefulWidget {
  const ArticlesView({Key? key}) : super(key: key);

  @override
  State<ArticlesView> createState() => _ArticlesViewState();
}

class _ArticlesViewState extends State<ArticlesView> {
  String _selectedCategory = 'all';

  @override
  void initState() {
    super.initState();
    // Load all articles on first load
    context.read<ArticlesCubit>().getArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Articles'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Category Filter
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CategoryFilter(
              selectedCategory: _selectedCategory,
              onCategorySelected: (category) {
                setState(() => _selectedCategory = category);
                if (category == 'all') {
                  context.read<ArticlesCubit>().getArticles();
                } else {
                  context.read<ArticlesCubit>()
                      .getArticlesByCategory(category);
                }
              },
            ),
          ),
          // Articles List
          Expanded(
            child: BlocBuilder<ArticlesCubit, ArticlesState>(
              builder: (context, state) {
                if (state is ArticlesLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ArticlesSuccess) {
                  if (state.articles.isEmpty) {
                    return const Center(
                      child: Text('No articles found'),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: () =>
                        context.read<ArticlesCubit>().getArticles(),
                    child: ListView.builder(
                      itemCount: state.articles.length,
                      itemBuilder: (context, index) {
                        final article = state.articles[index];
                        return ArticleCard(
                          article: article,
                          onFavoriteToggle: (isFavorite) {
                            if (isFavorite) {
                              context
                                  .read<ArticlesCubit>()
                                  .addArticleToFavorite(article.id);
                            } else {
                              context
                                  .read<ArticlesCubit>()
                                  .removeArticleFromFavorite(article.id);
                            }
                          },
                        );
                      },
                    ),
                  );
                }

                if (state is ArticlesError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ArticlesCubit>().getArticles(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Load articles on init
- [ ] Implement category filter
- [ ] Handle add/remove favorites
- [ ] Show loading spinner
- [ ] Display error with retry button
- [ ] Add pull-to-refresh
- [ ] Show empty state message

---

## 3️⃣ CHAT VIEW

**File**: `lib/features/chat/presentation/view/chat_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/chat/presentation/cubit/chat_cubit.dart';

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? _conversationId;

  @override
  void initState() {
    super.initState();
    // Load chat history on init
    context.read<ChatCubit>().getChatHistory();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    final message = _messageController.text;
    _messageController.clear();

    context.read<ChatCubit>().sendMessage(
      message,
      conversationId: _conversationId,
    );

    // Scroll to bottom
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with AI'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                if (state is ChatLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (state is ChatSuccess) {
                  _conversationId = state.conversationId;

                  if (state.messages.isEmpty) {
                    return const Center(
                      child: Text('Start a conversation'),
                    );
                  }

                  return ListView.builder(
                    controller: _scrollController,
                    itemCount: state.messages.length,
                    itemBuilder: (context, index) {
                      final message = state.messages[index];
                      final isUserMessage = message.sender == 'user';

                      return ChatBubble(
                        message: message.text,
                        isUser: isUserMessage,
                        timestamp: message.timestamp,
                      );
                    },
                  );
                }

                if (state is ChatError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () =>
                              context.read<ChatCubit>().getChatHistory(),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.all(16),
            child: BlocBuilder<ChatCubit, ChatState>(
              builder: (context, state) {
                final isSending = state is ChatSendingMessage;

                return Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _messageController,
                        enabled: !isSending,
                        decoration: InputDecoration(
                          hintText: 'Type your message...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    FloatingActionButton(
                      onPressed: isSending ? null : _sendMessage,
                      child: isSending
                          ? const SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            )
                          : const Icon(Icons.send),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}
```

### ✅ Checklist:

- [ ] Load chat history on init
- [ ] Display messages in order
- [ ] Show user vs AI messages differently
- [ ] Send message with enter key support
- [ ] Auto-scroll to latest message
- [ ] Show loading indicator while sending
- [ ] Handle errors gracefully

---

## 4️⃣ PROGRESS VIEW

**File**: `lib/features/progress/presentation/view/progress_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/progress/presentation/cubit/progress_cubit.dart';

class ProgressView extends StatefulWidget {
  const ProgressView({Key? key}) : super(key: key);

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
  @override
  void initState() {
    super.initState();
    // Load progress data
    context.read<ProgressCubit>().getChildProgress();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress & Development'),
        elevation: 0,
      ),
      body: BlocListener<ProgressCubit, ProgressState>(
        listener: (context, state) {
          if (state is ProgressError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<ProgressCubit, ProgressState>(
          builder: (context, state) {
            if (state is ProgressLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProgressLoaded) {
              return RefreshIndicator(
                onRefresh: () =>
                    context.read<ProgressCubit>().getChildProgress(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Improvement Trend
                        Text(
                          'Improvement Trend',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 16),
                        TrendCard(
                          trend: state.trend,
                          improvement: state.improvementPercentage,
                        ),
                        const SizedBox(height: 32),

                        // Progress Summary
                        Text(
                          'Progress Summary',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 16),
                        ProgressSummaryCard(
                          summary: state.progressSummary,
                        ),
                        const SizedBox(height: 32),

                        // Assessment History
                        Text(
                          'Assessment History',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 16),
                        AssessmentHistoryList(
                          assessments: state.assessments,
                        ),
                        const SizedBox(height: 32),

                        // Activity Statistics
                        Text(
                          'Activity Statistics',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        const SizedBox(height: 16),
                        ActivityStatsCard(
                          stats: state.activityStats,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Load progress on init
- [ ] Display improvement trend with icon
- [ ] Show progress summary
- [ ] Display assessment history
- [ ] Show activity statistics
- [ ] Add pull-to-refresh
- [ ] Handle errors with retry

---

## 5️⃣ TODAY PLAN VIEW

**File**: `lib/features/today_plan/presentation/view/today_plan_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/today_plan/presentation/cubit/today_plan_cubit.dart';

class TodayPlanView extends StatefulWidget {
  final String childId;

  const TodayPlanView({
    Key? key,
    required this.childId,
  }) : super(key: key);

  @override
  State<TodayPlanView> createState() => _TodayPlanViewState();
}

class _TodayPlanViewState extends State<TodayPlanView> {
  @override
  void initState() {
    super.initState();
    // Load today's plan
    context.read<TodayPlanCubit>().getTodayPlan(widget.childId);
  }

  void _completeActivity(String activityId) {
    final today = DateTime.now().toString().split(' ')[0];
    context.read<TodayPlanCubit>().completeTodayPlan(
      widget.childId,
      today,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Plan'),
        elevation: 0,
      ),
      body: BlocBuilder<TodayPlanCubit, TodayPlanState>(
        builder: (context, state) {
          if (state is TodayPlanLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is TodayPlanLoaded) {
            final plan = state.plan;
            final activities = state.activities;

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<TodayPlanCubit>().getTodayPlan(widget.childId),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Plan Header
                      PlanHeaderCard(
                        title: plan.title,
                        description: plan.description,
                        date: plan.date,
                      ),
                      const SizedBox(height: 24),

                      // Activities
                      Text(
                        'Activities (${activities.length})',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      const SizedBox(height: 16),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activities.length,
                        itemBuilder: (context, index) {
                          final activity = activities[index];
                          return ActivityTile(
                            activity: activity,
                            onComplete: () =>
                                _completeActivity(activity.id),
                          );
                        },
                      ),
                      const SizedBox(height: 24),

                      // Complete Plan Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _completeActivity(''),
                          icon: const Icon(Icons.check_circle),
                          label: const Text('Complete Today\'s Plan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (state is TodayPlanError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<TodayPlanCubit>()
                        .getTodayPlan(widget.childId),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Load plan on init
- [ ] Display all activities
- [ ] Mark activities as complete
- [ ] Mark entire plan as complete
- [ ] Show plan details (date, description)
- [ ] Add pull-to-refresh
- [ ] Handle errors with retry

---

## 6️⃣ TESTS VIEW

**File**: `lib/features/tests/presentation/view/tests_view.dart`

### Implementation:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/tests/presentation/cubit/tests_cubit.dart';

class TestsView extends StatefulWidget {
  const TestsView({Key? key}) : super(key: key);

  @override
  State<TestsView> createState() => _TestsViewState();
}

class _TestsViewState extends State<TestsView> {
  final List<String> testTypes = ['adhd', 'autism', 'dyslexia'];
  String? selectedTest;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Psychological Tests'),
        elevation: 0,
      ),
      body: BlocListener<TestsCubit, TestsState>(
        listener: (context, state) {
          if (state is TestSubmissionSuccess) {
            showDialog(
              context: context,
              builder: (context) => ResultDialog(
                result: state.result,
              ),
            );
          } else if (state is TestsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Error: ${state.message}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Test Selection
                Text(
                  'Select Test Type',
                  style: Theme.of(context).textTheme.headline6,
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: testTypes.length,
                  itemBuilder: (context, index) {
                    final testType = testTypes[index];
                    return TestTypeCard(
                      testType: testType,
                      onTap: () {
                        context
                            .read<TestsCubit>()
                            .loadTestQuestions(testType);
                        setState(() => selectedTest = testType);
                      },
                    );
                  },
                ),
                const SizedBox(height: 32),

                // Test Questions
                if (selectedTest != null)
                  BlocBuilder<TestsCubit, TestsState>(
                    builder: (context, state) {
                      if (state is TestsLoading) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (state is TestQuestionsLoaded) {
                        return TestQuestionsForm(
                          test: state.test,
                          onSubmit: (answers) {
                            context.read<TestsCubit>().submitTest(
                              childId: 1, // Get from user context
                              testType: selectedTest!,
                              age: 5,
                              sex: 'm',
                              jaundice: 'yes',
                              familyAsd: 'no',
                              answers: answers,
                            );
                          },
                        );
                      }

                      if (state is TestsError) {
                        return Center(
                          child: Column(
                            children: [
                              Text('Error: ${state.message}'),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<TestsCubit>()
                                    .loadTestQuestions(selectedTest!),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Display all test types
- [ ] Load questions when test selected
- [ ] Display all questions with options
- [ ] Submit test answers
- [ ] Show test results
- [ ] Display previous test history
- [ ] Handle errors gracefully

---

## 7️⃣ NOTIFICATIONS VIEW

**File**: `lib/features/notification/presentation/view/notification_view.dart`

### Implementation (Daily Quotes - ALREADY SET UP):

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:child_monitor_app/features/notification/presentation/cubit/notification_cubit.dart';
import 'package:child_monitor_app/core/managers/daily_quote_manager.dart';

class NotificationView extends StatefulWidget {
  const NotificationView({Key? key}) : super(key: key);

  @override
  State<NotificationView> createState() => _NotificationViewState();
}

class _NotificationViewState extends State<NotificationView> {
  @override
  void initState() {
    super.initState();
    // Load notifications
    context.read<NotificationCubit>().getNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications & Daily Quotes'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () =>
                context.read<NotificationCubit>().getNotifications(),
          ),
        ],
      ),
      body: BlocBuilder<NotificationCubit, NotificationState>(
        builder: (context, state) {
          if (state is NotificationLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is NotificationSuccess) {
            final notifications = state.notifications;

            if (notifications.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.notifications_off,
                      size: 64,
                      color: Colors.grey,
                    ),
                    const SizedBox(height: 16),
                    const Text('No notifications yet'),
                    const SizedBox(height: 24),
                    // Show today's quote
                    TodayQuoteCard(),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () =>
                  context.read<NotificationCubit>().getNotifications(),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                children: [
                  // Today's Quote
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TodayQuoteCard(),
                  ),
                  const SizedBox(height: 24),

                  // Notification History
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      'Notification History',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Notifications List
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notif = notifications[index];
                      return NotificationCard(
                        title: notif.title,
                        message: notif.message,
                        timestamp: notif.timestamp,
                        category: notif.category,
                      );
                    },
                  ),
                ],
              ),
            );
          }

          if (state is NotificationError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () =>
                        context.read<NotificationCubit>().getNotifications(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}

// Widget to display today's quote
class TodayQuoteCard extends StatelessWidget {
  const TodayQuoteCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final quote = DailyQuoteManager.getRandomQuote();

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.lightbulb_outline,
                  color: Colors.amber,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Text(
                  'Today\'s Quote',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              quote,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
```

### ✅ Checklist:

- [ ] Load notifications on init
- [ ] Display today's quote prominently
- [ ] Show notification history
- [ ] Add timestamp to each notification
- [ ] Color-code by category
- [ ] Add pull-to-refresh
- [ ] Handle errors

---

## 🚀 Implementation Order (Recommended)

1. **Home** - Most important, aggregates other data
2. **Articles** - Simple list, good for learning
3. **Notifications** - Already mostly implemented
4. **Today Plan** - Depends on Home data
5. **Progress** - Display charts/stats
6. **Chat** - Real-time messaging
7. **Tests** - Complex form handling

---

## 📝 Common Issues & Solutions

### Issue: "Cubit not found" error

```dart
// Solution: Make sure cubit is provided in MultiBlocProvider
// In main.dart, add:
BlocProvider<XyzCubit>(create: (_) => getIt<XyzCubit>())
```

### Issue: Data not updating after action

```dart
// Solution: Reload data after action
context.read<ArticlesCubit>().getArticles();
```

### Issue: Null pointer exception on state.data

```dart
// Solution: Check state type first
if (state is StateNameLoaded) {
  // Now safe to access state.data
}
```

### Issue: Image not loading from API

```dart
// Solution: Use full URL from API
Image.network(
  article.imageUrl, // Must be full URL
  errorBuilder: (context, error, stackTrace) {
    return const Placeholder();
  },
)
```

---

## 🎯 Testing Checklist

For each feature, test:

- [ ] Load state shows spinner
- [ ] Data loads and displays correctly
- [ ] Error state shows error message
- [ ] Empty state handled gracefully
- [ ] Pull-to-refresh works
- [ ] Actions (favorite, complete, etc) work
- [ ] Navigation to detail views works
- [ ] Offline handling (if applicable)

---

**Ready to implement!** 🚀

Copy and paste the code snippets above into your views and customize as needed.

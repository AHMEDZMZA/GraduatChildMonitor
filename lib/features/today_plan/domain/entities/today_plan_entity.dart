import 'package:equatable/equatable.dart';

class PlanEntity extends Equatable {
  final String id;
  final String date;
  final String status;
  final List<ActivityEntity> activities;

  const PlanEntity({
    required this.id,
    required this.date,
    required this.status,
    required this.activities,
  });

  @override
  List<Object?> get props => [id, date, status, activities];
}

class ActivityEntity extends Equatable {
  final String id;
  final String title;
  final String? description;
  final String type;
  final bool completed;

  const ActivityEntity({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.completed,
  });

  @override
  List<Object?> get props => [id, title, description, type, completed];
}

class HomeDataEntity extends Equatable {
  final String userName;
  final String greeting;
  final List<ChildEntity> children;
  final PlanEntity? todayPlan;
  final List<ActivityEntity> todayActivities;
  final Map<String, dynamic>? progressStats;
  final List<ArticleEntity> articles;

  const HomeDataEntity({
    required this.userName,
    required this.greeting,
    required this.children,
    this.todayPlan,
    required this.todayActivities,
    this.progressStats,
    required this.articles,
  });

  @override
  List<Object?> get props => [
    userName,
    greeting,
    children,
    todayPlan,
    todayActivities,
    progressStats,
    articles,
  ];
}

class ChildEntity extends Equatable {
  final String id;
  final String name;
  final String birthDate;
  final String gender;
  final bool knowsCondition;
  final String? diagnosedCondition;

  const ChildEntity({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.knowsCondition,
    this.diagnosedCondition,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    birthDate,
    gender,
    knowsCondition,
    diagnosedCondition,
  ];
}

class ArticleEntity extends Equatable {
  final String id;
  final String title;
  final String content;
  final String? image;
  final String category;
  final String? author;
  final String? publishedDate;
  final String? description;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.content,
    this.image,
    required this.category,
    this.author,
    this.publishedDate,
    this.description,
  });

  @override
  List<Object?> get props => [
    id,
    title,
    content,
    image,
    category,
    author,
    publishedDate,
    description,
  ];
}

import 'package:equatable/equatable.dart';

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

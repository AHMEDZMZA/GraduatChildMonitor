class ArticleModel {
  final String title;
  final String description;
  final String image;
  final bool isFavourite;

  const ArticleModel({
    required this.title,
    required this.description,
    required this.image,
    this.isFavourite = false,
  });

  ArticleModel copyWith({
    String? title,
    String? description,
    String? image,
    bool? isFavourite,
  }) {
    return ArticleModel(
      title: title ?? this.title,
      description: description ?? this.description,
      image: image ?? this.image,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
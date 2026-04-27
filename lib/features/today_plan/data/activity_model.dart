class ActivityStepModel {
  final String image;
  final String title;
  final String description;
  final String note;

  const ActivityStepModel({
    required this.image,
    required this.title,
    required this.description,
    required this.note,
  });
}

class ActivityModel {
  final String title;
  final String shortDescription;
  final String image;
  final String duration;
  final String difficulty;
  final String suitableAge;
  final List<ActivityStepModel> steps;
  final bool completed;
  final bool highlighted;

  const ActivityModel({
    required this.title,
    required this.shortDescription,
    required this.image,
    required this.duration,
    required this.difficulty,
    required this.suitableAge,
    required this.steps,
    this.completed = false,
    this.highlighted = false,
  });

  ActivityModel copyWith({
    String? title,
    String? shortDescription,
    String? image,
    String? duration,
    String? difficulty,
    String? suitableAge,
    List<ActivityStepModel>? steps,
    bool? completed,
    bool? highlighted,
  }) {
    return ActivityModel(
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      image: image ?? this.image,
      duration: duration ?? this.duration,
      difficulty: difficulty ?? this.difficulty,
      suitableAge: suitableAge ?? this.suitableAge,
      steps: steps ?? this.steps,
      completed: completed ?? this.completed,
      highlighted: highlighted ?? this.highlighted,
    );
  }
}
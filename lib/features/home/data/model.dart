class MonthlyProgressModel {
  final int id;
  final String month;
  final String title;
  final String date;
  final bool highlighted;

  const MonthlyProgressModel({
    required this.id,
    required this.month,
    required this.title,
    required this.date,
    this.highlighted = false,
  });
}
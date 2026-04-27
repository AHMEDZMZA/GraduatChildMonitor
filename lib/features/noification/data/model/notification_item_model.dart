class NotificationItemModel {
  final String title;
  final String date;
  final bool highlighted;

  NotificationItemModel({
    required this.title,
    required this.date,
    this.highlighted = false,
  });
}

final List<NotificationItemModel> notifications = [
  NotificationItemModel(
    title: 'Great progress today!',
    date: '08 August 2024 | 03:23 AM',
    highlighted: true,
  ),
  NotificationItemModel(
    title: 'Your child completed a new task!',
    date: '08 August 2024 | 03:23 AM',
  ),
  NotificationItemModel(
    title: 'Your child is close to finishing the plan!',
    date: '08 August 2024 | 03:23 AM',
  ),
  NotificationItemModel(
    title: 'Awesome! Your child is improving 👏',
    date: '08 August 2024 | 03:23 AM',
  ),
  NotificationItemModel(
    title: "It's time for today's activity",
    date: '08 August 2024 | 03:23 AM',
  ),
];
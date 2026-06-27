import '../../domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.title,
    required super.body,
    required super.date,
    super.highlighted = false,
    super.type,
    super.quote,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      title: json['title'] as String,
      body: json['body'] as String,
      date: json['date'] as String,
      highlighted: json['highlighted'] as bool? ?? false,
      type: json['type'] as String?,
      quote: json['quote'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'date': date,
      'highlighted': highlighted,
      'type': type,
      'quote': quote,
    };
  }
}

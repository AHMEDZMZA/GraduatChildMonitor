import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String title;
  final String date;
  final bool highlighted;

  const NotificationEntity({
    required this.title,
    required this.date,
    this.highlighted = false,
  });

  @override
  List<Object?> get props => [title, date, highlighted];
}

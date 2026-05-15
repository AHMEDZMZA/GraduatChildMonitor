import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String title;
  final String date;
  final bool highlighted;
  final String? type; // 'daily_quote', 'reminder', 'alert'
  final String? quote; // For daily quotes

  const NotificationEntity({
    required this.title,
    required this.date,
    this.highlighted = false,
    this.type,
    this.quote,
  });

  @override
  List<Object?> get props => [title, date, highlighted, type, quote];
}

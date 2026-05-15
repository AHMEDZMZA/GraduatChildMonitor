import 'package:flutter/material.dart';

enum ContentType { help, failure, success, warning }

void showAwesomeSnackBar(
    BuildContext context, {
      required String title,
      required String message,
      required ContentType type,
    }) {
  Color bgColor = Colors.blue;
  if (type == ContentType.failure) bgColor = Colors.red;
  if (type == ContentType.success) bgColor = Colors.green;
  if (type == ContentType.warning) bgColor = Colors.orange;

  final snackBar = SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: bgColor,
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 4),
        Text(message),
      ],
    ),
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(snackBar);
}

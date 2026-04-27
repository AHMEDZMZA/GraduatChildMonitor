// import 'package:flutter/material.dart';
//
// import '../../../domain/entities/auth_failure.dart';
//
// class ErrorDialogUtils {
//   static Future<void> showErrorDialog({
//     required BuildContext context,
//     required AuthFailure failure,
//   }) async {
//     final (icon, color) = _getIconAndColor(failure);
//
//     return showDialog(
//       context: context,
//       barrierDismissible: false,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(16),
//           ),
//           content: SingleChildScrollView(
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Container(
//                   decoration: BoxDecoration(
//                     color: color.withValues(alpha: 0.1),
//                     shape: BoxShape.circle,
//                   ),
//                   padding: const EdgeInsets.all(12),
//                   child: Icon(icon, color: color, size: 48),
//                 ),
//                 const SizedBox(height: 16),
//                 Text(
//                   _getErrorTitle(failure),
//                   style: Theme.of(context).textTheme.titleLarge?.copyWith(
//                     fontWeight: FontWeight.bold,
//                     color: color,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   failure.message,
//                   style: Theme.of(
//                     context,
//                   ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
//                   textAlign: TextAlign.center,
//                 ),
//               ],
//             ),
//           ),
//           actions: [
//             ElevatedButton(
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: color,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//               ),
//               onPressed: () => Navigator.of(context).pop(),
//               child: const Text('OK', style: TextStyle(color: Colors.white)),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   static (IconData, Color) _getIconAndColor(AuthFailure failure) {
//     if (failure is ServerFailure) {
//       return (Icons.cloud_off, Colors.red);
//     } else if (failure is NetworkFailure) {
//       return (Icons.wifi_off, Colors.orange);
//     } else if (failure is ValidationFailure) {
//       return (Icons.warning_amber, Colors.amber);
//     } else if (failure is UnauthorizedFailure) {
//       return (Icons.lock_outline, Colors.red);
//     } else if (failure is CacheFailure) {
//       return (Icons.storage, Colors.redAccent);
//     } else {
//       return (Icons.error_outline, Colors.grey);
//     }
//   }
//
//   static String _getErrorTitle(AuthFailure failure) {
//     if (failure is ServerFailure) {
//       return 'Server Error';
//     } else if (failure is NetworkFailure) {
//       return 'Network Error';
//     } else if (failure is ValidationFailure) {
//       return 'Invalid Input';
//     } else if (failure is UnauthorizedFailure) {
//       return 'Unauthorized';
//     } else if (failure is CacheFailure) {
//       return 'Cache Error';
//     } else {
//       return 'Error';
//     }
//   }
// }

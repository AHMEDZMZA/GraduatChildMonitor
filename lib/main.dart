import 'package:child_monitor_app/features/splash/presentation/view/splash_view.dart';
import 'package:flutter/material.dart';
import 'core/managers/color_manager.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          scaffoldBackgroundColor: ColorManager.backgroundWhite
      ),
      debugShowCheckedModeBanner: false,
      home: SplashView(),
    );
  }
}


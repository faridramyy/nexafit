import 'package:flutter/material.dart';
import 'package:nexafit/core/theme/theme.dart';
import 'package:nexafit/features/ThemeTestScreen/presentation/screens/theme_test_screen.dart';
import 'package:nexafit/features/onboarding/presentation/screens/onboarding_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Nexafit',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      home: const ThemeTestScreen(),
    );
  }
}

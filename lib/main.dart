import 'package:flutter/material.dart';
import 'package:nexafit/core/constants/app_routes.dart';
import 'package:nexafit/core/theme/theme.dart';
import 'package:nexafit/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/login_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/signup_screen.dart';
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
      initialRoute: AppRoutes.onboarding,
      routes: {
        AppRoutes.onboarding: (_) => const OnBoarding(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignUpScreen(),
        AppRoutes.forgotPassword: (_) => const ForgetPasswordScreen(),
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nexafit/core/constants/app_routes.dart';
import 'package:nexafit/core/theme/theme.dart';
import 'package:nexafit/features/ThemeTestScreen/presentation/screens/theme_test_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/login_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/signup_screen.dart';
import 'package:nexafit/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tlurhtvopokteqoyjvyu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRsdXJodHZvcG9rdGVxb3lqdnl1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDc1ODM4NDUsImV4cCI6MjA2MzE1OTg0NX0.WSzUGFSXXPvJD8IZpi1jDkIOrimV_nOoJ6_VewGed5g',
  );

  runApp(MyApp());
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
        AppRoutes.themeTest: (_) => const ThemeTestScreen(),
        AppRoutes.onboarding: (_) => const OnBoarding(),
        AppRoutes.login: (_) => const LoginScreen(),
        AppRoutes.signup: (_) => const SignUpScreen(),
        AppRoutes.forgotPassword: (_) => const ForgetPasswordScreen(),
      },
    );
  }
}

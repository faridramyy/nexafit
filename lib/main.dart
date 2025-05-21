import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nexafit/core/constants/app_routes.dart';
import 'package:nexafit/core/theme/theme.dart';
import 'package:nexafit/features/ThemeTestScreen/presentation/screens/theme_test_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/forgot_password_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/login_screen.dart';
import 'package:nexafit/features/auth/presentation/screens/signup_screen.dart';
import 'package:nexafit/features/chat/presentation/screens/chat_screen.dart';
import 'package:nexafit/features/meals/presentation/screens/meals_screen.dart';
import 'package:nexafit/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:nexafit/features/profile/presentation/screens/profile_screen.dart';
import 'package:nexafit/features/workouts/presentation/screens/workouts_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:ui';

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
      home: const AuthGate(),
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

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        final session = Supabase.instance.client.auth.currentSession;
        if (session != null) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  static const List<Widget> _widgetOptions = <Widget>[
    ChatScreen(),
    WorkoutsScreen(),
    ThemeTestScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          _widgetOptions.elementAt(_selectedIndex),
          Positioned(
            left: 20,
            right: 20,
            bottom: 25,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 15,
                        color: Colors.black,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15.0,
                      vertical: 8,
                    ),
                    child: GNav(
                      rippleColor: Theme.of(context).colorScheme.primary,
                      hoverColor: Theme.of(context).colorScheme.primary,
                      gap: 8,
                      activeColor: Theme.of(context).colorScheme.onPrimary,
                      iconSize: 20,
                      padding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      duration: Duration(milliseconds: 300),
                      tabBackgroundColor: Theme.of(context).colorScheme.primary,
                      color: Theme.of(context).colorScheme.inverseSurface,
                      tabs: [
                        GButton(icon: FontAwesomeIcons.comments, text: 'Chat'),
                        GButton(
                          icon: FontAwesomeIcons.dumbbell,
                          text: 'Workouts',
                        ),
                        GButton(icon: FontAwesomeIcons.utensils, text: 'Meals'),
                        GButton(icon: FontAwesomeIcons.user, text: 'Profile'),
                      ],
                      selectedIndex: _selectedIndex,
                      onTabChange: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

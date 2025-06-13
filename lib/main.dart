import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nexafit/routes/app_routes.dart';
import 'package:nexafit/theme/theme.dart';
import 'package:nexafit/screens/theme_test_screen.dart';
import 'package:nexafit/screens/forgot_password_screen.dart';
import 'package:nexafit/screens/login_screen.dart';
import 'package:nexafit/screens/signup_screen.dart';
import 'package:nexafit/screens/chat_screen.dart';
import 'package:nexafit/screens/meals_screen.dart';
import 'package:nexafit/screens/onboarding_screen.dart';
import 'package:nexafit/screens/profile_screen.dart';
import 'package:nexafit/screens/workouts_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexafit/services/theme_service.dart';
import 'dart:ui';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://nbvwlshvhclozmalypuo.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im5idndsc2h2aGNsb3ptYWx5cHVvIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDg5MDI1NTMsImV4cCI6MjA2NDQ3ODU1M30.KI0uT8QHwjMFv7IUqL5t28TzHJWy_N7A-1X_dqMXRk0',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeServiceProvider);

    return MaterialApp(
      title: 'Nexafit',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
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
        final session = snapshot.data?.session;
        if (session != null) {
          return const HomeScreen();
        } else {
          return const OnBoarding();
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
    MealsScreen(),
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

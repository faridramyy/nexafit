import 'package:flutter/material.dart';
import 'package:nexafit/routes/app_routes.dart';
import 'package:nexafit/screens/edit_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexafit/services/theme_service.dart';
import 'package:nexafit/services/profile_service.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _profileService = ProfileService();
  Map<String, dynamic>? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    try {
      final profile = await _profileService.getProfile();
      if (profile == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No profile found. Please try logging in again.'),
              duration: Duration(seconds: 5),
            ),
          );
        }
      }
      setState(() {
        _profile = profile;
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading profile: $e');
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to load profile: ${e.toString()}'),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
              // Reload profile after returning from edit screen
              _loadProfile();
            },
          ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      // backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _profile?['full_name'] ?? 'No name set',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      _profile?['username'] ?? 'No username set',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Activity Overview',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        _StatCard(title: 'Workouts', value: '124'),
                        _StatCard(title: 'Calories', value: '16k'),
                        _StatCard(title: 'Challenges', value: '8'),
                      ],
                    ),
                    const SizedBox(height: 32),
                    const Divider(height: 32),

                    // Profile Details
                    _ProfileDetail(
                      icon: Icons.person,
                      label: 'Age',
                      value: _profile?['age']?.toString() ?? 'Not set',
                    ),
                    _ProfileDetail(
                      icon: Icons.height,
                      label: 'Height',
                      value:
                          _profile?['height_cm'] != null
                              ? '${_profile!['height_cm']} cm'
                              : 'Not set',
                    ),
                    _ProfileDetail(
                      icon: Icons.monitor_weight,
                      label: 'Weight',
                      value:
                          _profile?['weight_kg'] != null
                              ? '${_profile!['weight_kg']} kg'
                              : 'Not set',
                    ),
                    _ProfileDetail(
                      icon: Icons.fitness_center,
                      label: 'Fitness Level',
                      value: _profile?['fitness_level'] ?? 'Not set',
                    ),
                    _ProfileDetail(
                      icon: Icons.flag,
                      label: 'Goal',
                      value: _profile?['goal'] ?? 'Not set',
                    ),
                    _ProfileDetail(
                      icon: Icons.calendar_today,
                      label: 'Training Days',
                      value:
                          _profile?['training_days_per_week']?.toString() ??
                          'Not set',
                    ),

                    // Theme Option
                    _ProfileOption(
                      icon: Icons.palette,
                      label: 'Theme',
                      onTap: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text('Choose Theme'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    ListTile(
                                      title: const Text('Light'),
                                      leading: const Icon(Icons.light_mode),
                                      onTap: () {
                                        ref
                                            .read(themeServiceProvider.notifier)
                                            .setThemeMode(ThemeMode.light);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('Dark'),
                                      leading: const Icon(Icons.dark_mode),
                                      onTap: () {
                                        ref
                                            .read(themeServiceProvider.notifier)
                                            .setThemeMode(ThemeMode.dark);
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      title: const Text('System'),
                                      leading: const Icon(
                                        Icons.settings_suggest,
                                      ),
                                      onTap: () {
                                        ref
                                            .read(themeServiceProvider.notifier)
                                            .setThemeMode(ThemeMode.system);
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                        );
                      },
                    ),

                    // Logout button
                    _ProfileOption(
                      icon: Icons.logout,
                      label: 'Logout',
                      iconColor: Colors.red,
                      onTap: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("Confirm Logout"),
                                content: const Text(
                                  "Are you sure you want to logout?",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed:
                                        () => Navigator.of(context).pop(true),
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ),
                        );

                        if (confirm == true) {
                          final supabase = Supabase.instance.client;
                          await supabase.auth.signOut();
                          if (mounted) {
                            Navigator.pushNamed(context, AppRoutes.login);
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
    );
  }
}

class _ProfileDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _ProfileDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Text(
        value,
        style: TextStyle(color: Theme.of(context).colorScheme.primary),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;

  const _StatCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(title, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

class _ProfileOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final VoidCallback? onTap;

  const _ProfileOption({
    required this.icon,
    required this.label,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      title: Text(label),
      onTap: onTap,
    );
  }
}

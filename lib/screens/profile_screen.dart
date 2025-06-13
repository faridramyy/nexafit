import 'package:flutter/material.dart';
import 'package:nexafit/routes/app_routes.dart';
import 'package:nexafit/screens/edit_profile_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nexafit/services/theme_service.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const EditProfileScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage('assets/images/avatar_placeholder.png'),
            ),
            const SizedBox(height: 12),
            const Text(
              'Farid Ramy',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'faridramy2003@gmail.com',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            const Text(
              'Activity Overview',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                              leading: const Icon(Icons.settings_suggest),
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

            // ✅ Logout button with Supabase
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
                        content: const Text("Are you sure you want to logout?"),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text("Cancel"),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text("Logout"),
                          ),
                        ],
                      ),
                );

                if (confirm == true) {
                  final supabase = Supabase.instance.client;
                  await supabase.auth.signOut();
                  Navigator.pushNamed(context, AppRoutes.login);
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

import 'package:flutter/material.dart';
import 'package:nexafit/features/profile/presentation/screens/edit_profile_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            // Avatar & Name
            const CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage(
              //   'assets/images/avatar_placeholder.png',
              // ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Mostafa Hady',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'mostafa@email.com',
              style: TextStyle(color: Colors.grey),
            ),

            const SizedBox(height: 24),

            // Activity stats
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

            // Settings & Options
            const Divider(height: 32),
            const _ProfileOption(icon: Icons.settings, label: 'Settings'),
            const _ProfileOption(
              icon: Icons.security,
              label: 'Privacy & Security',
            ),
            const _ProfileOption(
              icon: Icons.notifications,
              label: 'Notifications',
            ),
            const _ProfileOption(icon: Icons.star, label: 'Upgrade to Premium'),
            const _ProfileOption(
              icon: Icons.help_outline,
              label: 'Help & Support',
            ),
            const _ProfileOption(
              icon: Icons.logout,
              label: 'Logout',
              iconColor: Colors.red,
            ),
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

  const _ProfileOption({
    required this.icon,
    required this.label,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: iconColor ?? Theme.of(context).iconTheme.color,
      ),
      title: Text(label),
      onTap: () {},
    );
  }
}

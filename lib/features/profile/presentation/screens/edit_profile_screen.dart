import 'package:flutter/material.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        centerTitle: true,
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const CircleAvatar(
              radius: 50,
              // backgroundImage: AssetImage(
              //   'assets/images/avatar_placeholder.png',
              // ),
            ),
            const SizedBox(height: 8),
            TextButton(onPressed: () {}, child: const Text('Change Picture')),
            const SizedBox(height: 24),
            const SectionTitle('Public profile data'),
            _buildEditableField(
              context: context,
              label: 'Name',
              value: 'Farid Ramy',
            ),
            _buildEditableField(
              context: context,
              label: 'Weight',
              value: '70 kg',
            ),
            _buildEditableField(
              context: context,
              label: 'Height',
              value: '175 cm',
            ),
            _buildEditableField(context: context, label: 'Bio', value: 'Human'),
            _buildEditableField(
              context: context,
              label: 'Link',
              value: 'https://example.com',
            ),
            const SizedBox(height: 24),
            const SectionTitle('Private data', withInfo: true),
            _buildEditableField(context: context, label: 'Sex', value: 'Male'),
            _buildEditableField(
              context: context,
              label: 'Birthday',
              value: 'Dec 22, 2003',
            ),
            _buildEditableField(
              context: context,
              label: 'Country',
              value: 'Egypt',
            ),
            _buildEditableField(
              context: context,
              label: 'Goal',
              value: 'Muscle Gain',
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buildEditableField({
  required BuildContext context,
  required String label,
  required String value,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const SizedBox(height: 12),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Text(
            value,
            style: TextStyle(
              color: Theme.of(context).colorScheme.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
      const Divider(),
    ],
  );
}

class SectionTitle extends StatelessWidget {
  final String title;
  final bool withInfo;

  const SectionTitle(this.title, {this.withInfo = false, super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
        if (withInfo)
          const Padding(
            padding: EdgeInsets.only(left: 4),
            child: Icon(Icons.info_outline, color: Colors.grey, size: 16),
          ),
      ],
    );
  }
}

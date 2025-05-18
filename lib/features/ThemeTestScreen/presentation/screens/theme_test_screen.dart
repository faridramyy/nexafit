import 'package:flutter/material.dart';

class ThemeTestScreen extends StatefulWidget {
  const ThemeTestScreen({Key? key}) : super(key: key);

  @override
  State<ThemeTestScreen> createState() => _ThemeTestScreenState();
}

class _ThemeTestScreenState extends State<ThemeTestScreen> {
  bool _switchValue = false;
  bool _checkboxValue = false;
  double _sliderValue = 0.5;
  String _dropdownValue = 'Beginner';
  int _selectedSegment = 0;
  int? _radioValue = 1;

  final TextEditingController _controller = TextEditingController();

  final Map<int, Widget> _segments = const {
    0: Text('Free'),
    1: Text('Premium'),
  };

  void _showSnackbar() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('This is a themed Snackbar!'),
        action: SnackBarAction(label: 'Undo', onPressed: () {}),
      ),
    );
  }

  void _showModalDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('NexaFit Modal'),
            content: const Text('This is a modal dialog.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  void _showBottomSheet() {
    showModalBottomSheet(
      context: context,
      builder:
          (_) => Container(
            padding: const EdgeInsets.all(16),
            child: const Text('This is a bottom sheet.'),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final spacing = const SizedBox(height: 16);
    final sectionSpacing = const SizedBox(height: 24);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NexaFit Theme Test'),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            itemBuilder:
                (context) => [
                  const PopupMenuItem(
                    value: 'settings',
                    child: Text('Settings'),
                  ),
                  const PopupMenuItem(value: 'about', child: Text('About')),
                ],
            onSelected: (value) {
              if (value == 'about') _showModalDialog();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showBottomSheet,
        tooltip: 'Bottom Sheet',
        child: const Icon(Icons.expand_less),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🎨 Text Styles', style: theme.textTheme.titleLarge),
            spacing,
            Text('DisplayLarge', style: theme.textTheme.displayLarge),
            Text('HeadlineSmall', style: theme.textTheme.headlineSmall),
            Text('TitleMedium', style: theme.textTheme.titleMedium),
            Text('BodyMedium', style: theme.textTheme.bodyMedium),
            sectionSpacing,

            const Divider(),

            Text('🔘 Buttons', style: theme.textTheme.titleLarge),
            spacing,
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ElevatedButton(
                  onPressed: _showSnackbar,
                  child: const Text('Elevated'),
                ),
                OutlinedButton(onPressed: () {}, child: const Text('Outlined')),
                TextButton(onPressed: () {}, child: const Text('Text')),
                FilledButton(onPressed: () {}, child: const Text('Filled')),
                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                  tooltip: 'Like',
                ),
              ],
            ),
            sectionSpacing,

            Text('📦 Cards', style: theme.textTheme.titleLarge),
            spacing,
            Card(
              child: ListTile(
                leading: const Icon(Icons.fitness_center),
                title: const Text('AI Trainer'),
                trailing: FilledButton(
                  onPressed: () {},
                  child: const Text('Try'),
                ),
              ),
            ),
            spacing,
            Chip(
              label: const Text('Workout'),
              avatar: const Icon(Icons.run_circle),
            ),
            sectionSpacing,

            Text('📩 Inputs & Toggles', style: theme.textTheme.titleLarge),
            spacing,
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            spacing,
            DropdownButton<String>(
              value: _dropdownValue,
              items:
                  ['Beginner', 'Intermediate', 'Advanced']
                      .map(
                        (val) => DropdownMenuItem(value: val, child: Text(val)),
                      )
                      .toList(),
              onChanged: (val) => setState(() => _dropdownValue = val!),
            ),
            spacing,
            Slider(
              value: _sliderValue,
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
            SwitchListTile(
              title: const Text('Enable Notifications'),
              value: _switchValue,
              onChanged: (val) => setState(() => _switchValue = val),
            ),
            CheckboxListTile(
              title: const Text('I accept the terms'),
              value: _checkboxValue,
              onChanged: (val) => setState(() => _checkboxValue = val!),
            ),
            RadioListTile<int>(
              title: const Text('Free Plan'),
              value: 1,
              groupValue: _radioValue,
              onChanged: (val) => setState(() => _radioValue = val),
            ),
            RadioListTile<int>(
              title: const Text('Premium Plan'),
              value: 2,
              groupValue: _radioValue,
              onChanged: (val) => setState(() => _radioValue = val),
            ),
            sectionSpacing,

            Text('🔘 Segmented Buttons', style: theme.textTheme.titleLarge),
            spacing,
            SegmentedButton<int>(
              segments:
                  _segments.entries
                      .map((e) => ButtonSegment(value: e.key, label: e.value))
                      .toList(),
              selected: {_selectedSegment},
              onSelectionChanged:
                  (val) => setState(() => _selectedSegment = val.first),
            ),
            sectionSpacing,

            Text('⏳ Progress Indicators', style: theme.textTheme.titleLarge),
            spacing,
            const LinearProgressIndicator(value: 0.7),
            spacing,
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

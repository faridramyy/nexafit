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
  final TextEditingController _controller = TextEditingController();
  int _selectedSegment = 0;

  final Map<int, Widget> _segments = const {
    0: Text('Free'),
    1: Text('Premium'),
  };

  void _showSnackbar() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('This is a themed Snackbar!')));
  }

  void _showModalDialog() {
    showDialog(
      context: context,
      builder:
          (_) => AlertDialog(
            title: const Text('NexaFit Modal'),
            content: const Text(
              'This is a modal dialog. You can use it for confirmations or info.',
            ),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('NexaFit Theme Test'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '🎨 Text Styles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Text(
              'HeadlineSmall',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text('TitleMedium', style: Theme.of(context).textTheme.titleMedium),
            Text('BodyMedium', style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),

            const Divider(),

            const Text(
              '🔘 Buttons',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
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

                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.fitness_center),
                  label: const Text('Elevated Icon'),
                ),
                OutlinedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.directions_run),
                  label: const Text('Outlined Icon'),
                ),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Text Icon'),
                ),
                FilledButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.local_fire_department),
                  label: const Text('Filled Icon'),
                ),

                IconButton(
                  icon: const Icon(Icons.favorite),
                  onPressed: () {},
                  tooltip: 'Like',
                ),
              ],
            ),
            const SizedBox(height: 20),

            const Text(
              '📦 Cards',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: const Icon(Icons.accessibility_new, size: 32),
                title: const Text('AI Trainer'),
                subtitle: const Text('Personalized plans based on your data.'),
                trailing: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Try Now'),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              color: Theme.of(context).colorScheme.secondaryContainer,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Meal Prep Plan',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    const Text('AI-generated meals and booking options.'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        FilledButton(
                          onPressed: () {},
                          child: const Text('Book'),
                        ),
                        const SizedBox(width: 8),
                        TextButton(
                          onPressed: _showModalDialog,
                          child: const Text('More Info'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
            const Text(
              '📩 Inputs & Toggles',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

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
            const SizedBox(height: 16),

            Slider(
              value: _sliderValue,
              min: 0,
              max: 1,
              divisions: 10,
              label: '${(_sliderValue * 100).toStringAsFixed(0)}%',
              onChanged: (val) => setState(() => _sliderValue = val),
            ),
            Row(
              children: [
                Checkbox(
                  value: _checkboxValue,
                  onChanged: (val) => setState(() => _checkboxValue = val!),
                ),
                const Text('I accept the terms'),
              ],
            ),
            Row(
              children: [
                const Text('Dark Mode:'),
                Switch(
                  value: _switchValue,
                  onChanged: (val) => setState(() => _switchValue = val),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Text('🔘 Segmented Buttons'),
            SegmentedButton<int>(
              segments:
                  _segments.entries
                      .map((e) => ButtonSegment(value: e.key, label: e.value))
                      .toList(),
              selected: {_selectedSegment},
              onSelectionChanged:
                  (val) => setState(() => _selectedSegment = val.first),
            ),

            const SizedBox(height: 24),
            const Text('⏳ Progress Indicators'),
            const SizedBox(height: 8),
            const LinearProgressIndicator(value: 0.7),
            const SizedBox(height: 8),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

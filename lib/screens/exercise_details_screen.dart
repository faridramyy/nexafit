import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> exercise;

  const ExerciseDetailsScreen({super.key, required this.exercise});

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  String _getGifUrl(String? gifUrl) {
    if (gifUrl == null) return '';
    return Supabase.instance.client.storage
        .from('exercises-gif')
        .getPublicUrl(gifUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(widget.exercise['name']),
        actions: [
          IconButton(icon: Icon(Icons.share), onPressed: () {}),
          IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: 'Summary'),
            Tab(text: 'History'),
            Tab(text: 'How to'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildSummaryTab(),
          Center(child: Text('History Tab')), // Placeholder
          _buildHowToTab(),
        ],
      ),
    );
  }

  Widget _buildSummaryTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Image.network(
                _getGifUrl(widget.exercise['gif_url']),
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 180,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            widget.exercise['name'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Primary: ${widget.exercise['body_part'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Secondary: ${widget.exercise['body_part'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Equipment: ${widget.exercise['equipment'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Target: ${widget.exercise['target'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          SizedBox(height: 16),

          Text(
            'Personal Records',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          ListTile(
            leading: Icon(Icons.emoji_events, color: Colors.amber),
            title: Text('Heaviest Weight'),
            trailing: Text(
              '20kg',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeightButton(String label, bool selected) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: selected ? Colors.blue : Colors.grey[800],
        foregroundColor: Colors.white,
        shape: StadiumBorder(),
      ),
      onPressed: () {},
      child: Text(label),
    );
  }

  Widget _buildHowToTab() {
    final instructions = widget.exercise['exercise_instructions'] as List?;

    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            color: Colors.white,
            child: Center(
              child: Image.network(
                _getGifUrl(widget.exercise['gif_url']),
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 180,
                    color: Theme.of(context).colorScheme.primary,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            widget.exercise['name'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (instructions != null && instructions.isNotEmpty)
            ...instructions.asMap().entries.map((entry) {
              return _buildStep(
                entry.key + 1,
                entry.value['instruction'] as String,
              );
            }).toList()
          else
            Text('No instructions available'),
        ],
      ),
    );
  }

  Widget _buildStep(int number, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$number.',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          SizedBox(width: 8),
          Expanded(child: Text(text, style: TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
}

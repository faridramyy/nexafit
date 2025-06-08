import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexafit/services/workout_service.dart';

class ExerciseDetailsScreen extends StatefulWidget {
  final String exerciseId;

  const ExerciseDetailsScreen({super.key, required this.exerciseId});

  @override
  _ExerciseDetailsScreenState createState() => _ExerciseDetailsScreenState();
}

class _ExerciseDetailsScreenState extends State<ExerciseDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _workoutService = WorkoutService();
  Map<String, dynamic>? _exercise;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    try {
      final exercises = await _workoutService.searchExercises();
      final exercise = exercises.firstWhere(
        (e) => e['id'] == widget.exerciseId,
        orElse: () => throw Exception('Exercise not found'),
      );

      setState(() {
        _exercise = exercise;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading exercise: $e')));
      }
    }
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
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(leading: BackButton()),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_exercise == null) {
      return Scaffold(
        appBar: AppBar(leading: BackButton()),
        body: Center(child: Text('Exercise not found')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text(_exercise!['name']),
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
                _getGifUrl(_exercise!['gif_url']),
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 180,
                    color: Colors.green,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _exercise!['name'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          Text(
            'Primary: ${_exercise!['body_part'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Secondary: ${_exercise!['body_part'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Equipment: ${_exercise!['equipment'] ?? 'Unknown'}',
            style: TextStyle(color: Colors.grey),
          ),
          Text(
            'Target: ${_exercise!['target'] ?? 'Unknown'}',
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
    final instructions = _exercise!['exercise_instructions'] as List?;

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
                _getGifUrl(_exercise!['gif_url']),
                height: 180,
                errorBuilder: (context, error, stackTrace) {
                  return Icon(
                    Icons.fitness_center,
                    size: 180,
                    color: Colors.green,
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 16),
          Text(
            _exercise!['name'],
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          if (instructions != null && instructions.isNotEmpty)
            ...instructions.asMap().entries.map((entry) {
              return _buildStep(
                entry.key + 1,
                entry.value['instruction'] as String,
              );
            })
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

import 'package:flutter/material.dart';
import 'package:nexafit/services/workout_service.dart';
import 'package:nexafit/services/profile_service.dart';
import 'package:nexafit/services/gemini_service.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../widgets/workout_log_section.dart';

class WorkoutLogScreen extends StatefulWidget {
  final String workoutId;

  const WorkoutLogScreen({super.key, required this.workoutId});

  @override
  State<WorkoutLogScreen> createState() => _WorkoutLogScreenState();
}

class _WorkoutLogScreenState extends State<WorkoutLogScreen> {
  final _workoutService = WorkoutService();
  Map<String, dynamic>? _workout;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadWorkout();
  }

  Future<void> _loadWorkout() async {
    try {
      final workouts = await _workoutService.getWorkouts();
      final workout = workouts.firstWhere(
        (w) => w['id'] == widget.workoutId,
        orElse: () => throw Exception('Workout not found'),
      );
      setState(() {
        _workout = workout;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading workout: $e')));
      }
    }
  }

  Future<void> _finishWorkout() async {
    try {
      if (_workout == null) return;

      // Get user profile data
      final profileService = ProfileService();
      final profile = await profileService.getProfile();

      // Format workout data
      final workoutData = {
        'exercises':
            (_workout!['workout_exercises'] as List).map((exercise) {
              return {
                'name': exercise['exercise']?['name'] ?? 'Unknown Exercise',
                'sets':
                    (exercise['sets'] as List).map((set) {
                      return {
                        'weight': set['weight']?.toDouble() ?? 0.0,
                        'reps': set['reps'] ?? 0,
                        'completed': set['completed'] ?? false,
                      };
                    }).toList(),
              };
            }).toList(),
        'user_profile': profile,
      };

      // Create prompt for Gemini
      final exercises = workoutData['exercises'] as List<Map<String, dynamic>>;
      final prompt = """
As a professional fitness trainer, please analyze this workout and provide feedback:

User Profile:
- Age: ${profile?['age']?.toString() ?? 'Not specified'}
- Height: ${profile?['height_cm']?.toString() ?? 'Not specified'} cm
- Weight: ${profile?['weight_kg']?.toString() ?? 'Not specified'} kg
- Fitness Level: ${profile?['fitness_level']?.toString() ?? 'Not specified'}
- Goal: ${profile?['goal']?.toString() ?? 'Not specified'}

Workout Details:
${exercises.map((exercise) => """
Exercise: ${exercise['name']}
Sets:
${(exercise['sets'] as List<Map<String, dynamic>>).map((set) => "- ${set['weight']}kg x ${set['reps']} reps (${set['completed'] ? 'Completed' : 'Not completed'})").join('\n')}
""").join('\n')}

Please provide:
1. Overall assessment of the workout
2. Whether the exercises target all major muscle groups appropriately
3. Feedback on weight and rep ranges
4. Suggestions for improvements
5. Positive reinforcement for good choices

Format your response using markdown for better readability.
""";

      // Get feedback from Gemini
      final feedback = await GeminiService.getResponse(prompt);

      // Show feedback in a dialog
      if (mounted) {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: const Text('Workout Analysis'),
                content: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.7,
                    maxWidth: MediaQuery.of(context).size.width * 0.8,
                  ),
                  child: SingleChildScrollView(
                    child: MarkdownBody(
                      data: feedback,
                      styleSheet: MarkdownStyleSheet(
                        h1: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        h2: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                        p: const TextStyle(fontSize: 16),
                        listBullet: const TextStyle(fontSize: 16),
                        blockquote: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                        code: const TextStyle(
                          fontSize: 16,
                          backgroundColor: Colors.grey,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context); // Close dialog
                      Navigator.pop(context); // Return to previous screen
                    },
                    child: const Text('Close'),
                  ),
                ],
              ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error finishing workout: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Workout'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.timer_outlined)),
          TextButton(onPressed: _finishWorkout, child: const Text('Finish')),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _workout == null
              ? const Center(child: Text('Workout not found'))
              : ListView.builder(
                itemCount: (_workout!['workout_exercises'] as List).length,
                itemBuilder: (context, index) {
                  final exercise = _workout!['workout_exercises'][index];
                  final sets =
                      (exercise['sets'] as List).map((set) {
                        return WorkoutSet(
                          setId: set['id'],
                          setNumber: set['set_number'],
                          previous: '${set['weight']}kg x ${set['reps']}',
                          weight: set['weight']?.toDouble() ?? 0.0,
                          reps: set['reps'] ?? 0,
                          isCompleted: set['completed'] ?? false,
                        );
                      }).toList();

                  return WorkoutSection(
                    exerciseTitle: exercise['exercise']['name'],
                    sets: sets,
                    workoutExerciseId: exercise['id'],
                    exercise: exercise['exercise'],
                  );
                },
              ),
    );
  }
}

class WorkoutSet {
  String setId;
  final int setNumber;
  final String previous;
  double weight;
  int reps;
  bool isCompleted;

  WorkoutSet({
    required this.setId,
    required this.setNumber,
    required this.previous,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });
}

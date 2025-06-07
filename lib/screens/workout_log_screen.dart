import 'package:flutter/material.dart';
import 'package:nexafit/services/workout_service.dart';
import '../widgets/workout_section.dart';

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
      // TODO: Implement workout completion
      Navigator.pop(context);
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
                    initialSets: sets,
                    workoutExerciseId: exercise['id'],
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

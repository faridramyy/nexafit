import 'package:flutter/material.dart';
import '../widgets/workout_section.dart';

class WorkoutLogScreen extends StatelessWidget {
  const WorkoutLogScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log Workout'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.timer_outlined)),
          TextButton(onPressed: () {}, child: const Text('Finish')),
        ],
      ),
      body: ListView(
        children: [
          WorkoutSection(
            exerciseTitle: 'Bicep Curl (Dumbbell)',
            initialSets: [
              WorkoutSet(
                setNumber: 1,
                previous: '17.5kg x 10',
                weight: 17.5,
                reps: 10,
                isCompleted: true,
              ),
              WorkoutSet(
                setNumber: 2,
                previous: '17.5kg x 10',
                weight: 17.5,
                reps: 10,
              ),
            ],
          ),
          WorkoutSection(
            exerciseTitle: 'Triceps Pushdown',
            initialSets: [
              WorkoutSet(
                setNumber: 1,
                previous: '57.5kg x 10',
                weight: 57.5,
                reps: 10,
                isCompleted: true,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WorkoutSet {
  final int setNumber;
  final String previous;
  double weight;
  int reps;
  bool isCompleted;

  WorkoutSet({
    required this.setNumber,
    required this.previous,
    required this.weight,
    required this.reps,
    this.isCompleted = false,
  });
}


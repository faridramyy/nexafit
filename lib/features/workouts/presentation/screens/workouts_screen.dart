import 'package:flutter/material.dart';
import 'package:nexafit/features/workouts/presentation/screens/create_routine_sheet.dart';
import 'package:nexafit/features/workouts/presentation/screens/workout_log_screen.dart';
import 'package:nexafit/features/workouts/presentation/widgets/primary_button.dart';
import 'package:nexafit/features/workouts/presentation/widgets/routine_card.dart';
import 'package:nexafit/features/workouts/presentation/widgets/section_title.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Workout')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionTitle(title: 'Quick Start'),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              child: PrimaryButton(
                icon: Icons.add,
                label: 'Start Empty Workout',
                onPressed: () {},
              ),
            ),

            const SizedBox(height: 24),
            const SectionTitle(title: 'Routines'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: PrimaryButton(
                    icon: Icons.add_box_outlined,
                    label: 'New Routine',
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const CreateRoutineSheet(),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: PrimaryButton(
                    icon: Icons.search,
                    label: 'Explore',
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text('My Routines (3)', style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                children: [
                  RoutineCard(
                    title: 'Arms',
                    exercises: 'Bicep Curl, Triceps Pushdown, Seated Curl',
                    onStartPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutLogScreen(),
                        ),
                      );
                    },
                  ),
                  RoutineCard(
                    title: 'Back',
                    exercises: 'Cable Row, T-Bar Row',
                    onStartPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const WorkoutLogScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

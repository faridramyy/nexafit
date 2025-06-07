import 'package:flutter/material.dart';
import 'package:nexafit/screens/create_routine_sheet.dart';
import 'package:nexafit/screens/workout_log_screen.dart';
import 'package:nexafit/services/workout_service.dart';
import 'package:nexafit/widgets/primary_button.dart';
import 'package:nexafit/widgets/routine_card.dart';
import 'package:nexafit/widgets/section_title.dart';

class WorkoutsScreen extends StatefulWidget {
  const WorkoutsScreen({super.key});

  @override
  State<WorkoutsScreen> createState() => _WorkoutsScreenState();
}

class _WorkoutsScreenState extends State<WorkoutsScreen> {
  final _workoutService = WorkoutService();
  List<Map<String, dynamic>> _routines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRoutines();
  }

  Future<void> _loadRoutines() async {
    setState(() => _isLoading = true);
    try {
      final routines = await _workoutService.getRoutines();
      setState(() {
        _routines = routines;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading routines: $e')));
      }
    }
  }

  Future<void> _startEmptyWorkout() async {
    try {
      final workoutId = await _workoutService.createWorkout(
        date: DateTime.now(),
        exercises: [],
      );

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WorkoutLogScreen(workoutId: workoutId),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error starting workout: $e')));
      }
    }
  }

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
                onPressed: _startEmptyWorkout,
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
                    onPressed: () async {
                      await showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const CreateRoutineSheet(),
                      );
                      _loadRoutines();
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
            Text(
              'My Routines (${_routines.length})',
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 12),
            Expanded(
              child:
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ListView.builder(
                        itemCount: _routines.length,
                        itemBuilder: (context, index) {
                          final routine = _routines[index];
                          final exercises = (routine['routine_exercises']
                                  as List)
                              .map((e) => e['exercise']['name'] as String)
                              .join(', ');

                          return RoutineCard(
                            title: routine['name'],
                            exercises: exercises,
                            onStartPressed: () async {
                              try {
                                final workoutId = await _workoutService
                                    .createWorkout(
                                      date: DateTime.now(),
                                      exercises:
                                          (routine['routine_exercises'] as List)
                                              .map((e) {
                                                return {
                                                  'exercise_id':
                                                      e['exercise_id'],
                                                  'sets': List.generate(
                                                    e['default_sets'] ?? 3,
                                                    (i) => {
                                                      'set_number': i + 1,
                                                      'weight':
                                                          e['default_weight'],
                                                      'reps': e['default_reps'],
                                                      'rir': null,
                                                    },
                                                  ),
                                                };
                                              })
                                              .toList(),
                                    );

                                if (mounted) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => WorkoutLogScreen(
                                            workoutId: workoutId,
                                          ),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Error starting workout: $e',
                                      ),
                                    ),
                                  );
                                }
                              }
                            },
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}

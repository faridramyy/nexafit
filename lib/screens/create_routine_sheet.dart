import 'package:flutter/material.dart';
import 'package:nexafit/screens/add_exercise_sheet.dart';
import 'package:nexafit/services/workout_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateRoutineSheet extends StatefulWidget {
  const CreateRoutineSheet({super.key});

  @override
  State<CreateRoutineSheet> createState() => _CreateRoutineSheetState();
}

class _CreateRoutineSheetState extends State<CreateRoutineSheet> {
  final _titleController = TextEditingController();
  final _workoutService = WorkoutService();
  List<Map<String, dynamic>> _selectedExercises = [];
  List<Map<String, dynamic>> _exerciseList = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _workoutService.searchExercises();
      setState(() {
        _exerciseList = exercises;
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading exercises: $e')));
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _saveRoutine() async {
    if (_titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a routine name')),
      );
      return;
    }

    if (_selectedExercises.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please add at least one exercise')),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      await _workoutService.createRoutine(
        name: _titleController.text.trim(),
        exercises:
            _selectedExercises.map((exercise) {
              return {
                'exercise_id': exercise['id'],
                'sets': 3, // Default sets
                'reps': 10, // Default reps
                'weight': 0, // Default weight
              };
            }).toList(),
      );

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error creating routine: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.5,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SafeArea(
            child: SingleChildScrollView(
              controller: scrollController,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Drag handle bar
                  Container(
                    width: 40,
                    height: 4,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.outline,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),

                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                      Text(
                        'Create Routine',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onSurface,
                          fontSize: 16,
                        ),
                      ),
                      TextButton(
                        onPressed: _isLoading ? null : _saveRoutine,
                        child:
                            _isLoading
                                ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                                : Text(
                                  'Save',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Title Field
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Routine Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Exercise List or Empty State
                  if (_selectedExercises.isEmpty)
                    Column(
                      children: [
                        Icon(
                          Icons.fitness_center,
                          size: 40,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Get started by adding an exercise to your routine.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton.icon(
                            onPressed: () async {
                              final result =
                                  await showModalBottomSheet<List<String>>(
                                    context: context,
                                    isScrollControlled: true,
                                    builder:
                                        (_) => AddExerciseSheet(
                                          initialSelectedExercises:
                                              _selectedExercises
                                                  .map((e) => e['id'] as String)
                                                  .toList(),
                                        ),
                                  );
                              if (result != null) {
                                setState(() {
                                  _selectedExercises =
                                      _exerciseList
                                          .where(
                                            (e) => result.contains(e['id']),
                                          )
                                          .toList();
                                });
                              }
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('Add exercise'),
                          ),
                        ),
                      ],
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Exercises (${_selectedExercises.length})',
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.onSurface,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final result =
                                    await showModalBottomSheet<List<String>>(
                                      context: context,
                                      isScrollControlled: true,
                                      builder:
                                          (_) => AddExerciseSheet(
                                            initialSelectedExercises:
                                                _selectedExercises
                                                    .map(
                                                      (e) => e['id'] as String,
                                                    )
                                                    .toList(),
                                          ),
                                    );
                                if (result != null) {
                                  setState(() {
                                    _selectedExercises =
                                        _exerciseList
                                            .where(
                                              (e) => result.contains(e['id']),
                                            )
                                            .toList();
                                  });
                                }
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add More'),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _selectedExercises.length,
                          itemBuilder: (context, index) {
                            final exercise = _selectedExercises[index];
                            return ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    Theme.of(
                                      context,
                                    ).colorScheme.primaryContainer,
                                backgroundImage:
                                    exercise['gif_url'] != null
                                        ? NetworkImage(
                                          Supabase.instance.client.storage
                                              .from('exercises-gif')
                                              .getPublicUrl(
                                                exercise['gif_url'],
                                              ),
                                        )
                                        : null,
                                child:
                                    exercise['gif_url'] == null
                                        ? const Icon(
                                          Icons.fitness_center,
                                          size: 20,
                                        )
                                        : null,
                              ),
                              title: Text(exercise['name']),
                              subtitle: Text(
                                exercise['body_part'] ?? 'Unknown',
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() {
                                    _selectedExercises.removeAt(index);
                                  });
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

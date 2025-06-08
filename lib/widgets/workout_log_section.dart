import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:nexafit/screens/workout_log_screen.dart';
import 'package:nexafit/screens/exercise_details_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'workout_log_set_tile.dart';

class WorkoutSection extends StatefulWidget {
  final String exerciseTitle;
  final List<WorkoutSet> sets;
  final String workoutExerciseId;
  final Map<String, dynamic> exercise;

  const WorkoutSection({
    required this.exerciseTitle,
    required this.sets,
    required this.workoutExerciseId,
    required this.exercise,
    super.key,
  });

  @override
  State<WorkoutSection> createState() => _WorkoutSectionState();
}

class _WorkoutSectionState extends State<WorkoutSection> {
  late List<WorkoutSet> _sets;

  @override
  void initState() {
    super.initState();
    _sets = List.from(widget.sets);
  }

  String _getGifUrl(String? gifUrl) {
    if (gifUrl == null) return '';
    return Supabase.instance.client.storage
        .from('exercises-gif')
        .getPublicUrl(gifUrl);
  }

  void _deleteSet(int index) {
    setState(() {
      _sets.removeAt(index);
      // Update set numbers
      for (var i = index; i < _sets.length; i++) {
        _sets[i] = WorkoutSet(
          setId: _sets[i].setId,
          setNumber: i + 1,
          previous: _sets[i].previous,
          weight: _sets[i].weight,
          reps: _sets[i].reps,
          isCompleted: _sets[i].isCompleted,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row: image, title, 3 dots
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) =>
                              ExerciseDetailsScreen(exercise: widget.exercise),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 18,
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  backgroundImage:
                      widget.exercise['gif_url'] != null
                          ? NetworkImage(_getGifUrl(widget.exercise['gif_url']))
                          : null,
                  child:
                      widget.exercise['gif_url'] == null
                          ? const Icon(Icons.fitness_center, size: 20)
                          : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => ExerciseDetailsScreen(
                              exercise: widget.exercise,
                            ),
                      ),
                    );
                  },
                  child: Text(
                    widget.exerciseTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),

          const SizedBox(height: 16),

          // Notes field
          const TextField(
            decoration: InputDecoration(
              hintText: 'Add notes here...',
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
              filled: false,
              isCollapsed: true,
              contentPadding: EdgeInsets.zero,
            ),
            maxLines: null,
            cursorColor: Colors.white,
          ),

          const SizedBox(height: 16),

          // Rest timer
          Row(
            children: [
              Icon(
                Icons.timer_outlined,
                color: Theme.of(context).colorScheme.primary,
                size: 20,
              ),
              const SizedBox(width: 6),
              Text(
                'Rest Timer: 2min 0s',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Table Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text('SET', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text(
                'PREVIOUS',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              Text('KG', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('REPS', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Icon(Icons.check, color: Colors.grey, size: 18),
            ],
          ),
          const SizedBox(height: 12),

          // Set Rows
          ..._sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            return Slidable(
              endActionPane: ActionPane(
                motion: const ScrollMotion(),
                children: [
                  SlidableAction(
                    onPressed: (_) => _deleteSet(index),
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    icon: Icons.delete,
                    label: 'Delete',
                  ),
                ],
              ),
              child: WorkoutSetTile(set: set),
            );
          }),

          const SizedBox(height: 12),

          // Add Set Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _sets.add(
                    WorkoutSet(
                      setId: DateTime.now().millisecondsSinceEpoch.toString(),
                      setNumber: _sets.length + 1,
                      previous: '0kg x 0',
                      weight: 0.0,
                      reps: 0,
                    ),
                  );
                });
              },
              icon: const Icon(Icons.add),
              label: const Text('Add Set'),
            ),
          ),
        ],
      ),
    );
  }
}

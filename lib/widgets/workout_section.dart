import 'package:flutter/material.dart';
import 'package:nexafit/screens/workout_log_screen.dart';
import 'workout_set_tile.dart';

class WorkoutSection extends StatefulWidget {
  final String exerciseTitle;
  final List<WorkoutSet> initialSets;

  const WorkoutSection({
    required this.exerciseTitle,
    required this.initialSets,
    super.key,
  });

  @override
  State<WorkoutSection> createState() => _WorkoutSectionState();
}

class _WorkoutSectionState extends State<WorkoutSection> {
  late List<WorkoutSet> sets;
  final TextEditingController _notesController = TextEditingController();

  @override
  void initState() {
    super.initState();
    sets = List.from(widget.initialSets);
  }

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void addSet() {
    final newSet = WorkoutSet(
      setNumber: sets.length + 1,
      previous: sets.isNotEmpty ? sets.last.previous : '0kg x 0',
      weight: sets.isNotEmpty ? sets.last.weight : 0,
      reps: sets.isNotEmpty ? sets.last.reps : 0,
    );
    setState(() => sets.add(newSet));
  }

  void toggleCheck(int index) {
    setState(() {
      sets[index].isCompleted = !sets[index].isCompleted;
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
              const CircleAvatar(
                radius: 18,
                backgroundImage: AssetImage(
                  'assets/biceps.png',
                ), // Replace with your image
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  widget.exerciseTitle,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const Icon(Icons.more_vert, color: Colors.white),
            ],
          ),

          const SizedBox(height: 16),

          // Notes field
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
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
              SizedBox(width: 6),
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
          ...sets.asMap().entries.map((entry) {
            final index = entry.key;
            final set = entry.value;
            return WorkoutSetTile(
              set: set,
              onToggleComplete: () => toggleCheck(index),
            );
          }),

          const SizedBox(height: 12),

          // Add Set Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: addSet,
              icon: const Icon(Icons.add),
              label: const Text('Add Set'),
            ),
          ),
        ],
      ),
    );
  }
}

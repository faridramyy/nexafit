import 'package:flutter/material.dart';
import 'package:nexafit/screens/workout_log_screen.dart';

class WorkoutSetTile extends StatelessWidget {
  final WorkoutSet set;
  final VoidCallback onToggleComplete;
  final VoidCallback onUpdate;

  const WorkoutSetTile({
    required this.set,
    required this.onToggleComplete,
    required this.onUpdate,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Text(
              set.setNumber.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Previous
          SizedBox(
            width: 80,
            child: Text(
              set.previous,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Weight input
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(text: set.weight.toString()),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final weight = double.tryParse(value);
                if (weight != null) {
                  set.weight = weight;
                  onUpdate();
                }
              },
            ),
          ),

          // Reps input
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(text: set.reps.toString()),
              keyboardType: TextInputType.number,
              style: const TextStyle(color: Colors.white),
              decoration: const InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 8,
                ),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                final reps = int.tryParse(value);
                if (reps != null) {
                  set.reps = reps;
                  onUpdate();
                }
              },
            ),
          ),

          // Checkbox
          IconButton(
            onPressed: onToggleComplete,
            icon: Icon(
              set.isCompleted ? Icons.check_circle : Icons.circle_outlined,
              color: set.isCompleted ? Colors.green : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nexafit/screens/workout_log_screen.dart';

class WorkoutSetTile extends StatelessWidget {
  final WorkoutSet set;
  final VoidCallback onToggleComplete;

  const WorkoutSetTile({
    required this.set,
    required this.onToggleComplete,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color:
            set.isCompleted
                ? const Color.fromARGB(90, 0, 255, 0)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('${set.setNumber}'),
          Text(set.previous),
          Text('${set.weight}'),
          Text('${set.reps}'),
          GestureDetector(
            onTap: onToggleComplete,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: set.isCompleted ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Icon(
                Icons.check,
                color: set.isCompleted ? Colors.white : Colors.black54,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

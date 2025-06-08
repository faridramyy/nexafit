import 'package:flutter/material.dart';
import 'package:nexafit/screens/workout_log_screen.dart';

class WorkoutSetTile extends StatefulWidget {
  final WorkoutSet set;

  const WorkoutSetTile({required this.set, super.key});

  @override
  State<WorkoutSetTile> createState() => _WorkoutSetTileState();
}

class _WorkoutSetTileState extends State<WorkoutSetTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color:
            widget.set.isCompleted
                ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Set number
          SizedBox(
            width: 40,
            child: Text(
              widget.set.setNumber.toString(),
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Previous
          SizedBox(
            width: 80,
            child: Text(
              widget.set.previous,
              style: const TextStyle(color: Colors.grey),
            ),
          ),

          // Weight input
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(
                text: widget.set.weight.toString(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                filled: false,
              ),
            ),
          ),

          // Reps input
          SizedBox(
            width: 60,
            child: TextField(
              controller: TextEditingController(
                text: widget.set.reps.toString(),
              ),
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
                isCollapsed: true,
                filled: false,
              ),
            ),
          ),

          // Checkbox
          SizedBox(
            width: 40,
            child: IconButton(
              onPressed: () {
                setState(() {
                  widget.set.isCompleted = !widget.set.isCompleted;
                });
              },
              icon: Icon(
                Icons.check,
                color:
                    widget.set.isCompleted
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

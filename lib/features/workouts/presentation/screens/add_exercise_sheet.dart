import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AddExerciseSheet extends StatelessWidget {
  const AddExerciseSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: SafeArea(
            child: Column(
              children: [
                // Drag handle
                Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.outline,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                // Title
                Text(
                  "Add Exercise",
                  style: TextStyle(
                    fontSize: 18,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 16),

                // Search Field
                TextField(
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: "Search exercise",
                    hintStyle: TextStyle(
                      color: Theme.of(context).colorScheme.outline,
                    ),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    filled: true,
                    fillColor:
                        Theme.of(context).colorScheme.surfaceContainerHighest,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Filter Buttons
                Row(
                  children: [
                    Expanded(child: _filterButton(context, "All Equipment")),
                    const SizedBox(width: 10),
                    Expanded(child: _filterButton(context, "All Muscles")),
                  ],
                ),
                const SizedBox(height: 12),

                // Exercise List
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: const [
                      ExerciseTile(
                        name: "Bench Press (Dumbbell)",
                        muscle: "Chest",
                      ),
                      ExerciseTile(name: "Pull Up (Assisted)", muscle: "Lats"),
                      ExerciseTile(
                        name: "Incline Chest Press (Machine)",
                        muscle: "Chest",
                      ),
                      ExerciseTile(
                        name: "Seated Cable Row - Bar Wide Grip",
                        muscle: "Upper Back",
                      ),
                      ExerciseTile(name: "T Bar Row", muscle: "Upper Back"),
                      ExerciseTile(
                        name: "Rear Delt Reverse Fly (Machine)",
                        muscle: "Upper Back",
                      ),
                      ExerciseTile(
                        name: "Lateral Raise (Dumbbell)",
                        muscle: "Shoulders",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _filterButton(BuildContext context, String label) {
    return FilledButton.tonal(
      onPressed: () {},
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Text(label),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final String name;
  final String muscle;

  const ExerciseTile({super.key, required this.name, required this.muscle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      leading: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        child: const Icon(Icons.fitness_center, size: 20),
      ),
      title: Text(
        name,
        style: TextStyle(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: Text(
        muscle,
        style: TextStyle(
          fontSize: 12,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
      trailing: Icon(
        FontAwesomeIcons.circleInfo,
        size: 16,
        color: Theme.of(context).colorScheme.outline,
      ),
    );
  }
}

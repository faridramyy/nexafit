import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nexafit/screens/exercise_details_screen.dart';

class ExerciseTile extends StatelessWidget {
  final String name;
  final String muscle;
  final bool isSelected;
  final String gifUrl;
  final Map<String, dynamic> exercise;

  const ExerciseTile({
    super.key,
    required this.name,
    required this.muscle,
    required this.isSelected,
    required this.gifUrl,
    required this.exercise,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        border:
            isSelected
                ? Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                    width: 4,
                  ),
                )
                : null,
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          backgroundImage: gifUrl.isNotEmpty ? NetworkImage(gifUrl) : null,
          child:
              gifUrl.isEmpty
                  ? const Icon(Icons.fitness_center, size: 20)
                  : null,
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
        trailing: IconButton(
          icon: Icon(
            FontAwesomeIcons.circleInfo,
            size: 16,
            color: Theme.of(context).colorScheme.outline,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExerciseDetailsScreen(exercise: exercise),
              ),
            );
          },
        ),
      ),
    );
  }
}

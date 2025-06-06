import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  final String title;
  final String exercises;
  final VoidCallback onStartPressed;

  const RoutineCard({
    required this.title,
    required this.exercises,
    required this.onStartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).colorScheme.secondary,
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16.0, 10, 16.0, 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title and menu in the same row
            Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                  ),
                ),
                PopupMenuButton<String>(
                  icon: Icon(Icons.more_vert, color: Theme.of(context).colorScheme.onSecondary),
                  onSelected: (value) {
                    // handle popup actions
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'duplicate', child: Text('Duplicate')),
                    const PopupMenuItem(value: 'edit', child: Text('Edit')),
                    const PopupMenuItem(value: 'delete', child: Text('Delete')),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              exercises,
              style: TextStyle(color: Theme.of(context).colorScheme.outline),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onStartPressed,
                child: const Text('Start Routine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class RoutineCard extends StatelessWidget {
  final String title;
  final String exercises;

  const RoutineCard({required this.title, required this.exercises, super.key});

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
                  icon: Icon(
                    Icons.more_vert,
                    color: Theme.of(context).colorScheme.onSecondary,
                  ),
                  onSelected: (value) {
                    switch (value) {
                      case 'duplicate':
                        // Handle duplicate
                        break;
                      case 'edit':
                        // Handle edit
                        break;
                      case 'delete':
                        // Handle delete
                        break;
                    }
                  },
                  itemBuilder:
                      (context) => [
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Row(
                            children: [
                              Icon(Icons.copy, size: 20),
                              SizedBox(width: 10),
                              Text('Duplicate'),
                            ],
                          ),
                        ),
                        const PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 20),
                              SizedBox(width: 10),
                              Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete, size: 20, color: Colors.red),
                              SizedBox(width: 10),
                              Text(
                                'Delete',
                                style: TextStyle(color: Colors.red),
                              ),
                            ],
                          ),
                        ),
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
                onPressed: () {},
                child: const Text('Start Routine'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

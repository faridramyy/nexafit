import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nexafit/services/workout_service.dart';

class AddExerciseSheet extends StatefulWidget {
  final List<String> initialSelectedExercises;

  const AddExerciseSheet({super.key, this.initialSelectedExercises = const []});

  @override
  State<AddExerciseSheet> createState() => _AddExerciseSheetState();
}

class _AddExerciseSheetState extends State<AddExerciseSheet> {
  final List<String> _selectedExercises = [];
  final _workoutService = WorkoutService();
  List<Map<String, dynamic>> _exerciseList = [];
  bool _isLoading = true;
  String? _searchQuery;
  String? _selectedEquipment;
  String? _selectedMuscle;

  @override
  void initState() {
    super.initState();
    _selectedExercises.addAll(widget.initialSelectedExercises);
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    try {
      final exercises = await _workoutService.searchExercises(
        query: _searchQuery,
        equipment: _selectedEquipment,
        bodyPart: _selectedMuscle,
      );
      setState(() {
        _exerciseList = exercises;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error loading exercises: $e')));
      }
    }
  }

  void _toggleSelection(String id) {
    setState(() {
      if (_selectedExercises.contains(id)) {
        _selectedExercises.remove(id);
      } else {
        _selectedExercises.add(id);
      }
    });
  }

  String _getGifUrl(String? gifUrl) {
    if (gifUrl == null) return '';
    return Supabase.instance.client.storage
        .from('exercises-gif')
        .getPublicUrl(gifUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(24),
                ),
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
                            Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        setState(() => _searchQuery = value);
                        _loadExercises();
                      },
                    ),
                    const SizedBox(height: 12),

                    // Filter Buttons
                    Row(
                      children: [
                        Expanded(
                          child: _filterButton(context, "All Equipment"),
                        ),
                        const SizedBox(width: 10),
                        Expanded(child: _filterButton(context, "All Muscles")),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Exercise List
                    Expanded(
                      child:
                          _isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : ListView.builder(
                                controller: scrollController,
                                itemCount: _exerciseList.length,
                                itemBuilder: (context, index) {
                                  final exercise = _exerciseList[index];
                                  final isSelected = _selectedExercises
                                      .contains(exercise['id']);
                                  return GestureDetector(
                                    onTap:
                                        () => _toggleSelection(exercise['id']),
                                    child: ExerciseTile(
                                      name: exercise['name'],
                                      muscle:
                                          exercise['body_part'] ?? 'Unknown',
                                      isSelected: isSelected,
                                      gifUrl: _getGifUrl(exercise['gif_url']),
                                    ),
                                  );
                                },
                              ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),

        // Bottom Button
        if (_selectedExercises.isNotEmpty)
          Positioned(
            bottom: 24,
            left: 24,
            right: 24,
            child: FilledButton(
              onPressed: () {
                Navigator.pop(context, _selectedExercises);
              },
              child: Text(
                "Add ${_selectedExercises.length} Exercise${_selectedExercises.length > 1 ? 's' : ''}",
              ),
            ),
          ),
      ],
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
  final bool isSelected;
  final String gifUrl;

  const ExerciseTile({
    super.key,
    required this.name,
    required this.muscle,
    required this.isSelected,
    required this.gifUrl,
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
        trailing: Icon(
          FontAwesomeIcons.circleInfo,
          size: 16,
          color: Theme.of(context).colorScheme.outline,
        ),
      ),
    );
  }
}

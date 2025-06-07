import 'package:supabase_flutter/supabase_flutter.dart';

class WorkoutService {
  final SupabaseClient client = Supabase.instance.client;

  // Workout Routines
  Future<List<Map<String, dynamic>>> getRoutines() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await client
          .from('workout_routines')
          .select('*, routine_exercises(*, exercise:exercises(*))')
          .eq('user_id', userId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching routines: $e');
      return [];
    }
  }

  Future<String> createRoutine({
    required String name,
    String? description,
    required List<Map<String, dynamic>> exercises,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Create routine
      final routineResponse =
          await client
              .from('workout_routines')
              .insert({
                'user_id': userId,
                'name': name,
                'description': description,
              })
              .select()
              .single();

      final routineId = routineResponse['id'];

      // Add exercises to routine
      for (var i = 0; i < exercises.length; i++) {
        final exercise = exercises[i];
        await client.from('routine_exercises').insert({
          'routine_id': routineId,
          'exercise_id': exercise['exercise_id'],
          'order_index': i,
          'default_sets': exercise['sets'],
          'default_reps': exercise['reps'],
          'default_weight': exercise['weight'],
        });
      }

      return routineId;
    } catch (e) {
      print('Error creating routine: $e');
      rethrow;
    }
  }

  // Workouts
  Future<String> createWorkout({
    required DateTime date,
    int? duration,
    String? notes,
    required List<Map<String, dynamic>> exercises,
  }) async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) throw Exception('User not authenticated');

      // Create workout
      final workoutResponse =
          await client
              .from('workouts')
              .insert({
                'user_id': userId,
                'date': date.toIso8601String(),
                'duration': duration,
                'notes': notes,
              })
              .select()
              .single();

      final workoutId = workoutResponse['id'];

      // Add exercises to workout
      for (var i = 0; i < exercises.length; i++) {
        final exercise = exercises[i];
        final workoutExerciseResponse =
            await client
                .from('workout_exercises')
                .insert({
                  'workout_id': workoutId,
                  'exercise_id': exercise['exercise_id'],
                  'order_index': i,
                })
                .select()
                .single();

        final workoutExerciseId = workoutExerciseResponse['id'];

        // Add sets for the exercise
        for (var set in exercise['sets']) {
          await client.from('sets').insert({
            'workout_exercise_id': workoutExerciseId,
            'set_number': set['set_number'],
            'weight': set['weight'],
            'reps': set['reps'],
            'rir': set['rir'],
          });
        }
      }

      return workoutId;
    } catch (e) {
      print('Error creating workout: $e');
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>> getWorkouts() async {
    try {
      final userId = client.auth.currentUser?.id;
      if (userId == null) return [];

      final response = await client
          .from('workouts')
          .select('*, workout_exercises(*, exercise:exercises(*), sets(*))')
          .eq('user_id', userId)
          .order('date', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error fetching workouts: $e');
      return [];
    }
  }

  Future<void> updateSet({
    required String setId,
    required double weight,
    required int reps,
    int? rir,
    bool? completed,
  }) async {
    try {
      await client
          .from('sets')
          .update({
            'weight': weight,
            'reps': reps,
            if (rir != null) 'rir': rir,
            if (completed != null) 'completed': completed,
          })
          .eq('id', setId);
    } catch (e) {
      print('Error updating set: $e');
      rethrow;
    }
  }

  Future<void> completeWorkout({
    required String workoutId,
    required int duration,
    String? notes,
  }) async {
    try {
      await client
          .from('workouts')
          .update({
            'duration': duration,
            if (notes != null) 'notes': notes,
            'completed_at': DateTime.now().toIso8601String(),
          })
          .eq('id', workoutId);
    } catch (e) {
      print('Error completing workout: $e');
      rethrow;
    }
  }

  // Exercises
  Future<List<Map<String, dynamic>>> searchExercises({
    String? query,
    String? bodyPart,
    String? equipment,
    String? target,
  }) async {
    try {
      var request = client
          .from('exercises')
          .select('*, exercise_secondary_muscles(*), exercise_instructions(*)');

      if (query != null && query.isNotEmpty) {
        request = request.ilike('name', '%$query%');
      }
      if (bodyPart != null) {
        request = request.eq('body_part', bodyPart);
      }
      if (equipment != null) {
        request = request.eq('equipment', equipment);
      }
      if (target != null) {
        request = request.eq('target', target);
      }

      final response = await request;
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Error searching exercises: $e');
      return [];
    }
  }
}

import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        print(
          'Error fetching profile: No user ID found - User might not be authenticated',
        );
        return null;
      }

      print('Attempting to fetch profile for user ID: $userId');

      // First check if the profile exists
      final exists =
          await _client
              .from('profiles')
              .select('id')
              .eq('id', userId)
              .maybeSingle();

      if (exists == null) {
        print('No profile found for user $userId - Creating new profile');
        // Create a new profile if it doesn't exist
        final newProfile =
            await _client
                .from('profiles')
                .insert({'id': userId})
                .select()
                .single();
        print('Created new profile: $newProfile');
        return newProfile;
      }

      final response =
          await _client.from('profiles').select().eq('id', userId).single();

      print('Successfully fetched profile for user $userId: $response');
      return response;
    } catch (e, stackTrace) {
      print('Error fetching profile: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> updateProfile({
    String? username,
    String? fullName,
    int? age,
    String? gender,
    int? heightCm,
    int? weightKg,
    String? fitnessLevel,
    String? goal,
    int? trainingDaysPerWeek,
  }) async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) {
        throw Exception('User not authenticated');
      }

      final updates = {
        if (username != null) 'username': username,
        if (fullName != null) 'full_name': fullName,
        if (age != null) 'age': age,
        if (gender != null) 'gender': gender,
        if (heightCm != null) 'height_cm': heightCm,
        if (weightKg != null) 'weight_kg': weightKg,
        if (fitnessLevel != null) 'fitness_level': fitnessLevel,
        if (goal != null) 'goal': goal,
        if (trainingDaysPerWeek != null)
          'training_days_per_week': trainingDaysPerWeek,
      };

      print('Updating profile for user $userId with data: $updates');

      // First check if the profile exists
      final exists =
          await _client
              .from('profiles')
              .select('id')
              .eq('id', userId)
              .maybeSingle();

      if (exists == null) {
        print('No profile found for user $userId - Creating new profile');
        // Create a new profile with the updates
        final newProfile =
            await _client
                .from('profiles')
                .insert({...updates, 'id': userId})
                .select()
                .single();
        print('Created new profile: $newProfile');
        return;
      }

      final response =
          await _client
              .from('profiles')
              .update(updates)
              .eq('id', userId)
              .select()
              .single();

      print('Successfully updated profile: $response');
    } catch (e, stackTrace) {
      print('Error updating profile: $e');
      print('Stack trace: $stackTrace');
      rethrow;
    }
  }
}

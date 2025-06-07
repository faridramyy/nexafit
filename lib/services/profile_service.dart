import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileService {
  final SupabaseClient _client = Supabase.instance.client;

  Future<Map<String, dynamic>?> getProfile() async {
    try {
      final userId = _client.auth.currentUser?.id;
      if (userId == null) return null;

      final response =
          await _client.from('profiles').select().eq('id', userId).single();

      return response;
    } catch (e) {
      print('Error fetching profile: $e');
      return null;
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
      if (userId == null) throw Exception('User not authenticated');

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

      await _client.from('profiles').update(updates).eq('id', userId);
    } catch (e) {
      print('Error updating profile: $e');
      rethrow;
    }
  }
}

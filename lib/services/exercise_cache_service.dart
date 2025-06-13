import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ExerciseCacheService {
  static const String _cacheKey = 'cached_exercises';
  static const String _lastUpdateKey = 'last_exercise_update';
  static const Duration _cacheDuration = Duration(days: 7); // Cache for 7 days

  // Save exercises to cache
  Future<void> cacheExercises(List<Map<String, dynamic>> exercises) async {
    final prefs = await SharedPreferences.getInstance();
    final exercisesJson = jsonEncode(exercises);
    await prefs.setString(_cacheKey, exercisesJson);
    await prefs.setString(_lastUpdateKey, DateTime.now().toIso8601String());
  }

  // Get exercises from cache
  Future<List<Map<String, dynamic>>?> getCachedExercises() async {
    final prefs = await SharedPreferences.getInstance();
    final exercisesJson = prefs.getString(_cacheKey);
    final lastUpdateStr = prefs.getString(_lastUpdateKey);

    if (exercisesJson == null || lastUpdateStr == null) {
      return null;
    }

    final lastUpdate = DateTime.parse(lastUpdateStr);
    if (DateTime.now().difference(lastUpdate) > _cacheDuration) {
      // Cache is expired
      await prefs.remove(_cacheKey);
      await prefs.remove(_lastUpdateKey);
      return null;
    }

    try {
      final List<dynamic> decoded = jsonDecode(exercisesJson);
      return decoded.cast<Map<String, dynamic>>();
    } catch (e) {
      print('Error decoding cached exercises: $e');
      return null;
    }
  }

  // Clear cache
  Future<void> clearCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cacheKey);
    await prefs.remove(_lastUpdateKey);
  }
}

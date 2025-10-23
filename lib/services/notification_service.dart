import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class NotificationService {
  static const String _baseUrl = 'https://insect-famous-ghastly.ngrok-free.app';
  String? _accessToken;
  Timer? _pollingTimer;

  // Store the access token
  void setAccessToken(String token) {
    _accessToken = token;
  }

  // Get headers with authentication
  Map<String, String> _getHeaders() {
    return {
      'Content-Type': 'application/json',
      if (_accessToken != null) 'Authorization': 'Bearer $_accessToken',
    };
  }

  // Check if user has completed a lesson (poll for new badges/xp)
  Future<Map<String, dynamic>?> getUserStats() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/game-service/stats'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching user stats: $e');
      return null;
    }
  }

  // Get user's current streak
  Future<Map<String, dynamic>?> getStreak() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/game-service/streak'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching streak: $e');
      return null;
    }
  }

  // Get user's badges
  Future<List<dynamic>?> getBadges() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/game-service/badge'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching badges: $e');
      return null;
    }
  }

  // Get user's XP
  Future<Map<String, dynamic>?> getXP() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/api/game-service/xp'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print('Error fetching XP: $e');
      return null;
    }
  }

  // Complete a lesson (triggers notifications)
  Future<bool> completeLesson(String lessonId) async {
    try {
      print('🔔 [NotificationService] Attempting to complete lesson: $lessonId');
      print('🔔 [NotificationService] Request URL: $_baseUrl/api/lesson-service/lesson-complete');
      print('🔔 [NotificationService] Access Token: ${_accessToken != null ? "Present" : "Missing"}');
      
      final requestBody = json.encode({'LessonID': lessonId});
      print('🔔 [NotificationService] Request Body: $requestBody');
      
      final response = await http.post(
        Uri.parse('$_baseUrl/api/lesson-service/lesson-complete'),
        headers: _getHeaders(),
        body: requestBody,
      );

      print('🔔 [NotificationService] Response Status Code: ${response.statusCode}');
      print('🔔 [NotificationService] Response Headers: ${response.headers}');
      print('🔔 [NotificationService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ [NotificationService] Lesson completed successfully');
        return true;
      } else {
        print('❌ [NotificationService] Lesson completion failed with status: ${response.statusCode}');
        return false;
      }
    } catch (e, stackTrace) {
      print('❌ [NotificationService] Error completing lesson: $e');
      print('❌ [NotificationService] Stack trace: $stackTrace');
      return false;
    }
  }

  // Start polling for changes (simple notification mechanism)
  void startPolling({
    required Function(Map<String, dynamic>) onStatsChange,
    Duration interval = const Duration(seconds: 30),
  }) {
    _pollingTimer?.cancel();
    
    Map<String, dynamic>? previousStats;

    _pollingTimer = Timer.periodic(interval, (timer) async {
      final currentStats = await getUserStats();
      
      if (currentStats != null && previousStats != null) {
        // Check for changes and notify
        if (json.encode(currentStats) != json.encode(previousStats)) {
          onStatsChange(currentStats);
        }
      }
      
      previousStats = currentStats;
    });
  }

  // Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  // Dispose
  void dispose() {
    stopPolling();
  }
}
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  static const String _baseUrl =
      'https://insect-famous-ghastly.ngrok-free.app/api/user/auth';
  static const _storage = FlutterSecureStorage();
  static final _dio = Dio();

  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';

  // Sign up method
  static Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/sign-up',
        data: {'name': name, 'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Store tokens securely
      await _storage.write(
        key: _accessTokenKey,
        value: response.data['accessToken'],
      );
      await _storage.write(
        key: _refreshTokenKey,
        value: response.data['refreshToken'],
      );

      return AuthResult.success();
    } on DioException catch (e) {
      if (e.response != null) {
        final data = e.response?.data;
        if (data != null && data['errors'] is List) {
          final errors = data['errors'] as List;
          final errorMessages = errors.map((error) => error['description'] ?? 'Unknown error').join('\n');
          return AuthResult.error(errorMessages);
        } else {
          final errorMessage = data?['message'] ?? 'Sign up failed. Please try again.';
          return AuthResult.error(errorMessage);
        }
      } else {
        return AuthResult.error('Network error. Please check your connection.');
      }
    } catch (e) {
      return AuthResult.error('Network error. Please check your connection.');
    }
  }

  // Sign in method
  static Future<AuthResult> signIn(String email, String password) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/sign-in',
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Store tokens securely
      await _storage.write(
        key: _accessTokenKey,
        value: response.data['accessToken'],
      );
      await _storage.write(
        key: _refreshTokenKey,
        value: response.data['refreshToken'],
      );

      return AuthResult.success();
    } on DioException catch (e) {
      if (e.response != null) {
        final errorMessage =
            e.response?.data['message'] ??
            'Login failed. Please check your credentials.';
        return AuthResult.error(errorMessage);
      } else {
        return AuthResult.error('Network error. Please check your connection.');
      }
    } catch (e) {
      return AuthResult.error('Network error. Please check your connection.');
    }
  }

  // Get stored access token
  static Future<String?> getAccessToken() async {
    return await _storage.read(key: _accessTokenKey);
  }

  // Get stored refresh token
  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await getAccessToken();
    return token != null;
  }

  // Sign out
  static Future<void> signOut() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
  }

  // Refresh token method
  static Future<AuthResult> refreshToken() async {
    try {
      final accessToken = await getAccessToken();
      final refreshToken = await getRefreshToken();

      if (accessToken == null || refreshToken == null) {
        return AuthResult.error('No tokens found');
      }

      final response = await _dio.post(
        '$_baseUrl/refresh-token',
        data: {'accessToken': accessToken, 'refreshToken': refreshToken},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      // Store new tokens
      await _storage.write(
        key: _accessTokenKey,
        value: response.data['accessToken'],
      );
      await _storage.write(
        key: _refreshTokenKey,
        value: response.data['refreshToken'],
      );

      return AuthResult.success();
    } on DioException catch (e) {
      return AuthResult.error('Failed to refresh token: ${e.message}');
    } catch (e) {
      return AuthResult.error('Network error during token refresh');
    }
  }
}

// Result class for auth operations
class AuthResult {
  final bool success;
  final String? errorMessage;

  AuthResult._({required this.success, this.errorMessage});

  factory AuthResult.success() => AuthResult._(success: true);
  factory AuthResult.error(String message) =>
      AuthResult._(success: false, errorMessage: message);
}

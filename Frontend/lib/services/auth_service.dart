import 'package:shared_preferences/shared_preferences.dart';

import 'api_service.dart';

class AuthService {
  final _api = ApiService.instance;

  // ── OTP ────────────────────────────────────────────────────────────────

  Future<Map<String, dynamic>> sendOTP(String phone) async {
    return _api.post('/auth/send-otp', body: {'phone': phone}, withAuth: false);
  }

  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    return _api.post(
      '/auth/verify-otp',
      body: {'phone': phone, 'otp': otp},
      withAuth: false,
    );
  }

  // ── Token management ──────────────────────────────────────────────────

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> removeToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}

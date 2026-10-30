import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  final TextEditingController phoneController = TextEditingController();
  final RxString phone = ''.obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoggedIn = false.obs;
  final RxBool otpSent = false.obs;

  bool _checkingAuth = false;

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }

  Future<void> checkAuth() async {
    if (_checkingAuth) return;
    _checkingAuth = true;
    try {
      final loggedIn = await _authService.isLoggedIn();
      isLoggedIn.value = loggedIn;
      if (!loggedIn) {
        Get.offAllNamed(AppRoutes.welcome);
        return;
      }

      try {
        final response = await _profileService.getProfile();
        final rawData = response['data'];
        final profile = rawData is Map
            ? Map<String, dynamic>.from(rawData)
            : <String, dynamic>{};
        final complete = profile['profileCompleted'] == true;
        Get.offAllNamed(
          complete ? AppRoutes.home : AppRoutes.profileSetup,
        );
      } catch (_) {
        // Keep a valid saved session usable if the profile endpoint is
        // temporarily unavailable; the dashboard can retry profile loading.
        Get.offAllNamed(AppRoutes.home);
      }
    } catch (_) {
      isLoggedIn.value = false;
      Get.offAllNamed(AppRoutes.welcome);
    } finally {
      _checkingAuth = false;
    }
  }

  Future<void> sendOTP() async {
    final value = phoneController.text.trim();
    if (!RegExp(r'^[0-9]{10}$').hasMatch(value)) {
      _message('Check your number', 'Enter a valid 10-digit mobile number.');
      return;
    }
    await _requestOTP(value, openOtpScreen: true);
  }

  Future<void> resendOTP() async {
    if (phone.value.isEmpty) {
      Get.offAllNamed(AppRoutes.welcome);
      return;
    }
    await _requestOTP(phone.value, openOtpScreen: false);
  }

  Future<void> _requestOTP(
    String number, {
    required bool openOtpScreen,
  }) async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      final response = await _authService.sendOTP(number);
      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Unable to send OTP.');
      }
      phone.value = number;
      otpSent.value = true;
      if (openOtpScreen) {
        Get.toNamed(AppRoutes.otp);
      }
      _message('OTP sent', 'A 6-digit code was sent to +91 $number.');
    } catch (e) {
      _message('Unable to send OTP', e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> verifyOTP(String otp) async {
    final value = otp.trim();
    if (!RegExp(r'^[0-9]{6}$').hasMatch(value)) {
      _message('Invalid OTP', 'Enter the complete 6-digit verification code.');
      return;
    }
    if (phone.value.isEmpty) {
      _message('Session expired', 'Enter your mobile number again.', error: true);
      Get.offAllNamed(AppRoutes.welcome);
      return;
    }
    if (isLoading.value) return;

    isLoading.value = true;
    try {
      final response = await _authService.verifyOTP(phone.value, value);
      final rawData = response['data'];
      final data = rawData is Map
          ? Map<String, dynamic>.from(rawData)
          : <String, dynamic>{};
      final token = data['token'] ?? response['token'];
      if (token == null || token.toString().isEmpty) {
        throw Exception(response['message'] ?? 'Authentication failed.');
      }

      await _authService.saveToken(token.toString());
      isLoggedIn.value = true;
      otpSent.value = false;

      final rawUser = data['user'];
      final user = rawUser is Map
          ? Map<String, dynamic>.from(rawUser)
          : <String, dynamic>{};
      final profileCompleted =
          user['profileCompleted'] == true ||
          data['profileCompleted'] == true ||
          response['profileCompleted'] == true;

      _message('Verified successfully', 'Welcome to CreditSea.');
      Get.offAllNamed(
        profileCompleted ? AppRoutes.home : AppRoutes.profileSetup,
      );
    } catch (e) {
      _message('Verification failed', e.toString(), error: true);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    await _authService.removeToken();
    isLoggedIn.value = false;
    otpSent.value = false;
    phone.value = '';
    phoneController.clear();
    Get.offAllNamed(AppRoutes.welcome);
  }

  void _message(String title, String message, {bool error = false}) {
    Get.snackbar(
      title,
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: error
          ? const Color(0xFFFFEEEE)
          : const Color(0xFFE4FBF3),
      colorText: error
          ? const Color(0xFF9E3030)
          : const Color(0xFF126B4F),
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
    );
  }
}

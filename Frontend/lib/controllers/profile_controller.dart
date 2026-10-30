import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../app/routes/app_routes.dart';
import '../models/user_model.dart';
import '../services/profile_service.dart';

class ProfileController extends GetxController {
  final ProfileService _profileService = ProfileService();

  final user = UserModel().obs;
  final isLoading = false.obs;

  // Form controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final panController = TextEditingController();
  final addressController = TextEditingController();
  final selectedGender = Rxn<String>();
  final selectedDob = Rxn<DateTime>();

  @override
  void onInit() {
    super.onInit();
    fetchProfile();
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    panController.dispose();
    addressController.dispose();
    super.onClose();
  }

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await _profileService.getProfile();
      final data = response['data'] ?? response;
      user.value = UserModel.fromJson(data);
      _populateFormControllers();
    } catch (e) {
      // Silently fail – user may not have a profile yet
    } finally {
      isLoading.value = false;
    }
  }

  void _populateFormControllers() {
    final u = user.value;
    nameController.text = u.name ?? '';
    emailController.text = u.email ?? '';
    panController.text = u.pan ?? '';
    addressController.text = u.address ?? '';
    selectedGender.value = u.gender;
    selectedDob.value = u.dob;
  }

  Future<bool> updateProfile(Map<String, dynamic> data) async {
    isLoading.value = true;
    try {
      final response = await _profileService.updateProfile(data);
      final resData = response['data'] ?? response;
      user.value = UserModel.fromJson(resData);
      Get.snackbar(
        'Success',
        'Profile updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.shade100,
        colorText: Colors.green.shade900,
      );
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.shade100,
        colorText: Colors.red.shade900,
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveProfile() async {
    final data = <String, dynamic>{
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'pan': panController.text.trim().toUpperCase(),
      'address': addressController.text.trim(),
      if (selectedGender.value != null) 'gender': selectedGender.value,
      if (selectedDob.value != null) 'dob': selectedDob.value!.toIso8601String(),
      'profileCompleted': true,
    };

    if (nameController.text.trim().length < 2 ||
        !RegExp(r'^[A-Z]{5}[0-9]{4}[A-Z]$').hasMatch(panController.text.trim().toUpperCase()) ||
        selectedDob.value == null ||
        emailController.text.trim().isEmpty) {
      Get.snackbar('Check your details', 'Enter name, valid PAN, email and date of birth.');
      return;
    }
    final saved = await updateProfile(data);
    if (saved) Get.offAllNamed(AppRoutes.home);
  }

  bool get isProfileComplete => user.value.profileCompleted;
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  ThemeController({required ThemeMode initialMode}) : themeMode = initialMode.obs;

  final Rx<ThemeMode> themeMode;
  static const _storageKey = 'creditsea_theme_mode';

  Future<void> toggleTheme() async {
    final next = themeMode.value == ThemeMode.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    themeMode.value = next;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, next.name);
  }

  bool get isDark => themeMode.value == ThemeMode.dark ||
      (themeMode.value == ThemeMode.system && Get.isDarkMode);
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/routes/app_pages.dart';
import 'app/routes/app_routes.dart';
import 'app/theme/app_theme.dart';
import 'controllers/auth_controller.dart';
import 'controllers/theme_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final savedMode = prefs.getString('creditsea_theme_mode');
  final initialMode = savedMode == 'dark'
      ? ThemeMode.dark
      : savedMode == 'light'
          ? ThemeMode.light
          : ThemeMode.system;
  Get.put<ThemeController>(ThemeController(initialMode: initialMode), permanent: true);
  runApp(const CreditSeaApp());
}

class CreditSeaApp extends StatelessWidget {
  const CreditSeaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    return Obx(() => GetMaterialApp(
          title: 'CreditSea',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: themeController.themeMode.value,
          initialBinding: BindingsBuilder(() {
            if (!Get.isRegistered<AuthController>()) {
              Get.put<AuthController>(AuthController(), permanent: true);
            }
          }),
          initialRoute: AppRoutes.splash,
          getPages: AppPages.pages,
          defaultTransition: Transition.cupertino,
          transitionDuration: const Duration(milliseconds: 280),
        ));
  }
}

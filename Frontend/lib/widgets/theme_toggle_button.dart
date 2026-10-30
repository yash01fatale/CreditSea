import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';

class CreditSeaThemeButton extends StatelessWidget {
  const CreditSeaThemeButton({super.key, this.tooltip = 'Switch theme'});
  final String tooltip;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ThemeController>();
    return Obx(() => IconButton(
      tooltip: tooltip,
      onPressed: controller.toggleTheme,
      icon: Icon(controller.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../theme_controller.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();
    
    return IconButton(
      icon: Obx(() => Icon(
        themeController.themeMode.value == ThemeMode.dark
            ? Icons.light_mode
            : Icons.dark_mode,
      )),
      onPressed: () {
        themeController.toggleTheme();
      },
    );
  }
}
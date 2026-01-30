import 'package:countries/di/app_bindings.dart';
import 'package:countries/theme/light_theme.dart';
import 'package:countries/theme/dark_theme.dart';
import 'package:countries/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/route_helper.dart';
import 'theme/theme_controller.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ThemeController
    Get.put(ThemeController(), permanent: true);
    
    return GetBuilder<ThemeController>(
      builder: (themeController) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: AppConstants.appName,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: themeController.themeMode.value,
          getPages: RouteHelper.routes,
          initialRoute: RouteHelper.getSplashRoute(),
          initialBinding: AppBindings(),
        );
      },
    );
  }
}
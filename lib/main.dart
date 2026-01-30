import 'package:countries/helper/app_bindings.dart';
import 'package:countries/home/controller/home_binding.dart';
import 'package:countries/splash/splash_screen.dart';
import 'package:countries/theme/light_theme.dart';
import 'package:countries/utils/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'helper/route_helper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppConstants.appName,
      theme: lightTheme,
      getPages: RouteHelper.routes,
      initialRoute: RouteHelper.getSplashRoute(),
      initialBinding: AppBindings(),
    );
  }
}

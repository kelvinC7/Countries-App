import 'package:flutter/material.dart';

class ColorResources {

  static const Color primaryColor = Color(0xFF3F51B5);
  static const Color grey100Color = Color(0xFFF5F5F5);
  static const Color grey200Color = Color(0xFFEEEEEE);
  static const Color grey300Color = Color(0xFFE0E0E0);  
  static const Color grey600Color = Color(0xFF757575);
  static const Color whiteColor = Color(0xFFFFFFFF);
  static const Color blackColor = Color(0xFF000000);
  static const Color redColor = Color(0xFFF44336);
  static const Color greenColor = Color(0xFF4CAF50);
  
  // Define theme-aware getters
  static Color getScaffoldBackground(BuildContext context) {
    return Theme.of(context).scaffoldBackgroundColor;
  }
  
  static Color getTextColor(BuildContext context) {
    return Theme.of(context).textTheme.bodyLarge!.color!;
  }
  
  static Color getCardColor(BuildContext context) {
    return Theme.of(context).cardColor;
  }
  

}
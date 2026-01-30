
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../helper/route_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

@override
  void initState() {
    // TODO: implement initState
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed(RouteHelper.getMainRoute());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: Center(
        child: Image.asset('assets/logos/app_logo.png'
        , width: 100, height: 100),
      ),
    );
  }
}
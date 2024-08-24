import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:oil_guard/generated/assets.dart';

import 'dashboard.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}//hello

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 5), () {
      /*Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const Dashboard()),
      );*/

      Get.to(()=>const Dashboard());
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.asset(
            Assets.assetsAppBanner,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

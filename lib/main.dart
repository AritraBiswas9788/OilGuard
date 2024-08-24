import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:oil_guard/screens/dashboard.dart';
import 'package:oil_guard/screens/splash_screens.dart';
import 'package:oil_guard/utils/ais_data_fetcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  //Lazy Initialize GetX controllers
  Get.lazyPut(()=>AisDataFetcher(),fenix: true);

  SystemChrome.setPreferredOrientations([
    // Lock orientation to landscape
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]).then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const Dashboard(), // Root route
        // Settings route
      },
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEEEEE),
        appBarTheme: const AppBarTheme(
          color: Color(0xFF111111),
        ),
      ),
    );
  }
}

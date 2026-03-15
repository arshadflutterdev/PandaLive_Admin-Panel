import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:panda_adminpanel/AdminPanel/Routes/app_routes.dart';
import 'package:panda_adminpanel/AdminPanel/Service/app_language.dart';
import 'package:panda_adminpanel/firebase_options.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  final getSavelang = sharedPreferences.getString("language");
  Locale initialLocale = getSavelang == 'ar'
      ? const Locale('ar', 'AE')
      : const Locale('en', 'US');
  runApp(
    DevicePreview(
      // Enable preview only in debug mode for better performance
      enabled: !kReleaseMode,
      builder: (context) => MyApp(initialLocale: initialLocale),
    ),
  );
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;
  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      translations: AppLanguage(),
      locale: initialLocale,
      fallbackLocale: Locale('ar', 'UE'),
      debugShowCheckedModeBanner: false,
      getPages: AppRoutes.routes,
      initialRoute: AppRoutes.login,
      title: 'Flutter Demo',
      theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
    );
  }
}

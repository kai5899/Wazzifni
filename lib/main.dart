import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:locateme/Services/ThemServices.dart';
import 'Bindings/AuthBinding.dart';
import 'Controllers/Root.dart';
import 'Services/LocalizationServices.dart';

//AIzaSyDcRznkYtt5PYFnO11WE0hlNxkp3jPOWyY
Future<void> main() async {
  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.white,
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Locate Me',
      debugShowCheckedModeBanner: false,
      locale: LocalizationService().getSaved(),
      fallbackLocale: LocalizationService.fallbackLocale,
      translations: LocalizationService(),
      theme: ThemeService().lightTheme,
      darkTheme: ThemeService().darkTheme,
      themeMode: ThemeService().theme,
      initialBinding: AuthBinding(),
      home: Root(),
    );
  }
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:secure_connect/firebase_options.dart';
import 'package:secure_connect/screens/login/login_view.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor:
        Colors.transparent, // Set to transparent to hide status bar color
    systemNavigationBarColor: Color(
        0XFF2d2c5c), // Set to transparent to hide system navigation bar color
  ));
  runApp(const MyApp());
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Secure Connect',
        theme: ThemeData(),
        home: const LoginScreen());
  }
}

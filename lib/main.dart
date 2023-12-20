import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:voter_finder/screen/home/home_screen.dart';
import 'package:voter_finder/screen/login/login_screen.dart';
import 'package:voter_finder/splash_screen.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/auth': (context) => LoginScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}

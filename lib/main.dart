import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:testproject/screens/home.dart';
import 'package:testproject/screens/login.dart';
import 'package:testproject/screens/profile.dart';
import 'package:testproject/screens/sginup.dart';
import 'package:testproject/screens/splash.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final isLoggedIn = prefs.getString('email') != null;

  runApp(MyApp(isLoggedIn: isLoggedIn));
}
class MyApp extends StatelessWidget {
  final bool isLoggedIn;
  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
     home: isLoggedIn ? const MyHome() : const Splash(),
    );
  }
}

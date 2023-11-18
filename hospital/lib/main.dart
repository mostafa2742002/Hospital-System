import 'package:flutter/material.dart';
import 'package:hospital/patients/components/main_layout.dart';
import 'package:hospital/welcome_screen.dart';
import 'login_screen.dart';

void main() {
  runApp(const MyApp());
}

// MediaQuery.of(context).size.height
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: MyApp.navigatorKey,
      title: 'Hospital System',
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

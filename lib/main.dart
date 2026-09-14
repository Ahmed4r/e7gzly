import 'package:e7gzly/features/auth/presentation/screens/login_page.dart';

import 'package:flutter/material.dart';

void main() {
  runApp(const HealthPalApp());
}

class HealthPalApp extends StatelessWidget {
  const HealthPalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: LoginPage(),
    );
  }
}

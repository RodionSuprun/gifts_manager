import 'package:flutter/material.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/theme/theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.dark,
      home: LoginPage(),
    );
  }
}


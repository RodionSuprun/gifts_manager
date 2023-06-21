import 'package:flutter/material.dart';
import 'package:gifts_manager/presentation/home/view/home_page.dart';
import 'package:gifts_manager/presentation/login/view/logn_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
        useMaterial3: true,
      ),
      home: LoginPage(),
    );
  }
}


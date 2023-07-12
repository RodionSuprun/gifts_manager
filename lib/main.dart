import 'package:flutter/material.dart';
import 'package:gifts_manager/presentation/login/view/login_page.dart';
import 'package:gifts_manager/presentation/splash/view/splash_page.dart';
import 'package:gifts_manager/presentation/theme/theme.dart';

import 'di/service_locator.dart';
import 'navigation/route_generator.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  initServiceLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      onGenerateRoute: generateRoute(),
    );
  }
}


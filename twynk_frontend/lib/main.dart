import 'package:flutter/material.dart';
import 'pages/welcome.dart';
import 'themes/default_light.dart';
import 'themes/default_dark.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Twynk',
      debugShowCheckedModeBanner: false,
      themeAnimationDuration: Duration.zero,
      themeAnimationCurve: Curves.linear,
      theme: defaultLightTheme,
      darkTheme: defaultDarkTheme,
      themeMode: _themeMode,
      home: WelcomePage(
        themeMode: _themeMode,
        onThemeToggle: _toggleTheme,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/l10n/app_localizations.dart';
import 'pages/welcome.dart';
import 'pages/proflie.dart';
import 'themes/default_light.dart';
import 'themes/default_dark.dart';
import 'services/api_client.dart';
import 'services/language_controller.dart';

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
  bool _initialized = false;
  bool _loggedIn = false;

  @override
  void initState() {
    super.initState();
    _initAuth();
  }

  Future<void> _initAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    if (token != null && token.isNotEmpty) {
      ApiClient.instance.setToken(token);
      setState(() {
        _loggedIn = true;
        _initialized = true;
      });
    } else {
      setState(() {
        _initialized = true;
      });
    }
  }

  void _toggleTheme(bool isDark) {
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppLanguage>(
      valueListenable: LanguageController.instance.language,
      builder: (context, lang, _) {
        final locale =
            lang == AppLanguage.en ? const Locale('en') : const Locale('pt');

        if (!_initialized) {
          return MaterialApp(
            title: 'Nomirro',
            debugShowCheckedModeBanner: false,
            themeAnimationDuration: Duration.zero,
            themeAnimationCurve: Curves.linear,
            theme: defaultLightTheme,
            darkTheme: defaultDarkTheme,
            themeMode: _themeMode,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            home: const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        return MaterialApp(
          title: 'Nomirro',
          debugShowCheckedModeBanner: false,
          themeAnimationDuration: Duration.zero,
          themeAnimationCurve: Curves.linear,
          theme: defaultLightTheme,
          darkTheme: defaultDarkTheme,
          themeMode: _themeMode,
          locale: locale,
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: _loggedIn
              ? const PainelAssinantePage()
              : WelcomePage(
                  themeMode: _themeMode,
                  onThemeToggle: _toggleTheme,
                ),
        );
      },
    );
  }
}

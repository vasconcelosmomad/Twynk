import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:twynk_frontend/l10n/app_localizations.dart';
import 'package:twynk_frontend/pages/welcome.dart';
import 'package:twynk_frontend/pages/proflie.dart';
import 'package:twynk_frontend/themes/app_theme.dart';
import 'package:twynk_frontend/services/api_client.dart';
import 'package:twynk_frontend/services/language_controller.dart';
import 'package:twynk_frontend/providers/app_provider.dart';
import 'package:twynk_frontend/models/user.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppProvider(),
      child: const MyApp(),
    ),
  );
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
      
      // Inicializar AppProvider e buscar dados do usuário
      if (mounted) {
        final appProvider = Provider.of<AppProvider>(context, listen: false);

        // Primeiro, tentar restaurar usuário salvo localmente (para evitar piscar como "Usuário")
        final cachedUserJson = prefs.getString('current_user');
        if (cachedUserJson != null) {
          try {
            final Map<String, dynamic> userMap =
                jsonDecode(cachedUserJson) as Map<String, dynamic>;
            final user = User.fromJson(userMap);
            await appProvider.login(user);
          } catch (_) {
            // Se der erro ao decodificar, ignoramos e seguimos com initialize()
          }
        }

        // Ainda assim chamamos initialize() para atualizar dados a partir da API
        await appProvider.initialize();
      }
      
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
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
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
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
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

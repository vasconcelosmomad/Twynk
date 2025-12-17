import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:twynk_frontend/pages/welcome.dart';
import 'package:twynk_frontend/pages/proflie.dart';
import 'package:twynk_frontend/providers/app_provider.dart';
import 'package:twynk_frontend/providers/chat_provider.dart';
import 'package:twynk_frontend/providers/location_provider.dart';
import 'package:twynk_frontend/providers/media_provider.dart';
import 'package:twynk_frontend/providers/user_provider.dart';
import 'package:twynk_frontend/themes/app_theme.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token');

  runApp(MyApp(token: token));
}

class MyApp extends StatelessWidget {
  final String? token;

  const MyApp({super.key, this.token});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AppProvider(
            userProvider: UserProvider(),
            mediaProvider: MediaProvider(),
            chatProvider: ChatProvider(),
          ),
        ),
        ChangeNotifierProvider(create: (_) => LocationProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          if (!appProvider.isInitialized) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              ),
            );
          }

          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Nomirro',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: appProvider.themeMode,
            home: appProvider.isLoggedIn
                ? const PainelAssinantePage()
                : const WelcomePage(),
          );
        },
      ),
    );
  }
}
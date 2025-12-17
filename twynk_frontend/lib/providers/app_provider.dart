import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:twynk_frontend/models/user.dart';
import 'package:twynk_frontend/providers/chat_provider.dart';
import 'package:twynk_frontend/providers/media_provider.dart';
import 'package:twynk_frontend/providers/user_provider.dart';

class AppProvider with ChangeNotifier {
  final UserProvider userProvider;
  final MediaProvider mediaProvider;
  final ChatProvider chatProvider;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get themeMode => _themeMode;

  String? _token;

  AppProvider({
    required this.userProvider,
    required this.mediaProvider,
    required this.chatProvider,
  }) {
    initialize();
  }

  void toggleTheme() {
    _themeMode =
        _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  Future<void> initialize() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');

    if (_token != null) {
      userProvider.setToken(_token!);
      mediaProvider.setToken(_token!);
      chatProvider.setToken(_token!);
      await userProvider.fetchUser();
    }

    _isInitialized = true;
    notifyListeners();
  }

  bool get isLoggedIn => userProvider.user != null && _token != null;

  Future<void> login(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
    _token = token;
    userProvider.setToken(token);
    mediaProvider.setToken(token);
    chatProvider.setToken(token);
    await userProvider.fetchUser();
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    _token = null;
    userProvider.setUser(null);
    notifyListeners();
  }

  Future<void> refreshData() async {
    if (isLoggedIn) {
      await userProvider.fetchUser();
      notifyListeners();
    }
  }

  void setUser(User? user) {
    userProvider.setUser(user);
    notifyListeners();
  }
}
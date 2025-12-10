import 'package:flutter/foundation.dart';
import 'user_provider.dart';
import 'media_provider.dart';
import 'chat_provider.dart';
import '../models/user.dart';
import '../models/media.dart';
import '../models/chat_mensagem.dart';

class AppProvider extends ChangeNotifier {
  late final UserProvider userProvider;
  late final MediaProvider mediaProvider;
  late final ChatProvider chatProvider;

  AppProvider() {
    userProvider = UserProvider();
    mediaProvider = MediaProvider();
    chatProvider = ChatProvider();

    // Listen to changes from child providers
    userProvider.addListener(_onChildProviderChanged);
    mediaProvider.addListener(_onChildProviderChanged);
    chatProvider.addListener(_onChildProviderChanged);
  }

  // Getters for convenience
  User? get currentUser => userProvider.currentUser;
  List<Media> get userMedia => mediaProvider.userMedia;
  List<ChatMensagem> get messages => chatProvider.messages;
  bool get isLoading => userProvider.isLoading || mediaProvider.isLoading || chatProvider.isLoading;
  String? get error => userProvider.error ?? mediaProvider.error ?? chatProvider.error;

  // Initialize app data
  Future<void> initialize() async {
    await Future.wait([
      userProvider.fetchCurrentUser(),
      // Initialize other providers as needed
    ]);
  }

  // Login flow
  Future<bool> login(User user) async {
    try {
      userProvider.setCurrentUser(user);
      
      // Fetch user-specific data
      await Future.wait([
        mediaProvider.fetchUserMedia(user.id),
        // Fetch other user-specific data
      ]);
      
      return true;
    } catch (e) {
      debugPrint('Error during login: $e');
      return false;
    }
  }

  // Logout flow
  Future<void> logout() async {
    userProvider.clearCurrentUser();
    mediaProvider.clearUserMedia();
    chatProvider.clearChatMessages();
  }

  // Refresh all data
  Future<void> refreshAllData() async {
    if (currentUser != null) {
      await Future.wait([
        userProvider.fetchCurrentUser(),
        mediaProvider.fetchUserMedia(currentUser!.id),
        // Refresh other data as needed
      ]);
    }
  }

  // Clear all errors
  void clearAllErrors() {
    userProvider.clearError();
    mediaProvider.clearError();
    chatProvider.clearError();
  }

  @override
  void dispose() {
    userProvider.removeListener(_onChildProviderChanged);
    mediaProvider.removeListener(_onChildProviderChanged);
    chatProvider.removeListener(_onChildProviderChanged);
    
    userProvider.dispose();
    mediaProvider.dispose();
    chatProvider.dispose();
    
    super.dispose();
  }

  void _onChildProviderChanged() {
    notifyListeners();
  }
}

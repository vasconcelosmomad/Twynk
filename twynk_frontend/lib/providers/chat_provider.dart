import 'package:flutter/foundation.dart';
import '../models/chat_mensagem.dart';
import '../services/api_client.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient.instance;
  
  List<ChatMensagem> _messages = [];
  final Map<String, List<ChatMensagem>> _chatMessages = {};
  bool _isLoading = false;
  String? _error;
  bool _isTyping = false;

  void setToken(String token) {
    _apiClient.setToken(token);
  }

  // Getters
  List<ChatMensagem> get messages => _messages;
  Map<String, List<ChatMensagem>> get chatMessages => _chatMessages;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTyping => _isTyping;

  // Fetch messages for a specific chat
  Future<void> fetchChatMessages(String chatId, {int page = 1, int limit = 50}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.dio.get('/chat/$chatId/messages', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      if (response.statusCode == 200) {
        final List<dynamic> messagesJson = response.data['data'];
        final newMessages = messagesJson.map((json) => ChatMensagem.fromJson(json)).toList();
        
        if (page == 1) {
          _chatMessages[chatId] = newMessages;
        } else {
          _chatMessages[chatId] = [...newMessages, ...?_chatMessages[chatId]];
        }
        
        _messages = _chatMessages[chatId] ?? [];
        notifyListeners();
      } else {
        _setError('Failed to fetch chat messages');
      }
    } catch (e) {
      _setError('Error fetching chat messages: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Send text message
  Future<ChatMensagem?> sendTextMessage(String chatId, String content, String recipientId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.post('/chat/$chatId/messages', data: {
        'conteudo': content,
        'tipo': 'texto',
        'destinatario_id': recipientId,
      });
      
      if (response.statusCode == 201) {
        final message = ChatMensagem.fromJson(response.data);
        _addMessageToChat(chatId, message);
        return message;
      } else {
        _setError('Failed to send text message');
        return null;
      }
    } catch (e) {
      _setError('Error sending text message: $e');
      return null;
    }
  }

  // Send media message
  Future<ChatMensagem?> sendMediaMessage(String chatId, String mediaId, String recipientId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.post('/chat/$chatId/messages', data: {
        'media_id': mediaId,
        'tipo': 'media',
        'destinatario_id': recipientId,
      });
      
      if (response.statusCode == 201) {
        final message = ChatMensagem.fromJson(response.data);
        _addMessageToChat(chatId, message);
        return message;
      } else {
        _setError('Failed to send media message');
        return null;
      }
    } catch (e) {
      _setError('Error sending media message: $e');
      return null;
    }
  }

  // Delete message
  Future<bool> deleteMessage(String messageId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.delete('/chat/messages/$messageId');
      
      if (response.statusCode == 200) {
        _removeMessageFromAllChats(messageId);
        return true;
      } else {
        _setError('Failed to delete message');
        return false;
      }
    } catch (e) {
      _setError('Error deleting message: $e');
      return false;
    }
  }

  // Mark messages as read
  Future<bool> markMessagesAsRead(String chatId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.put('/chat/$chatId/read');
      
      if (response.statusCode == 200) {
        // Update local messages to mark as read
        final messages = _chatMessages[chatId];
        if (messages != null) {
          _chatMessages[chatId] = messages.map((msg) => msg).toList();
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to mark messages as read');
        return false;
      }
    } catch (e) {
      _setError('Error marking messages as read: $e');
      return false;
    }
  }

  // Get user chats
  Future<List<Map<String, dynamic>>> getUserChats() async {
    _clearError();

    try {
      final response = await _apiClient.dio.get('/user/chats');
      
      if (response.statusCode == 200) {
        final List<dynamic> chatsJson = response.data['data'];
        return chatsJson.map((json) => json as Map<String, dynamic>).toList();
      } else {
        _setError('Failed to get user chats');
        return [];
      }
    } catch (e) {
      _setError('Error getting user chats: $e');
      return [];
    }
  }

  // Start new chat
  Future<Map<String, dynamic>?> startChat(String recipientId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.post('/chat/start', data: {
        'destinatario_id': recipientId,
      });
      
      if (response.statusCode == 201) {
        return response.data as Map<String, dynamic>;
      } else {
        _setError('Failed to start chat');
        return null;
      }
    } catch (e) {
      _setError('Error starting chat: $e');
      return null;
    }
  }

  // Send typing indicator
  Future<void> sendTypingIndicator(String chatId, bool isTyping) async {
    try {
      _isTyping = isTyping;
      notifyListeners();

      await _apiClient.dio.post('/chat/$chatId/typing', data: {
        'is_typing': isTyping,
      });
    } catch (e) {
      // Don't set error for typing indicator failures
      debugPrint('Error sending typing indicator: $e');
    }
  }

  // Get unread messages count
  Future<int> getUnreadMessagesCount() async {
    _clearError();

    try {
      final response = await _apiClient.dio.get('/user/unread-count');
      
      if (response.statusCode == 200) {
        return response.data['count'] as int;
      } else {
        _setError('Failed to get unread count');
        return 0;
      }
    } catch (e) {
      _setError('Error getting unread count: $e');
      return 0;
    }
  }

  // Add new message to chat (for real-time updates)
  void addNewMessage(String chatId, ChatMensagem message) {
    _addMessageToChat(chatId, message);
  }

  // Update message (for real-time updates)
  void updateMessage(String chatId, ChatMensagem updatedMessage) {
    final messages = _chatMessages[chatId];
    if (messages != null) {
      final index = messages.indexWhere((msg) => msg.id == updatedMessage.id);
      if (index != -1) {
        messages[index] = updatedMessage;
        notifyListeners();
      }
    }
  }

  // Clear chat messages (for logout)
  void clearChatMessages() {
    _messages = [];
    _chatMessages.clear();
    notifyListeners();
  }

  // Clear specific chat
  void clearChat(String chatId) {
    _chatMessages.remove(chatId);
    if (_messages.isNotEmpty && _messages.first.chatId == chatId) {
      _messages = [];
    }
    notifyListeners();
  }

  // Private helper methods
  void _addMessageToChat(String chatId, ChatMensagem message) {
    if (!_chatMessages.containsKey(chatId)) {
      _chatMessages[chatId] = [];
    }
    _chatMessages[chatId]!.add(message);
    _messages = _chatMessages[chatId]!;
    notifyListeners();
  }

  void _removeMessageFromAllChats(String messageId) {
    for (final chatId in _chatMessages.keys) {
      _chatMessages[chatId]!.removeWhere((msg) => msg.id == messageId);
    }
    _messages.removeWhere((msg) => msg.id == messageId);
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
    notifyListeners();
  }

  // Public method to clear error
  void clearError() {
    _clearError();
  }
}
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../services/api_client.dart';

class UserProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient.instance;
  
  User? _currentUser;
  List<User> _users = [];
  bool _isLoading = false;
  String? _error;

  // Getters
  User? get user => _currentUser;
  List<User> get users => _users;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setToken(String token) {
    _apiClient.setToken(token);
  }

  // Set current user (usually after login)
  void setUser(User? user) {
    _currentUser = user;
    notifyListeners();
  }

  // Clear current user (usually after logout)
  void clearCurrentUser() {
    _currentUser = null;
    notifyListeners();
  }

  // Get user by ID
  User? getUserById(String id) {
    try {
      return _users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }

  // Fetch current user profile
  Future<void> fetchUser() async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.dio.get('/api/profile');
      
      if (response.statusCode == 200) {
        _currentUser = User.fromJson(response.data);
        notifyListeners();
      } else {
        _setError('Failed to fetch user profile');
      }
    } catch (e) {
      _setError('Error fetching user profile: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Update user profile
  Future<bool> updateProfile(Map<String, dynamic> userData) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.dio.put('/api/profile', data: userData);
      
      if (response.statusCode == 200) {
        if (_currentUser != null) {
          _currentUser = User.fromJson(response.data);
          notifyListeners();
        }
        return true;
      } else {
        _setError('Failed to update profile');
        return false;
      }
    } catch (e) {
      _setError('Error updating profile: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Fetch users list (for admin or search purposes)
  Future<void> fetchUsers({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.dio.get('/users', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data['data'];
        _users = usersJson.map((json) => User.fromJson(json)).toList();
        notifyListeners();
      } else {
        _setError('Failed to fetch users');
      }
    } catch (e) {
      _setError('Error fetching users: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Search users
  Future<List<User>> searchUsers(String query, {int limit = 10}) async {
    _clearError();

    try {
      final response = await _apiClient.dio.get('/users/search', queryParameters: {
        'q': query,
        'limit': limit,
      });
      
      if (response.statusCode == 200) {
        final List<dynamic> usersJson = response.data['data'];
        return usersJson.map((json) => User.fromJson(json)).toList();
      } else {
        _setError('Failed to search users');
        return [];
      }
    } catch (e) {
      _setError('Error searching users: $e');
      return [];
    }
  }

  // Get user matches (for dating app functionality)
  Future<List<User>> getUserMatches() async {
    _clearError();

    try {
      final response = await _apiClient.dio.get('/user/matches');
      
      if (response.statusCode == 200) {
        final List<dynamic> matchesJson = response.data['data'];
        return matchesJson.map((json) => User.fromJson(json)).toList();
      } else {
        _setError('Failed to get matches');
        return [];
      }
    } catch (e) {
      _setError('Error getting matches: $e');
      return [];
    }
  }

  // Like/Unlike user
  Future<bool> toggleLikeUser(String userId) async {
    _clearError();

    try {
      final response = await _apiClient.dio.post('/users/$userId/like');
      
      if (response.statusCode == 200) {
        return true;
      } else {
        _setError('Failed to toggle like');
        return false;
      }
    } catch (e) {
      _setError('Error toggling like: $e');
      return false;
    }
  }

  // Private helper methods
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
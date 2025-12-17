import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/media.dart';
import '../services/upload_service.dart';

class MediaProvider extends ChangeNotifier {
  final UploadService _uploadService = UploadService();
  
  List<Media> _mediaList = [];
  List<Media> _userMedia = [];
  Media? _currentMedia;
  bool _isLoading = false;
  String? _error;
  double _uploadProgress = 0.0;

  void setToken(String? token) {
    // _uploadService.setToken(token); // TODO: Implement setToken in UploadService
  }

  // Getters
  List<Media> get mediaList => _mediaList;
  List<Media> get userMedia => _userMedia;
  Media? get currentMedia => _currentMedia;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get uploadProgress => _uploadProgress;

  // Fetch all media for current Firebase user (admin view could filter client-side)
  Future<void> fetchAllMedia({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _clearError();

    try {
      final items = await _uploadService.listMedia();

      _mediaList = items
          .whereType<Map<String, dynamic>>()
          .map((json) => Media.fromJson(json))
          .toList();
      notifyListeners();
    } catch (e) {
      _setError('Error fetching media: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch current user's media
  Future<void> fetchUserMedia(String userId, {MediaType? type}) async {
    _setLoading(true);
    _clearError();

    try {
      final items = await _uploadService.listMedia();

      var list = items
          .whereType<Map<String, dynamic>>()
          .map((json) => Media.fromJson(json))
          .toList();

      if (type != null) {
        list = list.where((m) => m.type == type).toList();
      }

      _userMedia = list;
      notifyListeners();
    } catch (e) {
      _setError('Error fetching user media: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Upload media file
  Future<Media?> uploadMedia(
    String filePath, {
    MediaType type = MediaType.image,
    String? filename,
    Function(double)? onProgress,
  }) async {
    _setLoading(true);
    _clearError();
    _uploadProgress = 0.0;

    try {
      final file = File(filePath);

      final response =
          await _uploadService.uploadMediaFile(file, type.value);

      final mediaJson = _buildMediaJsonFromUploadResponse(response);

      final media = Media.fromJson(mediaJson);

      _userMedia.add(media);
      notifyListeners();

      return media;
    } catch (e) {
      _setError('Error uploading media: $e');
      return null;
    } finally {
      _setLoading(false);
      _uploadProgress = 0.0;
      notifyListeners();
    }
  }

  // Upload media from bytes (for web)
  Future<Media?> uploadMediaFromBytes(
    Uint8List bytes,
    String filename, {
    MediaType type = MediaType.image,
    Function(double)? onProgress,
  }) async {
    _setLoading(true);
    _clearError();
    _uploadProgress = 0.0;

    try {
      final uploadResponse = await _uploadService.uploadMediaBytes(
        bytes,
        filename,
        type.value,
      );

      final mediaJson =
          _buildMediaJsonFromUploadResponse(uploadResponse);

      final media = Media.fromJson(mediaJson);

      _userMedia.add(media);
      notifyListeners();

      return media;
    } catch (e) {
      _setError('Error uploading media from bytes: $e');
      return null;
    } finally {
      _setLoading(false);
      _uploadProgress = 0.0;
      notifyListeners();
    }
  }

  // Get media by ID
  Future<Media?> getMediaById(String mediaId) async {
    _clearError();

    try {
      // Try from local cache first
      final existing = _userMedia.firstWhere(
        (m) => m.id == mediaId,
        orElse: () => _mediaList.firstWhere(
          (m) => m.id == mediaId,
          orElse: () => Media(
            id: '',
            userUid: '',
            type: MediaType.image,
            filename: '',
            path: '',
            url: '',
            size: 0,
            createdAt: DateTime.fromMillisecondsSinceEpoch(0),
            updatedAt: DateTime.fromMillisecondsSinceEpoch(0),
          ),
        ),
      );

      if (existing.id.isNotEmpty) {
        _currentMedia = existing;
        notifyListeners();
        return _currentMedia;
      }

      // Fallback: reload list and search
      final items = await _uploadService.listMedia();
      final list = items
          .whereType<Map<String, dynamic>>()
          .map((json) => Media.fromJson(json))
          .toList();

      _userMedia = list;
      _currentMedia = list.firstWhere(
        (m) => m.id == mediaId,
        orElse: () => _currentMedia ?? list.first,
      );
      notifyListeners();
      return _currentMedia;
    } catch (e) {
      _setError('Error getting media: $e');
      return null;
    }
  }

  // Delete media
  Future<bool> deleteMedia(String mediaId) async {
    _setLoading(true);
    _clearError();

    try {
      await _uploadService.deleteMedia(mediaId);

      _userMedia.removeWhere((media) => media.id == mediaId);
      _mediaList.removeWhere((media) => media.id == mediaId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('Error deleting media: $e');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // Get view URL for media
  Future<String?> getMediaViewUrl(String mediaPath) async {
    _clearError();

    try {
      final url = await _uploadService.getViewUrl(mediaPath);
      return url;
    } catch (e) {
      _setError('Error getting media view URL: $e');
      return null;
    }
  }

  // Clear user media (for logout)
  void clearUserMedia() {
    _userMedia = [];
    _currentMedia = null;
    notifyListeners();
  }

  // Private helper methods
  Map<String, dynamic> _buildMediaJsonFromUploadResponse(
    Map<String, dynamic> response,
  ) {
    Map<String, dynamic> base;

    final mediaValue = response['media'];
    if (mediaValue is Map) {
      base = Map<String, dynamic>.from(mediaValue);
    } else {
      base = Map<String, dynamic>.from(response);
    }

    final urlValue = response['url'];
    if (urlValue is String) {
      base['url'] = urlValue;
    }

    return base;
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
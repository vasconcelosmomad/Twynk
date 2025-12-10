import 'dart:io';
import 'package:flutter/foundation.dart';
import '../models/media.dart';
import '../services/api_client.dart';
import '../services/upload_service.dart';

class MediaProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient.instance;
  final UploadService _uploadService = UploadService();
  
  List<Media> _mediaList = [];
  List<Media> _userMedia = [];
  Media? _currentMedia;
  bool _isLoading = false;
  String? _error;
  double _uploadProgress = 0.0;

  // Getters
  List<Media> get mediaList => _mediaList;
  List<Media> get userMedia => _userMedia;
  Media? get currentMedia => _currentMedia;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get uploadProgress => _uploadProgress;

  // Fetch all media (for admin)
  Future<void> fetchAllMedia({int page = 1, int limit = 20}) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiClient.dio.get('/media', queryParameters: {
        'page': page,
        'limit': limit,
      });
      
      if (response.statusCode == 200) {
        final List<dynamic> mediaJson = response.data['data'];
        _mediaList = mediaJson.map((json) => Media.fromJson(json)).toList();
        notifyListeners();
      } else {
        _setError('Failed to fetch media');
      }
    } catch (e) {
      _setError('Error fetching media: $e');
    } finally {
      _setLoading(false);
    }
  }

  // Fetch user's media
  Future<void> fetchUserMedia(String userId, {MediaType? type}) async {
    _setLoading(true);
    _clearError();

    try {
      final queryParams = <String, dynamic>{};
      if (type != null) {
        queryParams['type'] = type.value;
      }

      final response = await _apiClient.dio.get('/media/user/$userId', queryParameters: queryParams);
      
      if (response.statusCode == 200) {
        final List<dynamic> mediaJson = response.data['data'];
        _userMedia = mediaJson.map((json) => Media.fromJson(json)).toList();
        notifyListeners();
      } else {
        _setError('Failed to fetch user media');
      }
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
      
      // Get presigned URL
      final presignResponse = await _uploadService.getPresignedUrl(file, type.value);

      // Upload file
      await _uploadService.uploadFileToPresignedUrl(
        file,
        presignResponse['uploadUrl'] as String,
        presignResponse['contentType'] as String,
      );

      // Register media
      await _uploadService.registerMedia(
        presignResponse['key'] as String,
        file,
        type.value,
      );

      // Create media object (simplified - in real implementation, you'd get this from backend)
      final media = Media(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // temporary
        userUid: '', // should get from current user
        type: type,
        filename: filename ?? filePath.split('/').last,
        path: presignResponse['key'] as String,
        url: '', // would get from backend
        size: await file.length(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

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
      // Get upload URL for bytes
      final uploadResponse = await _uploadService.getUploadUrl(
        type.value,
        filename.split('.').last,
      );

      // Upload bytes
      await _uploadService.uploadBytesToPresignedUrl(
        bytes,
        uploadResponse['uploadUrl'] as String,
        uploadResponse['contentType'] as String,
      );

      // Register media from metadata
      await _uploadService.registerMediaFromMeta(
        uploadResponse['key'] as String,
        filename,
        bytes.length,
        type.value,
      );

      // Create media object (simplified)
      final media = Media(
        id: DateTime.now().millisecondsSinceEpoch.toString(), // temporary
        userUid: '', // should get from current user
        type: type,
        filename: filename,
        path: uploadResponse['key'] as String,
        url: '', // would get from backend
        size: bytes.length,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

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
      final response = await _apiClient.dio.get('/media/$mediaId');
      
      if (response.statusCode == 200) {
        _currentMedia = Media.fromJson(response.data);
        notifyListeners();
        return _currentMedia;
      } else {
        _setError('Failed to get media');
        return null;
      }
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
      final response = await _apiClient.dio.delete('/media/$mediaId');
      
      if (response.statusCode == 200) {
        _userMedia.removeWhere((media) => media.id == mediaId);
        _mediaList.removeWhere((media) => media.id == mediaId);
        notifyListeners();
        return true;
      } else {
        _setError('Failed to delete media');
        return false;
      }
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

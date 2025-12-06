import 'dart:io';
import 'package:dio/dio.dart';
import 'package:twynk_frontend/models/snap.dart';
import 'package:twynk_frontend/services/api_client.dart';

class SnapService {
  static final SnapService _instance = SnapService._internal();
  factory SnapService() => _instance;
  SnapService._internal();

  final ApiClient _apiClient = ApiClient.instance;

  Future<List<Snap>> getSnaps({bool onlyPublic = false}) async {
    try {
      final response = await _apiClient.dio.get(
        '/snaps',
        queryParameters: onlyPublic ? {'visibility': 'public'} : null,
      );
      
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((json) => Snap.fromJson(json)).toList();
      } else {
        throw Exception('Falha ao carregar snaps');
      }
    } on DioException catch (e) {
      // Fallback para dados mock quando API não está disponível (CORS, servidor offline, etc.)
      if (e.type == DioExceptionType.connectionError || 
          e.message?.contains('CORS') == true ||
          e.message?.contains('Network') == true) {
        return _getMockSnaps();
      }
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao carregar snaps: $e');
    }
  }

  List<Snap> _getMockSnaps() {
    return [
      Snap(
        id: '1',
        userId: 'user1',
        userName: 'João Silva',
        userAvatar: '',
        videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        description: 'Olá! Sou desenvolvedor Flutter e adoro criar apps incríveis.',
        visibility: SnapVisibility.public,
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 42,
        dislikes: 3,
        comments: 8,
      ),
      Snap(
        id: '2',
        userId: 'user2',
        userName: 'Maria Santos',
        userAvatar: '',
        videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        description: 'Apaixonada por design e UX. Criando experiências digitais incríveis!',
        visibility: SnapVisibility.public,
        createdAt: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 128,
        dislikes: 7,
        comments: 23,
      ),
      Snap(
        id: '3',
        userId: 'user3',
        userName: 'Pedro Costa',
        userAvatar: '',
        videoUrl: 'https://storage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        description: 'Entusiasta de IA e machine learning. Transformando dados em soluções!',
        visibility: SnapVisibility.private,
        createdAt: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 89,
        dislikes: 12,
        comments: 15,
      ),
    ];
  }

  Future<Snap> getSnapById(String id) async {
    try {
      final response = await _apiClient.dio.get('/snaps/$id');
      
      if (response.statusCode == 200) {
        return Snap.fromJson(response.data);
      } else {
        throw Exception('Snap não encontrado');
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao carregar snap: $e');
    }
  }

  Future<Snap> createSnap({
    required String videoUrl,
    required String description,
    required SnapVisibility visibility,
    String? userName,
    String? userAvatar,
  }) async {
    try {
      final data = {
        'videoUrl': videoUrl,
        'description': description,
        'visibility': visibility.name,
        if (userName != null) 'userName': userName,
        if (userAvatar != null) 'userAvatar': userAvatar,
      };

      final response = await _apiClient.dio.post('/snaps', data: data);
      
      if (response.statusCode == 201) {
        return Snap.fromJson(response.data);
      } else {
        throw Exception('Falha ao criar snap');
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao criar snap: $e');
    }
  }

  Future<Snap> updateSnapVisibility(String snapId, SnapVisibility newVisibility) async {
    try {
      final response = await _apiClient.dio.patch(
        '/snaps/$snapId/visibility',
        data: {'visibility': newVisibility.name},
      );
      
      if (response.statusCode == 200) {
        return Snap.fromJson(response.data);
      } else {
        throw Exception('Falha ao atualizar visibilidade do snap');
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao atualizar visibilidade: $e');
    }
  }

  Future<bool> deleteSnap(String id) async {
    try {
      final response = await _apiClient.dio.delete('/snaps/$id');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao deletar snap: $e');
    }
  }

  Future<bool> likeSnap(String snapId) async {
    try {
      final response = await _apiClient.dio.post('/snaps/$snapId/like');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao curtir snap: $e');
    }
  }

  Future<bool> dislikeSnap(String snapId) async {
    try {
      final response = await _apiClient.dio.post('/snaps/$snapId/dislike');
      return response.statusCode == 200;
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao descurtir snap: $e');
    }
  }

  Future<String> uploadVideo(File videoFile) async {
    try {
      final formData = FormData.fromMap({
        'video': await MultipartFile.fromFile(videoFile.path),
      });

      final response = await _apiClient.dio.post('/snaps/upload', data: formData);
      
      if (response.statusCode == 200) {
        return response.data['videoUrl'] as String;
      } else {
        throw Exception('Falha ao fazer upload do vídeo');
      }
    } on DioException catch (e) {
      throw Exception('Erro de conexão: ${e.message}');
    } catch (e) {
      throw Exception('Erro ao fazer upload: $e');
    }
  }
}

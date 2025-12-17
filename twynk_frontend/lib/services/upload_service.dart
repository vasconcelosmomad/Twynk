import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'api_client.dart';

/// Serviço responsável por fazer upload de arquivos para o backend
/// usando o fluxo de URLs presignadas de storage (ex.: GCS).
class UploadService {
  /// Cliente HTTP que reutiliza o ApiClient (JWT via auth:api).
  final Dio dio = ApiClient.instance.dio;
  static const String _basePath = '/api';

  Future<Map<String, dynamic>> uploadMediaFile(
    File file,
    String type,
  ) async {
    final filename = file.path.split('/').last;

    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: filename,
      ),
      'type': type,
    });

    final resp = await dio.post(
      '$_basePath/media/upload',
      data: formData,
    );

    final raw = resp.data;
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return Map<String, dynamic>.from(raw as Map);
  }

  Future<Map<String, dynamic>> uploadMediaBytes(
    Uint8List bytes,
    String filename,
    String type,
  ) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        bytes,
        filename: filename,
      ),
      'type': type,
    });

    final resp = await dio.post(
      '$_basePath/media/upload',
      data: formData,
    );

    final raw = resp.data;
    if (raw is Map<String, dynamic>) {
      return raw;
    }
    return Map<String, dynamic>.from(raw as Map);
  }

  /// 3) Obter URL temporária de visualização para uma mídia já armazenada.
  Future<String> getViewUrl(String path) async {
    final resp = await dio.post(
      '$_basePath/media/view-url',
      data: {'path': path},
    );

    final data = resp.data;
    if (data is Map && data['url'] is String) {
      return data['url'] as String;
    }
    throw Exception('Resposta inválida ao obter URL de visualização');
  }

  /// 4) Listar mídias do usuário autenticado (via JWT auth:api).
  Future<List<dynamic>> listMedia() async {
    final resp = await dio.get('$_basePath/media');

    final data = resp.data;
    if (data is List) {
      return data;
    }
    if (data is Map && data['data'] is List) {
      return List<dynamic>.from(data['data'] as List);
    }
    throw Exception('Resposta inválida ao listar mídias');
  }

  /// 5) Deletar mídia do usuário autenticado.
  Future<void> deleteMedia(String id) async {
    await dio.delete('$_basePath/media/$id');
  }
}

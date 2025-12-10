import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mime/mime.dart';
import 'api_config.dart';

/// Serviço responsável por fazer upload de arquivos para o backend
/// usando o fluxo de URLs presignadas (Backblaze B2 / S3).
class UploadService {
  /// Cliente HTTP isolado, pois aqui usamos autenticação do Firebase
  /// (idToken) e não o JWT padrão do ApiClient.
  final Dio dio = Dio();

  /// Base URL do backend apontando para o prefixo /api.
  /// Usa o ApiConfig.baseUrl para respeitar o ambiente (dev/prod).
  /// Ex.: http://localhost:8080/api em dev ou https://seu-backend.com/api em produção.
  final String backendBase = "${ApiConfig.baseUrl}/api";

  /// 1) Obtém URL presignada para upload direto no storage.
  Future<Map<String, dynamic>> getPresignedUrl(File file, String type) async {
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    final filename = file.path.split('/').last;
    final mimeType = lookupMimeType(filename) ?? 'application/octet-stream';

    final resp = await dio.post(
      '$backendBase/media/presign',
      data: {
        'filename': filename,
        'contentType': mimeType,
        'type': type,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// 2) Envia o arquivo binário para a URL presignada (PUT).
  Future<void> uploadFileToPresignedUrl(
    File file,
    String uploadUrl,
    String contentType,
  ) async {
    final bytes = await file.readAsBytes();

    await dio.put(
      uploadUrl,
      data: bytes,
      options: Options(headers: {
        'Content-Type': contentType,
      }),
    );
  }

  /// 3) Registra os metadados da mídia no backend após o upload.
  Future<void> registerMedia(String key, File file, String type) async {
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    await dio.post(
      '$backendBase/media/register',
      data: {
        'key': key,
        'filename': file.path.split('/').last,
        'size': await file.length(),
        'type': type,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );
  }

  /// 4) Fluxo completo: presign -> upload -> register.
  Future<void> uploadAndRegister(File file, String type) async {
    final presign = await getPresignedUrl(file, type);

    final contentType =
        lookupMimeType(file.path) ?? 'application/octet-stream';

    await uploadFileToPresignedUrl(
      file,
      presign['uploadUrl'] as String,
      contentType,
    );

    await registerMedia(
      presign['key'] as String,
      file,
      type,
    );
  }

  /// Forma alternativa compatível com o exemplo:
  /// 1) Pega URL de upload a partir de type + extension.
  Future<Map<String, dynamic>> getUploadUrl(
    String type,
    String extension,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    final fakeFilename = 'upload.$extension';
    final contentType =
        lookupMimeType(fakeFilename) ?? 'application/octet-stream';

    final resp = await dio.post(
      '$backendBase/media/upload-url',
      data: {
        'filename': fakeFilename,
        'contentType': contentType,
        'type': type,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    return Map<String, dynamic>.from(resp.data as Map);
  }

  /// 2) Envia o arquivo binário direto para a URL presignada (B2).
  Future<void> uploadFileToB2(File file, String uploadUrl) async {
    final bytes = await file.readAsBytes();

    await dio.put(
      uploadUrl,
      data: bytes,
      options: Options(headers: {
        'Content-Type': 'application/octet-stream',
      }),
    );
  }

  /// 2b) Envia bytes crus para a URL presignada (uso em Flutter Web).
  Future<void> uploadBytesToPresignedUrl(
    Uint8List bytes,
    String uploadUrl,
    String contentType,
  ) async {
    await dio.put(
      uploadUrl,
      data: bytes,
      options: Options(headers: {
        'Content-Type': contentType,
      }),
    );
  }

  /// 3b) Registra mídia usando apenas metadados (sem File), útil no Web.
  Future<void> registerMediaFromMeta(
    String key,
    String filename,
    int size,
    String type,
  ) async {
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    await dio.post(
      '$backendBase/media/register',
      data: {
        'key': key,
        'filename': filename,
        'size': size,
        'type': type,
      },
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );
  }

  /// 3) Obter URL temporária de visualização para uma mídia já armazenada.
  Future<String> getViewUrl(String path) async {
    final user = FirebaseAuth.instance.currentUser!;
    final idToken = await user.getIdToken();

    final resp = await dio.get(
      '$backendBase/media/view-url',
      queryParameters: {'path': path},
      options: Options(headers: {
        'Authorization': 'Bearer $idToken',
      }),
    );

    final data = resp.data;
    if (data is Map && data['url'] is String) {
      return data['url'] as String;
    }
    throw Exception('Resposta inválida ao obter URL de visualização');
  }
}

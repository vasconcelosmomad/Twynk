import 'package:dio/dio.dart';
import 'api_config.dart';

/// Fornece um cliente HTTP Dio configurado como singleton para o app.
/// - Define o baseUrl a partir do ApiConfig
/// - Aplica cabeçalhos JSON e timeouts
/// - Anexa o token Bearer de Authorization quando disponível
class ApiClient {
  /// Construtor privado que configura o Dio com opções básicas e um
  /// interceptor para injetar o cabeçalho Authorization quando um token estiver definido.
  ApiClient._internal()
      : _dio = Dio(
          BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            headers: const {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 15),
          ),
        ) {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null && _token!.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        handler.next(options);
      },
    ));
  }

  static final ApiClient instance = ApiClient._internal();

  final Dio _dio;
  String? _token;

  /// Retorna a instância do Dio configurada (com interceptors aplicados).
  Dio get dio => _dio;

  /// Define o token JWT usado no cabeçalho Authorization para chamadas subsequentes.
  void setToken(String token) {
    _token = token;
  }

  /// Limpa o token de Authorization das próximas requisições.
  void clearToken() {
    _token = null;
  }
}
import 'package:flutter/foundation.dart';

/// Configuração central para a REST API usada pelo app.
/// Expõe o `baseUrl` ajustado por plataforma (Web, emulador Android, etc.).
class ApiConfig {
  ApiConfig._();

  /// Retorna a URL base da REST API dependendo da plataforma em tempo de execução.
  /// - Web/Desktop: http://localhost:8080 (Nginx do Docker mapeia 8080)
  /// - Emulador Android: http://10.0.2.2:8080 (loopback do host)
  static String get baseUrl {
    // Web (served via Nginx on 8080 in docker-compose)
    if (kIsWeb) return 'http://localhost:8080';

    // On Android emulators, localhost is 10.0.2.2
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return 'http://192.168.43.234:8080';
      default:
        return 'http://localhost:8080';
    }
  }
}
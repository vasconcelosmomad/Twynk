import 'package:dio/dio.dart';
import 'api_client.dart';

/// Chamadas de API relacionadas à autenticação.
/// Utiliza o ApiClient (Dio) e gerencia a definição do token JWT após o login.
class AuthService {
  AuthService._();
  static final AuthService instance = AuthService._();

  /// Realiza login por email/senha via POST /api/login.
  /// Em caso de sucesso, armazena o token JWT no ApiClient e retorna um mapa:
  /// { success: true, token: string, user: dynamic }
  /// Em caso de falha, retorna: { success: false, error: message }
  Future<Map<String, dynamic>> login({required String email, required String password}) async {
    try {
      final Dio dio = ApiClient.instance.dio;
      final res = await dio.post('/api/login', data: {
        'email': email,
        'password': password,
      });
      if (res.statusCode == 200 && res.data is Map) {
        final data = res.data as Map<String, dynamic>;
        final token = data['token'];
        if (token is String && token.isNotEmpty) {
          ApiClient.instance.setToken(token);
          return {'success': true, 'token': token, 'user': data['user']};
        }
        return {'success': false, 'error': 'Resposta inválida do servidor.'};
      }
      final data = res.data;
      final msg = (data is Map && data['error'] != null) ? data['error'].toString() : 'Erro ao autenticar';
      return {'success': false, 'error': msg};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : (status != null ? 'Erro ao autenticar. Código $status.' : 'Falha de rede.');
      return {'success': false, 'error': msg};
    } catch (e) {
      return {'success': false, 'error': 'Falha de rede: $e'};
    }
  }
}

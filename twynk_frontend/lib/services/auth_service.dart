import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
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

  /// Realiza cadastro via POST /api/register.
  /// Espera receber ao menos: nome, genero, data_nascimento, email, password,
  /// e opcionalmente: apelido, interesse, foto_perfil, bio, localizacao,
  /// pais_id, provincia_id, cidade_id.
  /// Retorna o mesmo formato do login: { success, token, user | error }.
  Future<Map<String, dynamic>> register({
    required Map<String, dynamic> data,
  }) async {
    try {
      final Dio dio = ApiClient.instance.dio;
      final res = await dio.post('/api/register', data: data);

      if ((res.statusCode == 200 || res.statusCode == 201) && res.data is Map) {
        final body = res.data as Map<String, dynamic>;
        final token = body['token'];
        if (token is String && token.isNotEmpty) {
          ApiClient.instance.setToken(token);
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', token);
          return {'success': true, 'token': token, 'user': body['user']};
        }
        return {
          'success': false,
          'error': 'Resposta de cadastro inválida do servidor.',
        };
      }

      final body = res.data;
      final msg = (body is Map && body['error'] != null)
          ? body['error'].toString()
          : 'Erro ao registrar';
      return {'success': false, 'error': msg};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg = (data is Map && data['error'] != null)
          ? data['error'].toString()
          : (status != null
              ? 'Erro ao registrar. Código $status.'
              : 'Falha de rede.');
      return {'success': false, 'error': msg};
    } catch (e) {
      return {'success': false, 'error': 'Falha de rede: $e'};
    }
  }

  /// Envia um código OTP para o e-mail informado via POST /api/otp/send.
  /// Retorna { success: true, message } ou { success: false, error }.
  Future<Map<String, dynamic>> sendOtp({
    required String email,
  }) async {
    try {
      final Dio dio = ApiClient.instance.dio;
      final res = await dio.post('/api/otp/send', data: {
        'email': email,
      });

      if (res.statusCode == 200 && res.data is Map) {
        final body = res.data as Map<String, dynamic>;
        return {
          'success': true,
          'message': (body['message'] ?? 'OTP enviado com sucesso.').toString(),
        };
      }

      final body = res.data;
      final msg = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : 'Erro ao enviar código OTP.';
      return {'success': false, 'error': msg};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : (status != null
              ? 'Erro ao enviar código OTP. Código $status.'
              : 'Falha de rede.');
      return {'success': false, 'error': msg};
    } catch (e) {
      return {'success': false, 'error': 'Falha de rede: $e'};
    }
  }

  /// Verifica um código OTP via POST /api/otp/verify.
  /// Retorna { success: true, message } ou { success: false, error }.
  Future<Map<String, dynamic>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    try {
      final Dio dio = ApiClient.instance.dio;
      final res = await dio.post('/api/otp/verify', data: {
        'email': email,
        'otp': otp,
      });

      if (res.statusCode == 200 && res.data is Map) {
        final body = res.data as Map<String, dynamic>;
        return {
          'success': true,
          'message': (body['message'] ?? 'Código verificado com sucesso.').toString(),
        };
      }

      final body = res.data;
      final msg = (body is Map && body['message'] != null)
          ? body['message'].toString()
          : 'Erro ao verificar código OTP.';
      return {'success': false, 'error': msg};
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      final data = e.response?.data;
      final msg = (data is Map && data['message'] != null)
          ? data['message'].toString()
          : (status != null
              ? 'Erro ao verificar código OTP. Código $status.'
              : 'Falha de rede.');
      return {'success': false, 'error': msg};
    } catch (e) {
      return {'success': false, 'error': 'Falha de rede: $e'};
    }
  }
}

import 'package:flutter/foundation.dart';
import '../services/api_client.dart';
import '../models/pais.dart';
import '../models/provincia.dart';
import '../models/cidade.dart';

class LocationProvider extends ChangeNotifier {
  final ApiClient _apiClient = ApiClient.instance;

  List<Pais> _paises = [];
  List<Provincia> _provincias = [];
  List<Cidade> _cidades = [];

  bool _isLoading = false;
  String? _error;

  List<Pais> get paises => _paises;
  List<Provincia> get provincias => _provincias;
  List<Cidade> get cidades => _cidades;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _error = message;
    notifyListeners();
  }

  Future<void> fetchPaises() async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiClient.dio.get('/paises');
      final data = response.data;
      final List<dynamic> items =
          data is Map<String, dynamic> ? (data['data'] as List<dynamic>) : (data as List<dynamic>);
      _paises = items.map((e) => Pais.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _setError('Erro ao carregar países: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProvincias({String? paisId}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiClient.dio.get(
        '/provincias',
        queryParameters: paisId != null ? {'pais_id': paisId} : null,
      );
      final data = response.data;
      final List<dynamic> items =
          data is Map<String, dynamic> ? (data['data'] as List<dynamic>) : (data as List<dynamic>);
      _provincias = items.map((e) => Provincia.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _setError('Erro ao carregar províncias: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCidades({String? provinciaId}) async {
    _setLoading(true);
    _setError(null);
    try {
      final response = await _apiClient.dio.get(
        '/cidades',
        queryParameters: provinciaId != null ? {'provincia_id': provinciaId} : null,
      );
      final data = response.data;
      final List<dynamic> items =
          data is Map<String, dynamic> ? (data['data'] as List<dynamic>) : (data as List<dynamic>);
      _cidades = items.map((e) => Cidade.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      _setError('Erro ao carregar cidades: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearError() {
    _setError(null);
  }
}

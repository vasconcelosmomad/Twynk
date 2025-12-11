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

  List<dynamic> _extractList(dynamic data, String key) {
    if (data is List) {
      return data;
    }
    if (data is Map<String, dynamic>) {
      final dynamic fromData = data['data'];
      // Caso 1: data: [ ... ]
      if (fromData is List) {
        return fromData;
      }
      // Caso 2: data: { current_page: 1, data: [ ... ] } (Laravel paginator)
      if (fromData is Map<String, dynamic>) {
        final dynamic innerData = fromData['data'];
        if (innerData is List) {
          return innerData;
        }
      }
      // Caso 3: lista sob uma chave específica (por exemplo, 'paises', 'provincias', 'cidades')
      final dynamic fromKey = data[key];
      if (fromKey is List) {
        return fromKey;
      }
    }
    return const <dynamic>[];
  }

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
      final response = await _apiClient.dio.get('/api/paises');
      final List<dynamic> items = _extractList(response.data, 'paises');
      _paises = items
          .whereType<Map<String, dynamic>>()
          .map((e) => Pais.fromJson(e))
          .toList();
    } catch (e) {
      _setError('Erro ao carregar países: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchProvincias({String? paisId}) async {
    if (paisId == null || paisId.isEmpty) {
      _provincias = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    _setError(null);
    try {
      // Usa a rota de relacionamento: /api/paises/{pais}/provincias
      final response = await _apiClient.dio.get('/api/paises/$paisId/provincias');
      final List<dynamic> items = _extractList(response.data, 'provincias');
      _provincias = items
          .whereType<Map<String, dynamic>>()
          .map((e) => Provincia.fromJson(e))
          .toList();
    } catch (e) {
      _setError('Erro ao carregar províncias: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCidades({String? provinciaId}) async {
    if (provinciaId == null || provinciaId.isEmpty) {
      _cidades = [];
      notifyListeners();
      return;
    }
    _setLoading(true);
    _setError(null);
    try {
      // Usa a rota de relacionamento: /api/provincias/{provincia}/cidades
      final response = await _apiClient.dio.get('/api/provincias/$provinciaId/cidades');
      final List<dynamic> items = _extractList(response.data, 'cidades');
      _cidades = items
          .whereType<Map<String, dynamic>>()
          .map((e) => Cidade.fromJson(e))
          .toList();
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

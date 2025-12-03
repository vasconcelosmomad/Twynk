import 'dart:convert';

import 'package:http/http.dart' as http;

Future<double?> converterMZNparaUSD(double valorMZN) async {
  final url = Uri.parse('https://api.exchangerate-api.com/v4/latest/USD');
  final response = await http.get(url);

  if (response.statusCode != 200) return null;

  final dynamic data = jsonDecode(response.body);
  if (data is! Map<String, dynamic>) return null;

  final dynamic rates = data['rates'];
  if (rates is! Map<String, dynamic>) return null;

  final dynamic taxa = rates['MZN'];
  if (taxa is! num || taxa == 0) return null;

  final double taxaMZN = taxa.toDouble();
  final double resultadoUSD = valorMZN / taxaMZN;

  return resultadoUSD;
}

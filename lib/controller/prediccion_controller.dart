import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/prediccion_mensual_model.dart';

class PrediccionController {
  final int codSocio;

  PrediccionController({required this.codSocio});

  Future<List<PrediccionMensual>> fetchPredicciones() async {
    final url = Uri.parse('http://192.168.0.19:5000/api/prediccion?cod_socio=$codSocio');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List<dynamic> predicciones = data["prediccion_mensual"];

      return predicciones
          .where((item) =>
              int.tryParse(item['mes'].toString()) != null &&
              int.parse(item['mes'].toString()) >= 1 &&
              int.parse(item['mes'].toString()) <= 12)
          .map((item) => PrediccionMensual.fromJson(item))
          .toList();
    } else {
      throw Exception('Error al obtener predicciones');
    }
  }
}

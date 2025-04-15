import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/consumo_model.dart';

class ConsumoController {
  Future<bool> subirConsumo({
    required int codSocio,
    required int numeroSerieIngresado,
    required int numeroSerieCorrecto,
    required ConsumoModel consumoModel,
  }) async {
    final url = Uri.parse("http://192.168.13.66/mimedidor_api/insertar_consumo.php");

    if (numeroSerieIngresado != numeroSerieCorrecto) {
      return false;
    }

    final body = {
      'cod_socio': codSocio.toString(),
      'numero_serie_ingresado': numeroSerieIngresado.toString(),
      'numero_serie_correcto': numeroSerieCorrecto.toString(),
      ...consumoModel.toJson(),
    };

    final response = await http.post(url, body: body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['success'] == true;
    } else {
      return false;
    }
  }
}

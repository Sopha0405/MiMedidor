import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/socio_model.dart';

class SocioController {
  final String apiUrl = "http://192.168.13.66/mimedidor_api";
  final int codSocio;

  SocioController({required this.codSocio});

  Future<Socio> fetchSocioData() async {
    final url = Uri.parse("$apiUrl/socio.php?cod_socio=$codSocio");

    print("📡 URL generada: $url");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data.containsKey("error")) {
          print("❌ Error en la respuesta: ${data['error']}");
          throw Exception("Error en la API: ${data['error']}");
        }

        print("📡 Datos recibidos: $data");
        return Socio.fromJson(data);
      } else {
        throw Exception("⚠️ Error HTTP: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error en fetchSocioData: $e");
      throw Exception("Error al conectar con la API: $e");
    }
  }

  Future<bool> verificarMedidor(int idMedidor) async {
    final url = Uri.parse("$apiUrl/verificar_medidor.php?cod_socio=$codSocio&id_medidor=$idMedidor");

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['esValido'] == true;
      } else {
        print("⚠️ Error HTTP en verificarMedidor: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error al verificar medidor: $e");
    }
    return false;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/cupon_model.dart';

class CuponController {
  final String _baseUrl = "http://192.168.0.15/mimedidor_api";

  Future<List<Cupon>> obtenerCupones(int codSocio) async {
    final url = Uri.parse("$_baseUrl/get_cupones.php?cod_socio=$codSocio");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> cuponesJson = jsonData["cupones"];
      return cuponesJson.map((e) => Cupon.fromJson(e)).toList();
    } else {
      throw Exception("Error al obtener cupones");
    }
  }

  Future<bool> crearCupon(Cupon cupon, int codSocio) async {
    final url = Uri.parse("$_baseUrl/crear_cupon.php");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(cupon.toJsonParaInsertar(codSocio)),
    );
    return response.statusCode == 200;
  }

    Future<bool> crearCuponAleatorio(int codSocio) async {
  final now = DateTime.now();
  final random = DateTime.now().millisecondsSinceEpoch.remainder(100000);

  final List<int> posiblesMontos = [5, 5, 5, 6, 6, 7, 7, 8, 9, 10, 11, 12, 13, 14, 15];
  final monto = posiblesMontos[random % posiblesMontos.length];

  final mesesExtra = 5 + (random % 3);
  final vencimiento = DateTime(now.year, now.month + mesesExtra, now.day);
  final mesActual = _nombreMes(now.month);
  final nuevoCodigo = "CUPON${now.year}${now.month.toString().padLeft(2, '0')}${random.toString().padLeft(5, '0')}";

  final nuevoCupon = Cupon(
    idCupon: 0,
    idSocio: codSocio,
    codigo: nuevoCodigo,
    descripcion: "Descuento $mesActual",
    fechaEmision: now.toIso8601String().split('T').first,
    fechaVencimiento: vencimiento.toIso8601String().split('T').first,
    estado: "activo",
    monto: monto,
  );

  return await crearCupon(nuevoCupon, codSocio);
}

  String _nombreMes(int mes) {
    const meses = [
      '', 'Enero', 'Febrero', 'Marzo', 'Abril', 'Mayo', 'Junio',
      'Julio', 'Agosto', 'Septiembre', 'Octubre', 'Noviembre', 'Diciembre'
    ];
    return meses[mes];
  }

}
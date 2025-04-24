import 'package:http/http.dart' as http;
import 'dart:convert';
import '../model/auth_model.dart';

class AuthController {
  final String baseUrl = 'http://192.168.0.15/mimedidor_api';
  final AuthModel model;

  AuthController(this.model);

  Future<bool> login() async {
    final response = await http.post(
      Uri.parse('$baseUrl/login.php'),
      body: model.toJson(),
    );
    final data = json.decode(response.body); 
    return data['success'] == true;
  }

  Future<bool> enviarOtp() async {
    final response = await http.post(
      Uri.parse('$baseUrl/enviar_otp.php'),
      body: model.toJson(),
    );
    
    final data = json.decode(response.body);
    return data['success'] == true;
  }

  Future<bool> verificarOtp(String codigo) async {
    final response = await http.post(
      Uri.parse('$baseUrl/verificar_otp.php'),
      body: {
        'cod_socio': model.codSocio.toString(),
        'codigo': codigo,
      },
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }

  Future<bool> cambiarContrasena(String nueva) async {
    final response = await http.post(
      Uri.parse('$baseUrl/cambiar_contrasena.php'),
      body: {
        'cod_socio': model.codSocio.toString(),
        'contrasena': nueva,
      },
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }

  Future<bool> activarCuenta() async {
    final response = await http.post(
      Uri.parse('$baseUrl/activar_cuenta.php'),
      body: model.toJson(),
    );
    final data = json.decode(response.body);
    return data['success'] == true;
  }
}
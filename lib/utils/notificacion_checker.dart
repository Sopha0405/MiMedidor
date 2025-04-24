import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'notificaciones.dart'; 

Future<void> verificarSubidaPendiente(
  BuildContext context,
  int codSocio,
  Function onCamara,
  Function onGaleria, {
  bool ignorarAlertas = false,
}) async {
  final url = Uri.parse("http://192.168.0.15/mimedidor_api/verificar_subida_consumo.php");
  final response = await http.post(url, body: {'cod_socio': codSocio.toString()});

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final bool bloqueado = data['bloqueado'] == 1;
    final List pendientes = data['pendientes'];
    final String? fechaUltimoRegistro = data['fecha_ultimo_registro'];
    final hoy = DateTime.now();

    if (bloqueado) {
      mostrarAlerta(
        context,
        '¡Socio bloqueado!',
        'No registraste tu consumo. Has sido bloqueado.',
        'Entendido',
        () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
      );
      return;
    }

    if (pendientes.isEmpty || ignorarAlertas) return;

    if (fechaUltimoRegistro != null) {
      final ultimaFecha = DateTime.parse(fechaUltimoRegistro);
      final int diaUltimo = ultimaFecha.day;
      final int diaActual = hoy.day;

      if (diaActual == diaUltimo - 1) {
        mostrarAlerta(
          context,
          '¡Recuerda!',
          'Mañana debes registrar tu consumo.',
          'Entendido',
          () => Navigator.pop(context),
        );
      } else if (diaActual == diaUltimo || diaActual == diaUltimo+1) {
        mostrarAlerta(
          context,
          'Registra tu consumo',
          'Hoy debes registrar tu consumo de agua.',
          'Ir',
          () => mostrarSelectorFuente(context, onCamara, onGaleria),
        );
      } else if (diaActual == diaUltimo + 2) {
        mostrarAlerta(
          context,
          '¡Último aviso!',
          'Registra tu consumo hoy. Estás a punto de ser bloqueado.',
          'Registrar',
          () => mostrarSelectorFuente(context, onCamara, onGaleria),
        );
      } else if (diaActual == diaUltimo + 3) {
        final bloquearUrl = Uri.parse("http://192.168.0.15/mimedidor_api/bloquear_socio.php");
        await http.post(bloquearUrl, body: {'cod_socio': codSocio.toString()});

        mostrarAlerta(
          context,
          '¡Bloqueado!',
          'No registraste tu consumo. Has sido bloqueado.',
          'Entendido',
          () => Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false),
        );
      }
    }
  }
}

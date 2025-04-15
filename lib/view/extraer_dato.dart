import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'subir_imagen_screen.dart';
import 'subir_consumo.dart';
import '../model/prediccion_mensual_model.dart';
import '../controller/prediccion_controller.dart';
import '../controller/socio_controller.dart';

class ExtraerDato {
  static final String apiKey = "AIzaSyCqKfGKBbLopRLL7rsatJ3W23eNUmwzE4I";
  static final String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=";

  static Future<void> extraerConsumo(BuildContext context, int codSocio) async {
    File? ultimaImagen = await _obtenerUltimaImagen();
    if (ultimaImagen == null) {
      _mostrarMensaje(context, "⚠️ No se encontró una imagen de medidor.");
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SubirImagenScreen(codSocio: codSocio)));
      return;
    }

    _mostrarMensaje(context, "📊 Extrayendo consumo de la imagen...");

    try {
      final bytes = await ultimaImagen.readAsBytes();
      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("$apiUrl$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}},
                {"text": "Extrae únicamente el número de consumo de agua del medidor en esta imagen y devuelve solo el número sin texto adicional."}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String consumoExtraido = jsonResponse["candidates"][0]["content"]["parts"][0]["text"].trim();
        await _validarConsumo(context, consumoExtraido, codSocio);
      } else {
        _mostrarMensaje(context, "⚠️ Error en la extracción. Intenta más tarde.");
      }
    } catch (e) {
      _mostrarMensaje(context, "🚨 Error al conectar con la API: $e");
    }
  }

  static Future<File?> _obtenerUltimaImagen() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().toList();
    files.sort((a, b) => b.statSync().modified.compareTo(a.statSync().modified));
    return files.isNotEmpty ? files.first : null;
  }

  static Future<void> _validarConsumo(BuildContext context, String consumoTexto, int codSocio) async {
    try {
      final socio = await SocioController(codSocio: codSocio).fetchSocioData();
      final predicciones = await PrediccionController(codSocio: codSocio).fetchPredicciones();

      final double consumoExtraido = double.parse(consumoTexto);
      final double consumoOperativo = consumoExtraido - socio.consumoTotal;

      int mesActual = DateTime.now().month;
      final prediccionMes = predicciones.firstWhere(
        (p) => p.mes.toInt() == mesActual,
        orElse: () => PrediccionMensual(mes: mesActual.toDouble(), consumo: 0, minimo: 0, maximo: 0),
      );

      final bool dentroDelRango = consumoOperativo >= prediccionMes.minimo && consumoOperativo <= prediccionMes.maximo;
      final bool estaObservado = !dentroDelRango;
      final int consumoFinal = consumoOperativo.round();

      _mostrarConfirmacion(context, consumoFinal, codSocio, socio.numeroSerie, estaObservado);
    } catch (e) {
      _mostrarMensaje(context, "❌ Error validando el consumo: $e");
    }
  }

  static void _mostrarConfirmacion(BuildContext context, int consumo, int codSocio, int numeroSerieCorrecto, bool estaObservado) {
    final mensaje = estaObservado
        ? "⚠️ El consumo está fuera del rango predicho.\nConsumo extraído: $consumo m³\n¿Deseas confirmarlo de todos modos?"
        : "El consumo extraído del medidor es: $consumo m³\n¿Es correcto?";

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(estaObservado ? "Consumo fuera del rango" : "Confirmar Consumo"),
        content: Text(mensaje),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => SubirConsumoScreen(
                    consumo: consumo,
                    codSocio: codSocio,
                    numeroSerieCorrecto: numeroSerieCorrecto.toString(),
                    estaObservado: estaObservado,
                  ),
                ),
              );
            },
            child: const Text("Sí, confirmar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => SubirImagenScreen(codSocio: codSocio)));
            },
            child: const Text("No, subir otra imagen"),
          ),
        ],
      ),
    );
  }

  static void _mostrarMensaje(BuildContext context, String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(mensaje)));
  }
}

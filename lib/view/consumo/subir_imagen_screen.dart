import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'extraer_dato.dart';

class SubirImagenScreen extends StatefulWidget {
  final int codSocio;

  const SubirImagenScreen({super.key, required this.codSocio});

  @override
  State<SubirImagenScreen> createState() => _SubirImagenScreenState();
}

class _SubirImagenScreenState extends State<SubirImagenScreen> {
  File? _imagenSeleccionada;
  bool _isProcessing = false;
  String? _resultadoValidacion;

  final String apiKey = "AIzaSyCqKfGKBbLopRLL7rsatJ3W23eNUmwzE4I";
  final String apiUrl = "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=";

  @override
  void initState() {
    super.initState();
  }

  Future<void> _seleccionarImagen() async {
    final ImagePicker picker = ImagePicker();
    final XFile? imagen = await picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() {
        _imagenSeleccionada = File(imagen.path);
      });
      await _validarImagen();
    }
  }

  Future<void> _validarImagen() async {
    if (_imagenSeleccionada == null || _isProcessing) return;

    setState(() {
      _isProcessing = true;
      _resultadoValidacion = "Validando imagen...";
    });

    try {
      final bytes = await _imagenSeleccionada!.readAsBytes();
      String base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse("$apiUrl$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}},
                {"text": "¿Esta imagen muestra un medidor de agua? Responde solo con 'Sí' o 'No'."}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String respuestaModelo = jsonResponse["candidates"][0]["content"]["parts"][0]["text"].toLowerCase();

        if (respuestaModelo.contains("sí")) {
          await _guardarImagen();
          setState(() {
            _resultadoValidacion = "✅ Medidor detectado y guardado!";
          });
          await _procesarConsumo();
        } else {
          setState(() {
            _resultadoValidacion = "❌ No es un medidor. Selecciona otra imagen.";
          });
        }
      } else {
        setState(() {
          _resultadoValidacion = "⚠️ Error en la validación. Intenta más tarde.";
        });
      }
    } catch (e) {
      setState(() {
        _resultadoValidacion = "🚨 Error al conectar con la API.";
      });
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _guardarImagen() async {
    if (_imagenSeleccionada == null) return;

    final directory = await getApplicationDocumentsDirectory();
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String newPath = "${directory.path}/medidor_$timestamp.jpg";
    await File(_imagenSeleccionada!.path).copy(newPath);
  }

  Future<void> _procesarConsumo() async {
    if (_imagenSeleccionada == null) return;
    await ExtraerDato.extraerConsumo(context, widget.codSocio);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Seleccionar Imagen"), backgroundColor: Colors.blue),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _imagenSeleccionada != null
              ? Image.file(_imagenSeleccionada!, height: 300)
              : const Icon(Icons.image, size: 100, color: Colors.grey),
          const SizedBox(height: 20),
          if (_imagenSeleccionada == null)
            ElevatedButton.icon(
              onPressed: _seleccionarImagen,
              icon: const Icon(Icons.image),
              label: const Text("Abrir Galería"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: const Color.fromARGB(255, 0, 0, 0),
              ),
            ),
          if (_imagenSeleccionada != null) ...[
            const SizedBox(height: 10),
            if (_isProcessing)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  Text(
                    _resultadoValidacion ?? "",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: _resultadoValidacion?.contains("✅") ?? false ? Colors.green : Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                ],
              ),
          ],
        ],
      ),
    );
  }
}
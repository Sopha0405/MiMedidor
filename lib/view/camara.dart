import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CamaraScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const CamaraScreen({super.key, required this.cameras});

  @override
  _CamaraScreenState createState() => _CamaraScreenState();
}

class _CamaraScreenState extends State<CamaraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  String? _imagePath;
  bool _isProcessing = false;
  String? _resultadoValidacion;

  final String apiKey = "AIzaSyCqKfGKBbLopRLL7rsatJ3W23eNUmwzE4I";
  final String apiUrl =
      "https://generativelanguage.googleapis.com/v1/models/gemini-1.5-flash:generateContent?key=";

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _tomarFoto() async {
    if (_isProcessing) return;
    setState(() {
      _isProcessing = true;
      _resultadoValidacion = null;
    });

    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      setState(() {
        _imagePath = image.path;
      });
    } catch (e) {
      debugPrint("Error al tomar la foto: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // 📤 Enviar imagen a Gemini para validación
  Future<void> _validarMedidor() async {
    if (_imagePath == null || apiKey.isEmpty) return;

    setState(() {
      _isProcessing = true;
      _resultadoValidacion = "Validando...";
    });

    try {
      final file = File(_imagePath!);
      final bytes = await file.readAsBytes();
      String base64Image = base64Encode(bytes);

      // Cuerpo de la solicitud con prompt y datos de la imagen
      final response = await http.post(
        Uri.parse("$apiUrl$apiKey"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"inlineData": {"mimeType": "image/jpeg", "data": base64Image}},
                {
                  "text":
                      "¿Esta imagen muestra un medidor de agua? Responde solo con 'Sí' o 'No'."
                }
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        String respuestaModelo =
            jsonResponse["candidates"][0]["content"]["parts"][0]["text"]
                .toLowerCase();

        if (respuestaModelo.contains("sí")) {
          await _guardarImagen();
          setState(() {
            _resultadoValidacion = "✅ Medidor detectado y guardado!";
          });
        } else {
          setState(() {
            _resultadoValidacion = "❌ No es un medidor. Intenta de nuevo.";
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
      debugPrint("Error en validación: $e");
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  // 💾 Guardar la imagen con fecha y hora
  Future<void> _guardarImagen() async {
    if (_imagePath == null) return;

    final directory = await getApplicationDocumentsDirectory();
    String timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
    String newPath = "${directory.path}/medidor_$timestamp.jpg";

    await File(_imagePath!).copy(newPath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Capturar Medidor")),
      body: Column(
        children: [
          Expanded(
            child: _imagePath == null
                ? FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return CameraPreview(_controller);
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  )
                : Image.file(File(_imagePath!)), // 📷 Previsualizar imagen tomada
          ),
          if (_imagePath == null)
            ElevatedButton.icon(
              onPressed: _tomarFoto,
              icon: const Icon(Icons.camera),
              label: const Text("Tomar Foto"),
            ),
          if (_imagePath != null) ...[
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: _validarMedidor,
              icon: const Icon(Icons.check),
              label: const Text("Validar Imagen"),
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: () => setState(() => _imagePath = null),
              icon: const Icon(Icons.refresh),
              label: const Text("Tomar Otra Foto"),
            ),
          ],
          if (_resultadoValidacion != null) ...[
            const SizedBox(height: 10),
            Text(
              _resultadoValidacion!,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color:
                    _resultadoValidacion!.contains("✅") ? Colors.green : Colors.red,
              ),
            ),
          ],
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

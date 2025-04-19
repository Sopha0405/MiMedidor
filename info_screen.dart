import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  void _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'No se pudo abrir el enlace $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Información"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "¿Cómo consultar deuda en la página web de SAGUAPAC?",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 10),
              const Text(
                "Estimado asociado, para brindarle una óptima atención al cliente, ¡ya tiene disponible nuestro sitio web con servicios en línea!",
              ),
              const SizedBox(height: 10),
              const Text(
                "Para ingresar al sitio web de su cooperativa SAGUAPAC, simplemente busque “saguapac” en el buscador Google y haga click en la primera opción:",
              ),
              GestureDetector(
                onTap: () => _launchURL("https://www.saguapac.com.bo"),
                child: const Text(
                  "https://www.saguapac.com.bo",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 8),
              const Text("o escriba directamente:"),
              GestureDetector(
                onTap: () => _launchURL("http://www.saguapac.com.bo"),
                child: const Text(
                  "www.saguapac.com.bo",
                  style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "En nuestra página web se pueden realizar: servicios, consultas, solicitudes e informarse sobre actividades referentes a la cooperativa.",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

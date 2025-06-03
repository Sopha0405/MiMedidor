import 'package:flutter/material.dart';

class LoadingScreen extends StatelessWidget {
  final String mensaje;

  const LoadingScreen({super.key, required this.mensaje});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade800,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo_mimedidor.png', 
              height: 100,
            ),
            const SizedBox(height: 30),
            Text(
              mensaje.toUpperCase(),
              style: const TextStyle(
                color: Colors.white,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w300,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Cargando.....",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 12,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

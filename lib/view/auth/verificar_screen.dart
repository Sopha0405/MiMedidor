import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import '../../model/auth_model.dart';
import 'nueva_contrasena_screen.dart';

class VerificarScreen extends StatefulWidget {
  final int codSocio;
  const VerificarScreen({super.key, required this.codSocio});

  @override
  State<VerificarScreen> createState() => _VerificarScreenState();
}

class _VerificarScreenState extends State<VerificarScreen> {
  final TextEditingController codigoController = TextEditingController();
  String mensaje = '';

  void verificarCodigo() async {
    final model = AuthModel(codSocio: widget.codSocio);
    final controller = AuthController(model);
    final success = await controller.verificarOtp(codigoController.text.trim());

    if (success) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => NuevaContrasenaScreen(codSocio: widget.codSocio),
        ),
      );
    }
     else {
    setState(() {
      mensaje = "Codigo Incorrecto o vencido";
    });
  }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/Logo.jpg', height: 160),
            const SizedBox(height: 20),
            const Text("Verificación",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Ingrese el código de verificación"),
            const SizedBox(height: 25),
            TextField(
              controller: codigoController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Código',
                prefixIcon: Icon(Icons.lock_clock),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: verificarCodigo,
              child: const Text('Verificar'),
            ),
            Text(mensaje, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            const Text("¿No recibiste el código?"),
            TextButton(onPressed: () {}, child: const Text("Reenviar Código")),
          ],
        ),
      ),
    );
  }
}
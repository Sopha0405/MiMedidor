import 'package:flutter/material.dart';
import '../../model/auth_model.dart';
import '../../controller/auth_controller.dart';
import 'verificar_screen.dart';

class RecuperarScreen extends StatefulWidget {
  const RecuperarScreen({super.key});

  @override
  State<RecuperarScreen> createState() => _RecuperarScreenState();
}

class _RecuperarScreenState extends State<RecuperarScreen> {
  final TextEditingController codController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  String mensaje = '';

void enviarOTP() async {
  final int cod = int.tryParse(codController.text.trim()) ?? 0;
  final String telefonoLimpio = telefonoController.text.trim().replaceAll(RegExp(r'\D'), '');

  final model = AuthModel(codSocio: cod, telefono: telefonoLimpio);
  final controller = AuthController(model);
  final success = await controller.enviarOtp();

  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => VerificarScreen(codSocio: cod),
      ),
    );
  }
   else {
    setState(() {
      mensaje = "Datos Incorrectos";
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
            Image.asset('assets/Logo.png', height: 160),
            const SizedBox(height: 20),
            const Text("Olvidé mi contraseña",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            const Text("Confirma el número de teléfono que proporcionaste como socio"),
            const SizedBox(height: 25),
            TextField(
              controller: codController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Código Asociado',
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: telefonoController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Teléfono',
                prefixIcon: Icon(Icons.phone_android_outlined),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: enviarOTP,
              child: const Text('Enviar'),
            ),
            Text(mensaje, style: const TextStyle(color: Colors.red)),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('← Volver atrás'),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../controller/auth_controller.dart';
import '../../model/auth_model.dart';
import 'login_screen.dart';

class NuevaContrasenaScreen extends StatefulWidget {
  final int codSocio;
  const NuevaContrasenaScreen({super.key, required this.codSocio});

  @override
  State<NuevaContrasenaScreen> createState() => _NuevaContrasenaScreenState();
}

class _NuevaContrasenaScreenState extends State<NuevaContrasenaScreen> {
  final TextEditingController nuevaController = TextEditingController();
  final TextEditingController confirmarController = TextEditingController();
  bool mostrarNueva = false;
  bool mostrarConfirmar = false;
  String mensaje = '';

  bool validarContrasena(String contrasena) {
    final regex = RegExp(r'^(?=.*[A-Z])(?=.*[0-9])(?=.*[!@#\$%^&*(),.?":{}|<>]).{8,}$');
    return regex.hasMatch(contrasena);
  }

  void cambiar() async {
    final nueva = nuevaController.text.trim();
    final confirmar = confirmarController.text.trim();

    if (nueva != confirmar) {
      setState(() => mensaje = 'Las contraseñas no coinciden');
      return;
    }

    if (!validarContrasena(nueva)) {
      setState(() => mensaje =
          'La contraseña debe tener al menos 8 caracteres,\nuna mayúscula, un número y un carácter especial');
      return;
    }

    final model = AuthModel(
      codSocio: widget.codSocio,
      contrasena: nueva,
    );
    final controller = AuthController(model);
    final success = await controller.cambiarContrasena(nueva);

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
     else {
    setState(() {
      mensaje = "Error al actualizar contraseña";
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
            const Text(
              "Nueva contraseña",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 25),
            TextField(
              controller: nuevaController,
              obscureText: !mostrarNueva,
              decoration: InputDecoration(
                labelText: 'Contraseña nueva',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      mostrarNueva ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      mostrarNueva = !mostrarNueva;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmarController,
              obscureText: !mostrarConfirmar,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      mostrarConfirmar ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      mostrarConfirmar = !mostrarConfirmar;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: cambiar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: const Text('Cambiar'),
            ),
            const SizedBox(height: 10),
            Text(
              mensaje,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

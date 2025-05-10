import 'package:flutter/material.dart';
import '../../model/auth_model.dart';
import '../../controller/auth_controller.dart';
import 'login_screen.dart';

class ActivarCuentaScreen extends StatefulWidget {
  const ActivarCuentaScreen({super.key});

  @override
  State<ActivarCuentaScreen> createState() => _ActivarCuentaScreenState();
}

class _ActivarCuentaScreenState extends State<ActivarCuentaScreen> {
  final TextEditingController codController = TextEditingController();
  final TextEditingController telefonoController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController confirmPassController = TextEditingController();

  bool aceptaTerminos = false;
  bool mostrarPass = false;
  bool mostrarConfirm = false;
  String mensaje = '';

  bool validarContrasena(String contrasena) {
  final hasUppercase = contrasena.contains(RegExp(r'[A-Z]'));
  final hasDigits = contrasena.contains(RegExp(r'[0-9]'));
  final hasSpecial = contrasena.contains(RegExp(r'[!@#\$%^&*(),.?\":{}|<>]'));
  final hasMinLength = contrasena.length >= 8;

  return hasUppercase && hasDigits && hasSpecial && hasMinLength;
}

  void activarCuenta() async {
    final int cod = int.tryParse(codController.text) ?? 0;
    final String telefono = telefonoController.text.trim();
    final String pass = passController.text.trim();
    final String confirm = confirmPassController.text.trim();

    if (!aceptaTerminos) {
      setState(() => mensaje = 'Debes aceptar los términos');
      return;
    }

    if (pass != confirm) {
      setState(() => mensaje = 'Las contraseñas no coinciden');
      return;
    }

    if (!validarContrasena(pass)) {
      setState(() => mensaje =
          'La contraseña debe tener al menos 8 caracteres, una mayúscula, un número y un carácter especial');
      return;
    }

    final model = AuthModel(codSocio: cod, telefono: telefono, contrasena: pass);
    final controller = AuthController(model);
    final success = await controller.activarCuenta();
    
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
     else {
    setState(() {
      mensaje = "Su usuario o contraseña son incorrectos";
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
              "Activar cuenta",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
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
            const SizedBox(height: 15),
            TextField(
              controller: passController,
              obscureText: !mostrarPass,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                      mostrarPass ? Icons.visibility : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      mostrarPass = !mostrarPass;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: confirmPassController,
              obscureText: !mostrarConfirm,
              decoration: InputDecoration(
                labelText: 'Confirmar Contraseña',
                prefixIcon: const Icon(Icons.lock),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(mostrarConfirm
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(() {
                      mostrarConfirm = !mostrarConfirm;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                Checkbox(
                  value: aceptaTerminos,
                  onChanged: (value) {
                    setState(() {
                      aceptaTerminos = value ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "Acepto los Términos & Condiciones y la Política de Privacidad.",
                  ),
                )
              ],
            ),
            ElevatedButton(
              onPressed: activarCuenta,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
              ),
              child: const Text('Activar Cuenta'),
            ),
            const SizedBox(height: 10),
            Text(
              mensaje,
              style: const TextStyle(color: Colors.red),
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              child: const Text('¿Ya tienes una cuenta? Iniciar sesión'),
            ),
          ],
        ),
      ),
    );
  }
}
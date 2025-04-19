import 'package:flutter/material.dart';
import '../../model/auth_model.dart';
import '../../controller/auth_controller.dart';
import '../home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController codController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  bool mostrarPassword = false;
  String mensaje = '';

  void iniciarSesion() async {
    final int cod = int.tryParse(codController.text) ?? 0;
    final model = AuthModel(codSocio: cod, contrasena: passController.text);
    final controller = AuthController(model);
    final success = await controller.login();

    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => HomeScreen(codSocio: cod),
        ),
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 40),
            Image.asset('assets/Logo.jpg', height: 200),
            const SizedBox(height: 20),
            const Text(
              "Bienvenido",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
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
              controller: passController,
              obscureText: !mostrarPassword,
              decoration: InputDecoration(
                labelText: 'Contraseña',
                prefixIcon: const Icon(Icons.lock_outline),
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(
                    mostrarPassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: () {
                    setState(() {
                      mostrarPassword = !mostrarPassword;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 25),
            ElevatedButton(
              onPressed: iniciarSesion,
              style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, 
                    foregroundColor: Colors.white, 
                    padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: const Text('Iniciar Sesión'),
            ),
            const SizedBox(height: 15),
            Text(
              mensaje,
              style: const TextStyle(color: Color.fromARGB(255, 164, 13, 2)),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 15),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/recuperar');
              },
              child: const Text('¿Haz olvidado tu contraseña?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/activar');
              },
              child: const Text.rich(
                TextSpan(
                  text: '¿No estás registrado? ',
                  children: [
                    TextSpan(
                      text: 'Activa tu cuenta',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

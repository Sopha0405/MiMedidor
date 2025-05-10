import 'package:flutter/material.dart';
import 'configuracion/info_screen.dart';
import 'configuracion/contacto_screen.dart';
import 'auth/recuperar_screen.dart';
import 'auth/login_screen.dart';

class ConfiguracionScreen extends StatelessWidget {
  final int codSocio;

  const ConfiguracionScreen({super.key, required this.codSocio});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 50), 
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Configuración",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            const Text("Account Details",
                style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 25),
            _buildConfigOption(
              context,
              Icons.info_outline,
              "Información al socio",
              const InfoScreen(),
            ),
            _buildConfigOption(
              context,
              Icons.lock_outline,
              "Cambiar contraseña",
              const RecuperarScreen(),
            ),
            _buildConfigOption(
              context,
              Icons.mail_outline,
              "Contáctanos",
              const ContactoScreen(),
            ),
            _buildConfigOption(
              context,
              Icons.logout,
              "Cerrar Sesión",
              const LoginScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfigOption(
      BuildContext context, IconData icon, String title, Widget destination) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12), 
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(1, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8), 
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFDDEEFF),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 22,
            color: Colors.blue,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios,
            color: Colors.grey, size: 16),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => destination),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

class ConfiguracionScreen extends StatelessWidget {
  final int codSocio;

  const ConfiguracionScreen({super.key, required this.codSocio});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text("Configuración", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          const Text("Account Details", style: TextStyle(fontSize: 14, color: Colors.grey)),
          const SizedBox(height: 20),
          _buildConfigOption(Icons.info, "Información al socio"),
          _buildConfigOption(Icons.lock, "Cambiar contraseña"),
          _buildConfigOption(Icons.mail, "Contactanos"),
          _buildConfigOption(Icons.exit_to_app, "Cerrar Sesión"),
        ],
      ),
    );
  }

  Widget _buildConfigOption(IconData icon, String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      color: Colors.white,
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title, style: const TextStyle(fontSize: 16)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {
        },
      ),
    );
  }
}

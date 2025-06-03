import 'package:flutter/material.dart';

void mostrarAlerta(BuildContext context, String titulo, String mensaje, String btnTexto, Function onAceptar) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (_) => AlertDialog(
      title: Column(
        children: [
          const Icon(Icons.cancel, color: Colors.red, size: 50),
          const SizedBox(height: 10),
          Text(titulo, textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
      content: Text(mensaje, textAlign: TextAlign.center),
      actions: [
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
                  foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            onPressed: () => onAceptar(),
            child: Text(btnTexto),
          ),
        )
      ],
    ),
  );
}

void mostrarSelectorFuente(BuildContext context, Function onCamara, Function onGaleria) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: const Text("Selecciona una opción"),
      content: const Text("¿Desde dónde quieres subir la imagen?"),
      actions: [
        TextButton.icon(
          icon: const Icon(Icons.camera_alt),
          label: const Text("Cámara"),
          onPressed: () {
            Navigator.pop(context);
            onCamara();
          },
        ),
        TextButton.icon(
          icon: const Icon(Icons.image),
          label: const Text("Galería"),
          onPressed: () {
            Navigator.pop(context);
            onGaleria();
          },
        ),
      ],
    ),
  );
}

void mostrarNotificacionEmergente(BuildContext context, String titulo, String mensaje) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text("$titulo\n$mensaje"),
    backgroundColor: Colors.orangeAccent,
    duration: const Duration(seconds: 5),
  ));
}

import 'package:flutter/material.dart';
import '../../controller/consumo_controller.dart';
import '../../model/consumo_model.dart';
import '../../controller/cupon_controller.dart';
import 'ganaste_cupon.dart';
import '../../components/loading_screen.dart'; 

class SubirConsumoScreen extends StatefulWidget {
  final int consumo;
  final int codSocio;
  final String numeroSerieCorrecto;
  final bool estaObservado;

  const SubirConsumoScreen({
    super.key,
    required this.consumo,
    required this.codSocio,
    required this.numeroSerieCorrecto,
    this.estaObservado = false,
  });

  @override
  State<SubirConsumoScreen> createState() => _SubirConsumoScreenState();
}

class _SubirConsumoScreenState extends State<SubirConsumoScreen> {
  final TextEditingController _serieController = TextEditingController();
  final ConsumoController _controller = ConsumoController();
  final CuponController cuponController = CuponController();

  Future<void> _crearCuponAleatorio() async {
    final creado = await cuponController.crearCuponAleatorio(widget.codSocio);
    if (creado) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("🎁 Cupón creado correctamente")),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Error al crear el cupón")),
      );
    }
  }

  Future<void> _procesarSubida() async {
  if (_serieController.text.trim().isEmpty || int.tryParse(_serieController.text.trim()) == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("⚠️ Ingresa un número de serie válido.")),
    );
    return;
  }
      Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const LoadingScreen(mensaje: "Registrando consumo"),
      ),
    );


    final numeroSerieIngresado = int.parse(_serieController.text.trim());
    final numeroSerieCorrecto = int.parse(widget.numeroSerieCorrecto);
    final consumoInt = widget.consumo;
    final now = DateTime.now();
    final fecha = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final consumoModel = ConsumoModel(
      idMedidor: 0,
      imagenMedidor: "imagen_medidor_base64_simulada",
      fecha: fecha,
      consumo: consumoInt,
      monto: consumoInt * 2.5,
      observaciones: widget.estaObservado ? 'Observado' : null,
    );

    final exito = await _controller.subirConsumo(
      codSocio: widget.codSocio,
      numeroSerieIngresado: numeroSerieIngresado,
      numeroSerieCorrecto: numeroSerieCorrecto,
      consumoModel: consumoModel,
    );

if (exito) {
  await _crearCuponAleatorio();

  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (_) => GanasteCuponScreen(codSocio: widget.codSocio),
    ),
  );
} else {
  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(content: Text("❌ Error: Número de serie incorrecto.")),
  );
}

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Verificar Medidor")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Ingrese el número de serie del medidor"),
            TextField(
              controller: _serieController,
              decoration: const InputDecoration(labelText: "Número de Serie"),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _procesarSubida,
              child: const Text("Confirmar Consumo"),
            ),
          ],
        ),
      ),
    );
  }
}

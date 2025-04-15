import 'package:flutter/material.dart';

class DetalleCuponScreen extends StatelessWidget {
  final int monto;
  final String registro;
  final String codigo;
  final String fechaEmision;
  final String fechaVencimiento;
  final String descripcion;

  const DetalleCuponScreen({
    super.key,
    required this.monto,
    required this.registro,
    required this.codigo,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.descripcion,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(registro),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.water_drop, color: Colors.blue, size: 32),
                  const SizedBox(width: 8),
                  const Text(
                    'SAGUAPAC',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                descripcion,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Descuento de $monto bs al consumo',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),

              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  '• Válido solo para el consumo de febrero mayor a 50 Bs\n'
                  '• Si no registra consumo pierde el cupón\n'
                  '• No acumulativo\n'
                  '• No canjeable por efectivo',
                  style: TextStyle(fontSize: 15, height: 1.6),
                ),
              ),

              const SizedBox(height: 30),
              Divider(thickness: 1.5, color: Colors.grey[300]),
              const SizedBox(height: 20),

              Text(
                codigo,
                style: const TextStyle(fontSize: 22, letterSpacing: 2, fontWeight: FontWeight.bold),
              ),
              const Text("Código del cupón", style: TextStyle(fontSize: 14)),

              const SizedBox(height: 20),

              Text("Emitido: $fechaEmision", style: const TextStyle(fontSize: 14)),
              Text("Válido hasta: $fechaVencimiento", style: const TextStyle(fontSize: 14)),

              const SizedBox(height: 20),

              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.open_in_new),
                  Icon(Icons.info_outline),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

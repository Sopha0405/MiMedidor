import 'package:flutter/material.dart';
import 'detalle_cupon_screen.dart';
import '../controller/cupon_controller.dart';
import '../model/cupon_model.dart';

class CuponesScreen extends StatefulWidget {
  final int codSocio;
  const CuponesScreen({super.key, required this.codSocio});

  @override
  State<CuponesScreen> createState() => _CuponesScreenState();
}

class _CuponesScreenState extends State<CuponesScreen> {
  final CuponController cuponController = CuponController();
  late Future<List<Cupon>> _cuponesFuturos;

  @override
  void initState() {
    super.initState();
    _cuponesFuturos = cuponController.obtenerCupones(widget.codSocio);
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10), 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          const Text("Cupones", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),

          FutureBuilder<List<Cupon>>(
            future: _cuponesFuturos,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Text("Error: ${snapshot.error}");
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Text("No tienes cupones activos.");
              } else {
                return Column(
                  children: snapshot.data!.map((cupon) => _buildCupon(context, cupon)).toList(),
                );
              }
            },
          ),
        ],
      ),
    );
  }

Widget _buildCupon(BuildContext context, Cupon cupon) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DetalleCuponScreen(
            monto: cupon.monto,
            descripcion: cupon.descripcion,
            registro: cupon.fechaEmision,
            codigo: cupon.codigo,
            fechaEmision: cupon.fechaEmision,
            fechaVencimiento: cupon.fechaVencimiento,
          ),
        ),
      );
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.blueAccent.withOpacity(0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Center(
                child: Icon(Icons.card_giftcard, size: 30, color: Colors.blueAccent),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cupon.descripcion,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 0, 0, 0), 
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Emitido: ${cupon.fechaEmision}",
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    "Vence: ${cupon.fechaVencimiento}",
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
          ],
        ),
      ),
    ),
  );
}
}
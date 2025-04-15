import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'camara.dart';
import 'subir_imagen_screen.dart';
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

  void _abrirCamara(BuildContext context) async {
    final cameras = await availableCameras();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CamaraScreen(cameras: cameras),
      ),
    );
  }

  void _abrirGaleria(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubirImagenScreen(codSocio: widget.codSocio),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
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

          const SizedBox(height: 20),

          Center(
            child: ElevatedButton.icon(
              onPressed: () => _abrirCamara(context),
              icon: const Icon(Icons.camera_alt),
              label: const Text("Abrir Cámara"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ),

          const SizedBox(height: 10),

          Center(
            child: ElevatedButton.icon(
              onPressed: () => _abrirGaleria(context),
              icon: const Icon(Icons.image),
              label: const Text("Seleccionar Imagen"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 6,
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 90,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.blueAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: const Center(
                  child: Icon(Icons.card_giftcard, size: 50, color: Colors.blueAccent),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cupon.descripcion,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color.fromARGB(255, 25, 3, 73)),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Emitido: ${cupon.fechaEmision}",
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      "Vence: ${cupon.fechaVencimiento}",
                      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18),
            ],
          ),
        ),
      ),
    );
  }


}
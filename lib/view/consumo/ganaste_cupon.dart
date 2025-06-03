import 'package:flutter/material.dart';
import '../../model/cupon_model.dart';
import '../../controller/cupon_controller.dart';
import '../home_screen.dart';
import 'package:audioplayers/audioplayers.dart';

class GanasteCuponScreen extends StatefulWidget {
  final int codSocio;

  const GanasteCuponScreen({super.key, required this.codSocio});

  @override
  State<GanasteCuponScreen> createState() => _GanasteCuponScreenState();
}

class _GanasteCuponScreenState extends State<GanasteCuponScreen> {
  Cupon? cupon;
  bool cargando = true;
  final AudioPlayer _player = AudioPlayer();

  @override
  void initState() {
    super.initState();
    _reproducirSonido();
    _cargarUltimoCupon();
  }

  Future<void> _reproducirSonido() async {
    await _player.play(AssetSource('audio/coin.mp3'));
  }

  Future<void> _cargarUltimoCupon() async {
    final controller = CuponController();
    final cup = await controller.obtenerUltimoCupon(widget.codSocio);

    setState(() {
      cupon = cup;
      cargando = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: const Color(0xFFE0F2F1),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF0288D1),
          elevation: 0,
          title: const Text(
            '¡Ganaste un Cupón!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          centerTitle: true,
        ),
        body: cargando
            ? const Center(child: CircularProgressIndicator())
            : cupon == null
                ? const Center(child: Text("No se pudo cargar el cupón."))
                : Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo_mimedidor.png',
                          height: 80,
                        ),
                        const SizedBox(height: 24),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Text(
                                '¡DESCUENTO DE CUPÓN!',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.redAccent,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                "${cupon!.monto} Bs",
                                style: const TextStyle(
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                "Código: ${cupon!.codigo}",
                                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                cupon!.descripcion,
                                style: const TextStyle(fontSize: 14),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                "Válido hasta: ${cupon!.fechaVencimiento}",
                                style: const TextStyle(fontSize: 14, color: Colors.black54),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0288D1),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 5,
                          ),
                          onPressed: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen(codSocio: widget.codSocio)),
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: const Text(
                            'Ir al inicio',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'estadisticas.dart';
import 'cupones.dart';
import 'configuracion.dart';
import '../components/navbar.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import '../controller/socio_controller.dart';
import '../model/socio_model.dart';
import '../model/prediccion_mensual_model.dart';
import '../controller/prediccion_controller.dart';


class HomeScreen extends StatefulWidget {
  final int codSocio;

  const HomeScreen({super.key, required this.codSocio});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<Socio> _futureSocio;
  String fechaActual = "";
  
  @override
  void initState() {
    super.initState();
    _futureSocio = SocioController(codSocio: widget.codSocio).fetchSocioData();

    initializeDateFormatting('es_ES', null).then((_) {
      setState(() {
        fechaActual = DateFormat("EEEE d 'de' MMMM, yyyy", 'es_ES').format(DateTime.now());
      });
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<Socio>(
        future: _futureSocio,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null || snapshot.data!.nombre == "Usuario no encontrado") {
            return _errorWidget();
          }

          Socio socio = snapshot.data!;
          final List<Widget> _screens = [
            HomePage(socio: socio, fechaActual: fechaActual),
            EstadisticasScreen(codSocio: widget.codSocio),
            CuponesScreen(codSocio: widget.codSocio),
            ConfiguracionScreen(codSocio: widget.codSocio),
          ];

          return _screens[_selectedIndex];
        },
      ),
      bottomNavigationBar: Navbar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }

  Widget _errorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("❌ Error al cargar los datos del socio"),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _futureSocio = SocioController(codSocio: widget.codSocio).fetchSocioData();
              });
            },
            child: const Text("Reintentar"),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final Socio socio;
  final String fechaActual;

  HomePage({super.key, required this.socio, required this.fechaActual});

  final List<FlSpot> consumoData = const [
    FlSpot(0, 12),
    FlSpot(1, 15),
    FlSpot(2, 10),
    FlSpot(3, 8),
    FlSpot(4, 14),
    FlSpot(5, 13),
  ];

  final List<String> meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun"];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Text(
            "Bienvenido ${socio.nombre} ${socio.aPaterno} ${socio.aMaterno}",
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          Text(fechaActual, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 20),
          _buildConsumptionCard("${socio.consumoTotal} m³", "Consumo Total", Icons.opacity, Colors.blue),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildInfoCard("Importe actual", "${socio.montoActual.toStringAsFixed(1)} Bs", Icons.attach_money)),
              const SizedBox(width: 10),
              Expanded(child: _buildInfoCard("Consumo Actual", "${socio.consumoActual} m³", Icons.water_drop)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildInfoCard("Importe Anterior", "${socio.montoAnterior} Bs", Icons.attach_money)),
              const SizedBox(width: 10),
              Expanded(child: _buildInfoCard("Consumo Anterior", "${socio.consumoAnterior} m³", Icons.water_drop)),
            ],
          ),
          const SizedBox(height: 20),
          _buildChart(socio.codSocio),
        ],
      ),
    );
  }

  Widget _buildConsumptionCard(String value, String title, IconData icon, Color color) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 40),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text(title, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 30, color: Colors.blueAccent),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(title, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
Widget _buildChart(int cod_socio) {
  final controller = PrediccionController(codSocio: cod_socio);

  return FutureBuilder<List<PrediccionMensual>>(
    future: controller.fetchPredicciones(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      } else if (snapshot.hasError) {
        return Center(child: Text('Error al cargar predicción: ${snapshot.error}'));
      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return const Center(child: Text('No hay datos de predicción disponibles'));
      }

      final data = snapshot.data!;
      final consumoSpots = data.map((e) => FlSpot(e.mes, e.consumo)).toList();

      return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Predicción de consumo de agua (m³)",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              SizedBox(
                height: 240,
                child: LineChart(
                  LineChartData(
                    minY: 15, 
                    maxY: data.map((e) => e.maximo).reduce((a, b) => a > b ? a : b),
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchTooltipData: LineTouchTooltipData(
                        tooltipBgColor: Colors.blueAccent.withOpacity(0.7),
                        getTooltipItems: (touchedSpots) {
                          return touchedSpots.map((spot) {
                            return LineTooltipItem(
                              "${spot.y.toStringAsFixed(2)} m³",
                              const TextStyle(color: Colors.white),
                            );
                          }).toList();
                        },
                      ),
                    ),
                    gridData: FlGridData(show: true),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 5,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) =>
                              Text(value.toInt().toString(), style: const TextStyle(fontSize: 12)),
                        ),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 1,
                          reservedSize: 30,
                          getTitlesWidget: (value, meta) {
                            const meses = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
                            if (value >= 1 && value <= 12) {
                              return SideTitleWidget(
                                axisSide: meta.axisSide,
                                child: Text(meses[value.toInt() - 1], style: const TextStyle(fontSize: 12)),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border.all(color: Colors.grey.withOpacity(0.3)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: consumoSpots,
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        isStrokeCapRound: true,
                        belowBarData: BarAreaData(
                          show: true,
                          color: Colors.blue.withOpacity(0.3),
                        ),
                        dotData: FlDotData(show: true),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}
}
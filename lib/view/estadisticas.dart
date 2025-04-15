import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class EstadisticasScreen extends StatefulWidget {
  final int codSocio;

  const EstadisticasScreen({super.key, required this.codSocio});

  @override
  _EstadisticasScreenState createState() => _EstadisticasScreenState();
}

class _EstadisticasScreenState extends State<EstadisticasScreen> {
  int selectedYear = DateTime.now().year;
  int currentYear = DateTime.now().year;
  List<FlSpot> lineSpots = [];
  List<PieChartSectionData> pieSections = [];
  List<Map<String, dynamic>> topConsumption = [];
  bool isLoading = true;
  double totalConsumo = 0.0;

  @override
  void initState() {
    super.initState();
    fetchConsumptionData();
  }

  Future<void> fetchConsumptionData() async {
    try {
      final response = await http.get(
        Uri.parse('http://192.168.13.66/mimedidor_api/get_consumo.php?cod_socio=${widget.codSocio}&year=$selectedYear'),
      );

      final responseTrimestral = await http.get(
        Uri.parse('http://192.168.13.66/mimedidor_api/get_consumo.php?cod_socio=${widget.codSocio}&year=$currentYear'),
      );

      if (response.statusCode == 200 && responseTrimestral.statusCode == 200) {
        final data = json.decode(response.body);
        final dataTrimestral = json.decode(responseTrimestral.body);
        if (data != null && dataTrimestral != null && mounted) {
          setState(() {
            lineSpots = data['historial'] != null
                ? List<FlSpot>.from(
                    data['historial'].map(
                      (item) => FlSpot(
                        (data['historial'].indexOf(item) + 1).toDouble(),
                        (item['consumo'] as num).toDouble(),
                      ),
                    ),
                  )
                : [];

            totalConsumo = data['historial'] != null
                ? data['historial'].fold(0.0, (sum, item) => sum + (item['consumo'] as num).toDouble())
                : 0.0;

            pieSections = dataTrimestral['trimestral'] != null
                ? List<PieChartSectionData>.from(
                    dataTrimestral['trimestral'].map(
                      (item) => PieChartSectionData(
                        value: (item['consumo'] ?? 0).toDouble(),
                        color: Color(int.parse(item['color'])),
                        title: item['mes'],
                        radius: 50,
                      ),
                    ),
                  )
                : [];

            topConsumption = data['top'] != null
                ? List<Map<String, dynamic>>.from(data['top'])
                : [];
            
            isLoading = false;
          });
        }
      }
    } catch (e) {
      print("Error al obtener datos: $e");
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              "Panel de Estadísticas",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            isLoading
                ? const CircularProgressIndicator()
                : Column(
                    children: [
                      _buildCircularChart(),
                      const SizedBox(height: 20),
                      _buildYearSelector(),
                      const SizedBox(height: 20),
                      _buildLineChart(),
                      const SizedBox(height: 20),
                      _buildTopConsumption(),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    int currentYear = DateTime.now().year;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int year = currentYear - 3; year <= currentYear; year++)
          GestureDetector(
            onTap: () {
              setState(() {
                selectedYear = year;
                fetchConsumptionData();
              });
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Text(
                    year.toString(),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: year == selectedYear ? FontWeight.bold : FontWeight.normal,
                      color: year == selectedYear ? Colors.blue : Colors.black,
                    ),
                  ),
                  if (year == selectedYear)
                    Container(
                      width: 30,
                      height: 2,
                      color: Colors.blue,
                    ),
                ],
              ),
            ),
          ),
      ],
    );
  }

Widget _buildLineChart() {
  return Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 5,
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "Historial de Consumo - $selectedYear", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            "Total: ${totalConsumo.toInt()} m³", 
            style: const TextStyle(fontSize: 16, color: Colors.blue, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: true, reservedSize: 40),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      interval: 1,
                      getTitlesWidget: (value, meta) {
                        const months = ["Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"];
                        if (value.toInt() >= 1 && value.toInt() <= 12) {
                          return SideTitleWidget(
                            axisSide: meta.axisSide,
                            child: Text(months[value.toInt() - 1], style: const TextStyle(fontSize: 12)),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: lineSpots,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 4,
                    isStrokeCapRound: true,
                    belowBarData: BarAreaData(show: true, color: Colors.blue.withAlpha((0.2 * 255).toInt())),
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
}


  Widget _buildCircularChart() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Text("Consumo Trimestral - $currentYear", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 15),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: pieSections,
                  centerSpaceRadius: 40,
                  sectionsSpace: 2,
                  startDegreeOffset: -90,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopConsumption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Meses de más consumo", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: topConsumption.map((item) {
            return Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    Text("${item['consumo']} m³", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    Text(item['mes'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
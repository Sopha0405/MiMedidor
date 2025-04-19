class PrediccionMensual {
  final double mes;
  final double consumo;
  final double minimo;
  final double maximo;

  PrediccionMensual({
    required this.mes,
    required this.consumo,
    required this.minimo,
    required this.maximo,
  });

  factory PrediccionMensual.fromJson(Map<String, dynamic> json) {
    return PrediccionMensual(
      mes: double.parse(json['mes'].toString()),
      consumo: json['consumo'].toDouble(),
      minimo: json['minimo'].toDouble(),
      maximo: json['maximo'].toDouble(),
    );
  }
}

class ConsumoModel {
  final int idMedidor;
  final String imagenMedidor;
  final String fecha;
  final int consumo;
  final double monto;
  final String? observaciones;

  ConsumoModel({
    required this.idMedidor,
    required this.imagenMedidor,
    required this.fecha,
    required this.consumo,
    required this.monto,
    this.observaciones,
  });

  Map<String, dynamic> toJson() {
    return {
      'id_medidor': idMedidor.toString(),
      'imagen_medidor': imagenMedidor,
      'fecha': fecha,
      'consumo': consumo.toString(),
      'monto': monto.toStringAsFixed(2),
      'observaciones': observaciones ?? '',
    };
  }
}

class Socio {
  final int id;
  final String nombre;
  final String aPaterno;
  final String aMaterno;
  final int codSocio;
  final String telefono;
  final int idMedidor;
  final int numeroSerie;
  final String ubicacion;
  final double consumoTotal;
  final double montoTotal;
  final double consumoActual;
  final double montoActual;
  final double consumoAnterior;
  final double montoAnterior;

  Socio({
    required this.id,
    required this.nombre,
    required this.aPaterno,
    required this.aMaterno,
    required this.codSocio,
    required this.telefono,
    required this.idMedidor,
    required this.numeroSerie,
    required this.ubicacion,
    required this.consumoTotal,
    required this.montoTotal,
    required this.consumoActual,
    required this.montoActual,
    required this.consumoAnterior,
    required this.montoAnterior,
  });

factory Socio.fromJson(Map<String, dynamic> json) {
  return Socio(
    id: json["id_Socio"] != null ? int.tryParse(json["id_Socio"].toString()) ?? 0 : 0,
    nombre: json["nombre"]?.toString() ?? "Usuario no encontrado",
    aPaterno: json["a_paterno"]?.toString() ?? "",
    aMaterno: json["a_materno"]?.toString() ?? "",
    codSocio: json["cod_socio"] != null ? int.tryParse(json["cod_socio"].toString()) ?? 0 : 0,
    telefono: json["telefono"]?.toString() ?? "",
    idMedidor: json["id_medidor"] != null ? int.tryParse(json["id_medidor"].toString()) ?? 0 : 0,
    numeroSerie: json["numero_serie"] != null ? int.tryParse(json["numero_serie"].toString()) ?? 0 : 0,
    ubicacion: json["ubicacion"]?.toString() ?? "No especificado",
    
    consumoTotal: double.tryParse(json["consumo_total"].toString()) ?? 0.0,
    montoTotal: double.tryParse(json["importe_total"].toString()) ?? 0.0,
    consumoActual: double.tryParse(json["consumo_actual"].toString()) ?? 0.0,
    montoActual: double.tryParse(json["importe_actual"].toString()) ?? 0.0,
    consumoAnterior: double.tryParse(json["consumo_anterior"].toString()) ?? 0.0,
    montoAnterior: double.tryParse(json["importe_anterior"].toString()) ?? 0.0,
  );
}

  static Socio empty() {
    return Socio(
      id: 0,
      nombre: "Usuario no encontrado",
      aPaterno: "",
      aMaterno: "",
      codSocio: 0,
      telefono: "",
      idMedidor: 0,
      numeroSerie: 0,
      ubicacion: "No especificado",
      consumoTotal: 0.0,
      montoTotal: 0.0,
      consumoActual: 0.0,
      montoActual: 0.0,
      consumoAnterior: 0.0,
      montoAnterior: 0.0,
    );
  }
}

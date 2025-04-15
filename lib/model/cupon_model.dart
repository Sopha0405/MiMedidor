class Cupon {
  final int idCupon;
  final int idSocio; 
  final String codigo;
  final String descripcion;
  final String fechaEmision;
  final String fechaVencimiento;
  final String estado;
  final int monto;

  Cupon({
    required this.idCupon,
    required this.idSocio,
    required this.codigo,
    required this.descripcion,
    required this.fechaEmision,
    required this.fechaVencimiento,
    required this.estado,
    required this.monto,
  });

  factory Cupon.fromJson(Map<String, dynamic> json) {
    return Cupon(
      idCupon: json["id_cupon"] ?? 0,
      idSocio: json["id_Socio"] ?? 0,
      codigo: json["codigo"],
      descripcion: json["descripcion"],
      fechaEmision: json["fecha_emision"],
      fechaVencimiento: json["fecha_vencimiento"],
      estado: json["estado"],
      monto: json["monto"],
    );
  }

  Map<String, dynamic> toJsonParaInsertar(int codSocio) => {
    "cod_socio": codSocio,
    "codigo": codigo,
    "descripcion": descripcion,
    "fecha_emision": fechaEmision,
    "fecha_vencimiento": fechaVencimiento,
    "estado": estado,
    "monto": monto,
  };
}

class AuthModel {
  final int codSocio;
  final String? telefono;
  final String? contrasena;

  AuthModel({
    required this.codSocio,
    this.telefono,
    this.contrasena,
  });

  Map<String, dynamic> toJson() {
    return {
      'cod_socio': codSocio.toString(),
      'telefono': telefono ?? '',
      'contrasena': contrasena ?? '',
    };
  }
}
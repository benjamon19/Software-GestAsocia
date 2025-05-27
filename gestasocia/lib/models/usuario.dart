import 'package:cloud_firestore/cloud_firestore.dart';

class Usuario {
  final String? id;
  final String nombre;
  final String apellido;
  final String email;
  final String telefono;
  final String rut;
  final String departamento;
  final DateTime fechaCreacion;
  final bool isActive;

  Usuario({
    this.id,
    required this.nombre,
    required this.apellido,
    required this.email,
    required this.telefono,
    required this.rut,
    required this.departamento,
    required this.fechaCreacion,
    this.isActive = true,
  });

  // Convertir Usuario a Map para guardar en Firebase
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'email': email,
      'telefono': telefono,
      'rut': rut,
      'departamento': departamento,
      'fechaCreacion': Timestamp.fromDate(fechaCreacion),
      'isActive': isActive,
    };
  }

  // Crear Usuario desde Map de Firebase
  factory Usuario.fromMap(Map<String, dynamic> map, String id) {
    return Usuario(
      id: id,
      nombre: map['nombre'] ?? '',
      apellido: map['apellido'] ?? '',
      email: map['email'] ?? '',
      telefono: map['telefono'] ?? '',
      rut: map['rut'] ?? '',
      departamento: map['departamento'] ?? '',
      fechaCreacion: (map['fechaCreacion'] as Timestamp).toDate(),
      isActive: map['isActive'] ?? true,
    );
  }

  // Obtener nombre completo
  String get nombreCompleto => '$nombre $apellido';

  // Método para validar RUT chileno
  static bool validarRUT(String rut) {
    rut = rut.replaceAll('.', '').replaceAll('-', '').toLowerCase();
    
    if (rut.length < 8 || rut.length > 9) return false;
    
    String numero = rut.substring(0, rut.length - 1);
    String dv = rut.substring(rut.length - 1);
    
    int suma = 0;
    int multiplicador = 2;
    
    for (int i = numero.length - 1; i >= 0; i--) {
      suma += int.parse(numero[i]) * multiplicador;
      multiplicador = multiplicador == 7 ? 2 : multiplicador + 1;
    }
    
    int resto = suma % 11;
    String dvCalculado = resto == 0 ? '0' : resto == 1 ? 'k' : (11 - resto).toString();
    
    return dv == dvCalculado;
  }
}
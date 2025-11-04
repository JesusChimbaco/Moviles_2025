class UniversidadFb {
  final String id;
  final String nit;
  final String nombre;
  final String direccion;
  final String telefono;
  final String paginaWeb;

  UniversidadFb({
    required this.id,
    required this.nit,
    required this.nombre,
    required this.direccion,
    required this.telefono,
    required this.paginaWeb,
  });

  /// Crea una instancia de Universidad desde un documento de Firestore
  factory UniversidadFb.fromMap(String id, Map<String, dynamic> data) {
    return UniversidadFb(
      id: id,
      nit: data['nit'] ?? '',
      nombre: data['nombre'] ?? '',
      direccion: data['direccion'] ?? '',
      telefono: data['telefono'] ?? '',
      paginaWeb: data['pagina_web'] ?? '',
    );
  }

  /// Convierte la universidad a un Map para guardar en Firestore
  Map<String, dynamic> toMap() {
    return {
      'nit': nit,
      'nombre': nombre,
      'direccion': direccion,
      'telefono': telefono,
      'pagina_web': paginaWeb,
    };
  }

  /// Crea una copia de la universidad con algunos campos modificados
  UniversidadFb copyWith({
    String? id,
    String? nit,
    String? nombre,
    String? direccion,
    String? telefono,
    String? paginaWeb,
  }) {
    return UniversidadFb(
      id: id ?? this.id,
      nit: nit ?? this.nit,
      nombre: nombre ?? this.nombre,
      direccion: direccion ?? this.direccion,
      telefono: telefono ?? this.telefono,
      paginaWeb: paginaWeb ?? this.paginaWeb,
    );
  }

  @override
  String toString() {
    return 'Universidad{id: $id, nit: $nit, nombre: $nombre, direccion: $direccion, telefono: $telefono, paginaWeb: $paginaWeb}';
  }
}

class SalidaDetalle 
{
  final int id;
  final String descripcion;
  final int cantidad;
  final double peso;

  SalidaDetalle({
    required this.id,
    required this.descripcion,
    required this.cantidad,
    required this.peso,
  });

  SalidaDetalle copyWith({
    int? id,
    String? descripcion,
    int? cantidad,
    double? peso,
  }) {
    return SalidaDetalle(
      id: id ?? this.id, 
      descripcion: descripcion ?? this.descripcion, 
      cantidad: cantidad ?? this.cantidad, 
      peso: peso ?? this.peso
    );
  }

}
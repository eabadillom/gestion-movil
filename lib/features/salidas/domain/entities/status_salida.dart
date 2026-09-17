class StatusSalida 
{
  final int id;
  final String descripcion;

  StatusSalida({
    required this.id,
    required this.descripcion,
  });

  StatusSalida copyWith({
    int? id,
    String? descripcion,
  }) {
    return StatusSalida(
      id: id ?? this.id, 
      descripcion: descripcion ?? this.descripcion,
    );
  }
  
}
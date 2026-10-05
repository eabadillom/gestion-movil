class ConstanciaDTO 
{
  final int id;
  final String folioCliente;
  final DateTime fecha;
  final String nombre;

  ConstanciaDTO({
    required this.id,
    required this.folioCliente,
    required this.fecha,
    required this.nombre,
  });
  
  ConstanciaDTO copyWith({
    int? id,
    String? folioCliente,
    DateTime? fecha,
    String? nombre,
  })
   {
    return ConstanciaDTO(
      id: id ?? this.id, 
      folioCliente: folioCliente ?? this.folioCliente, 
      fecha: fecha ?? this.fecha, 
      nombre: nombre ?? this.nombre,
    );
  }
  
}

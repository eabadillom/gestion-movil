class Constancia 
{
  final int id;
  final String? folioCliente;
  final DateTime? fecha;
  final String? nombre;

  Constancia({
    required this.id,
    this.folioCliente,
    this.fecha,
    this.nombre,
  });
  
  Constancia copyWith({
    int? id,
    String? folioCliente,
    DateTime? fecha,
    String? nombre,
  })
   {
    return Constancia(
      id: id ?? this.id, 
      folioCliente: folioCliente ?? this.folioCliente, 
      fecha: fecha ?? this.fecha, 
      nombre: nombre ?? this.nombre,
    );
  }
  
}

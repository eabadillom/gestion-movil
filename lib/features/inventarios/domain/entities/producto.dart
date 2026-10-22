class Producto 
{
  final int id;
  final String? descripcion;
  final String? tarima;
  final int? piezas;
  final String? unidad;
  final double? peso;
  final String? folioEntrada;
  final String? planta;
  final String? camara;
  final String? origen;
  final String? destino;

  const Producto({
    required this.id,
    this.descripcion,
    this.tarima,
    this.piezas,
    this.unidad,
    this.peso,
    this.folioEntrada,
    this.planta,
    this.camara,
    this.origen,
    this.destino,
  });

}

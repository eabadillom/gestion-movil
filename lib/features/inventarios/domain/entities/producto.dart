class Producto 
{
  final int id;
  final String? descripcion;
  final String? tarima;
  final int? piezas;
  final String? unidad;
  final double? cantidadCobro;
  final double? peso;
  final String? folioEntrada;
  final String? camara;
  final String? origen;
  final String? destino;

  const Producto({
    required this.id,
    this.descripcion,
    this.tarima,
    this.piezas,
    this.unidad,
    this.cantidadCobro,
    this.peso,
    this.folioEntrada,
    this.camara,
    this.origen,
    this.destino,
  });

}

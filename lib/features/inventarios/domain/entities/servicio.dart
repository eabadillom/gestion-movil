class Servicio 
{
  final int id;
  final String? descripcion;
  final double? cantidad;
  final double? precio;
  final double? subtotal;

  const Servicio({
    required this.id,
    this.descripcion,
    this.cantidad,
    this.precio,
    this.subtotal,
  });
}

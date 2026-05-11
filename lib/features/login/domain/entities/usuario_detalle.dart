class UsuarioDetalle
{
  final String numeroUsuario;
  final String nombreUsuario;
  final String primerApUsuario;
  final String segundoApUsuario;
  final String puesto;
  final int perfil;

  UsuarioDetalle({
    required this.numeroUsuario,
    required this.nombreUsuario,
    required this.primerApUsuario,
    required this.segundoApUsuario,
    required this.puesto,
    required this.perfil
  });

  @override
  String toString() {
    return 'UsuarioDetalle[NumeroEmpleado: $numeroUsuario, NombreEmpleado: $nombreUsuario, PrimerApeEmpleado: $primerApUsuario, SegundoApeEmpleado: $segundoApUsuario, Puesto: $puesto]';
  }
  
}
class CandadoSalida 
{
  final int id;
  final bool habilitado;
  final int numSalidas;
  final bool salidaTotal;

  CandadoSalida({
    required this.id,
    required this.habilitado,
    required this.numSalidas,
    required this.salidaTotal,
  });

  CandadoSalida copyWith({
    int? id,
    bool? habilitado,
    int? numSalidas,
    bool? salidaTotal,
  }) {
    return CandadoSalida(
      id: id ?? this.id,
      habilitado: habilitado ?? this.habilitado,
      numSalidas: numSalidas ?? this.numSalidas,
      salidaTotal: salidaTotal ?? this.salidaTotal,
    );
  }
  
}

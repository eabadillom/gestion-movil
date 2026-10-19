class MovilResponse {
  final int? codigoError;
  final String? tipoError;
  final String? mensajeError;
  final DateTime? tiempoError;

  MovilResponse({
    this.codigoError,
    this.tipoError,
    this.mensajeError,
    this.tiempoError,
  });

  factory MovilResponse.fromJson(Map<String, dynamic> json) {
    return MovilResponse(
      codigoError: json['codigoError'] as int?,
      tipoError: json['tipoError'] as String?,
      mensajeError: json['mensajeError'] as String?,
      tiempoError: json['tiempoError'] != null
          ? DateTime.parse(json['tiempoError'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'codigoError': codigoError,
      'tipoError': tipoError,
      'mensajeError': mensajeError,
      'tiempoError': tiempoError?.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'MovilResponse['
        'codigoError=$codigoError, '
        'tipoError=$tipoError, '
        'mensajeError=$mensajeError, '
        'tiempoError=$tiempoError'
        ']';
  }
}

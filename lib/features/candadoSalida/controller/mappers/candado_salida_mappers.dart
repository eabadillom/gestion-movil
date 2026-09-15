import 'package:gestion_movil/features/candadoSalida/domain/domain.dart';

class CandadoSalidaMappers 
{
  static CandadoSalida jsonToEntity(Map<String, dynamic> json) => CandadoSalida(
    id: json['id'] as int, 
    habilitado: json['habilitado'] as bool, 
    numSalidas: json['numSalidas'] as int, 
    salidaTotal: json['salidaTotal'] as bool,
  );

  static Map<String, dynamic> toJson(CandadoSalida entity) => {
    "id" : entity.id,
    "habilitado" : entity.habilitado,
    "numSalidas" : entity.numSalidas,
    "salidaTotal" : entity.salidaTotal
  };

}

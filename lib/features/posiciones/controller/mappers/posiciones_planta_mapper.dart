import 'package:gestion_movil/features/posiciones/domain/domain.dart';

class PosicionesPlantaMapper 
{
  static PosicionesPlanta jsonToEntity(Map<String,dynamic> json) => PosicionesPlanta(
    planta: json['planta'],
    camara: json['camara'],
    tarima: json['tarima'] as int,
  );
}
import 'package:gestion_movil/features/camaras/domain/domain.dart';

abstract class CamaraDatasource 
{
  Future<List<Camara>> getListCamaras(int? idPlanta);
}
import 'package:gestion_movil/features/camaras/domain/domain.dart';

abstract class CamaraRepository 
{
  Future<List<Camara>> getListCamaras(int? idPlanta);
}
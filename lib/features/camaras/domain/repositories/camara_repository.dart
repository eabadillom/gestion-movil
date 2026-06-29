import 'package:gestion_movil/conf/config.dart';
import 'package:gestion_movil/features/camaras/domain/domain.dart';

abstract class CamaraRepository 
{
  Future<Results<List<Camara>>> getListCamaras(int? idPlanta);
}
import 'package:gestion_movil/features/camaras/domain/domain.dart';

class CamaraRepositoryImpl extends CamaraRepository
{
  final CamaraDatasource datasource;

  CamaraRepositoryImpl(this.datasource);
  
  @override
  Future<List<Camara>> getListCamaras(int? idPlanta) 
  {
    return datasource.getListCamaras(idPlanta);
  }
  
}

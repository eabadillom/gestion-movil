enum TipoConstancia 
{ 
  deposito, 
  salida, 
  servicio, 
  traspaso, 
}

extension TipoConstanciaApi on TipoConstancia 
{
  String get api => name.toUpperCase();

  String get titulo 
  {
    switch (this) 
    {
      case TipoConstancia.deposito:
        return 'DEPOSITO';
      case TipoConstancia.salida:
        return 'SALIDA';
      case TipoConstancia.servicio:
        return 'SERVICIO';
      case TipoConstancia.traspaso:
        return 'TRASPASO';
    }
  }
}

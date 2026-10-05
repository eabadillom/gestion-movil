class FotosTamanoConfig 
{
  final int limiteBytes;
  final double margen;

  const FotosTamanoConfig({required this.limiteBytes, required this.margen});

  int get limiteSeguroBytes {
    return (limiteBytes * margen).floor();
  }
  
}

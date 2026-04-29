class ConnectionTimeout implements Exception {}

class PosicionesPlantaErrors implements Exception 
{
  final String message;

  // final int errorCode;
  PosicionesPlantaErrors(this.message);
}
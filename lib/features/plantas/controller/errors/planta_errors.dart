class ConnectionTimeout implements Exception {}
class InvalidToken implements Exception {}
class WrongCredentials implements Exception {}

class PlantaErrors implements Exception 
{
  final String message;

  // final int errorCode;
  PlantaErrors(this.message);
}
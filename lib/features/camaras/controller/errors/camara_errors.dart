class ConnectionTimeout implements Exception {}

class CamaraErrors implements Exception 
{
  final String message;

  // final int errorCode;
  CamaraErrors(this.message);
}
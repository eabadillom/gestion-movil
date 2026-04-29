class NotFound implements Exception {}

class ClienteError implements Exception 
{
  final String message;
  
  ClienteError(this.message);
}

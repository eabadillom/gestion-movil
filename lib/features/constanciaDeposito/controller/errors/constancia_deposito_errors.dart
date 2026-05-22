class ConnectionTimeout implements Exception {}

class ConstanciaDepositoErrors implements Exception 
{
  final String message;

  // final int errorCode;
  ConstanciaDepositoErrors(this.message);
}
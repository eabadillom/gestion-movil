class ConnectionTimeout implements Exception {}

class ValidacionSaldoErrors implements Exception
{
  final String message;

  ValidacionSaldoErrors(this.message);
}

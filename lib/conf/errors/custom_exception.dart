abstract class CustomException implements Exception {
  final String message;

  const CustomException(this.message);
}

class ConnectionTimeoutException extends CustomException {
  ConnectionTimeoutException() : super('Tiempo de espera agotado');
}

class NetworkException extends CustomException {
  NetworkException() : super('Sin conexión a internet');
}

class InvalidTokenException extends CustomException {
  InvalidTokenException() : super('Token proporcionado no es válido');
}

class UnauthorizedException extends CustomException {
  UnauthorizedException() : super('Sesión expirada');
}

class WrongCredentialsException extends CustomException {
  WrongCredentialsException() : super('Usuario o contraseña incorrectos');
}

class NotFoundException extends CustomException {
  NotFoundException() : super('Recurso no encontrado');
}

class CacheException extends CustomException {
  const CacheException() : super('Error de almacenamiento local');
}

class ServerException extends CustomException {
  ServerException() : super('Error interno del servidor');
}

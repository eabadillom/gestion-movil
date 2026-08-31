abstract class CustomError {
  final String message;

  const CustomError(this.message);
}

class NetworkError extends CustomError {
  const NetworkError() : super('Sin internet');
}

class TimeoutError extends CustomError {
  const TimeoutError() : super('Tiempo agotado');
}

class InvalidTokenError extends CustomError {
  const InvalidTokenError() : super('Sesión inválida, inicia sesión nuevamente');
}

class WrongCredentialsError extends CustomError {
  const WrongCredentialsError() : super('Usuario o contraseña incorrectos');
}

class ServerError extends CustomError {
  const ServerError() : super('Servidor no disponible, no se puede iniciar sesión');
}

class UnknownError extends CustomError {
  const UnknownError() : super('Error inesperado, contacte con el administrador de sistemas');
}

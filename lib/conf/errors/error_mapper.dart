import 'package:gestion_movil/conf/config.dart';

class ErrorMapper 
{

  static CustomError mapException(Exception exception) 
  {
    switch (exception) 
    {
      case NetworkException():
        return const NetworkError();
      case ConnectionTimeoutException():
        return const TimeoutError();
      case InvalidTokenException():
        return const InvalidTokenError();
      case WrongCredentialsException():
        return const WrongCredentialsError();
      case ServerException():
        return const ServerError();
      default:
        return const UnknownError();
    }
  }
  
}
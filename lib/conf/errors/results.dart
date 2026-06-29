import 'package:gestion_movil/conf/config.dart';

sealed class Results<T> {
  const Results();
}

class Success<T> extends Results<T> {
  final T data;

  const Success(this.data);
}

class Error<T> extends Results<T> {
  final CustomError customError;

  const Error(this.customError);
}

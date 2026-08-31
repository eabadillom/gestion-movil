import 'package:decimal/decimal.dart';
import 'package:intl/intl.dart';

class DecimalFormatter 
{

  static final NumberFormat _currencyFormat = NumberFormat.currency(
    locale: 'es_MX',
    symbol: '\$',
    decimalDigits: 2,
  );

  static String currency(Decimal value) 
  {
    return _currencyFormat.format(
      double.parse(value.toString()),
    );
  }
  
}

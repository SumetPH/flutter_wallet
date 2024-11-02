import 'package:intl/intl.dart';

class NumberUtils {
  static String formatNumber(double number) {
    return NumberFormat('#,##0.00').format(number);
  }
}

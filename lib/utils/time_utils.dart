import 'package:intl/intl.dart';

class TimeUtils {
  static String nowString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }
}

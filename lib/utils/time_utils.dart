import 'package:intl/intl.dart';

class TimeUtils {
  static String nowString() {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
  }

  static String dateString() {
    return DateFormat('yyyy-MM-dd').format(DateTime.now());
  }

  static String timeString() {
    return DateFormat('HH:mm:ss').format(DateTime.now());
  }
}

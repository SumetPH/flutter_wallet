import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeUtils {
  static String nowString() {
    return DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  static String dateString({DateTime? dateTime}) {
    return DateFormat('yyyy-MM-dd').format(dateTime ?? DateTime.now());
  }

  static String timeString({DateTime? dateTime}) {
    return DateFormat('HH:mm').format(dateTime ?? DateTime.now());
  }

  static String timeOfDayToString({required TimeOfDay time}) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  static TimeOfDay timeOfDayFromString({required String time}) {
    // 12:30:00 format
    final t = time.split(":");
    final hour = int.parse(t[0]);
    final minute = int.parse(t[1]);
    return TimeOfDay(hour: hour, minute: minute);
  }
}

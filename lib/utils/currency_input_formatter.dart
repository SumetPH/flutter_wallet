import 'package:flutter/services.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final text = newValue.text;

    // Regular expression to match the format
    // optional decimal point, and up to 2 digits after the decimal.
    final regex = RegExp(r'^-?\d*(\.\d{0,2})?$');

    if (regex.hasMatch(text)) {
      return newValue;
    }

    // If input is invalid, keep the old value.
    return oldValue;
  }
}

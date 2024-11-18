import 'package:flutter/material.dart';

snackBarValidateField({
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: const Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
      backgroundColor: Theme.of(context).colorScheme.error,
    ),
  );
}

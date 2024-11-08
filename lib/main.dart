import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/home.dart';

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Wallet',
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_wallet/screen/home.dart';
import 'package:flutter_wallet/screen/provider/theme_provider.dart';

void main() async {
  const flavor = String.fromEnvironment("FLAVOR", defaultValue: "dev");
  await dotenv.load(fileName: ".env.$flavor");

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(themeModeProvider) == ThemeModeState.dark;

    // กำหนดสีของ Status Bar ตามธีม
    SystemChrome.setSystemUIOverlayStyle(
      isDarkMode ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
    );

    return MaterialApp(
      title: 'Flutter Wallet',
      home: const HomeScreen(),
      themeMode: ref.watch(themeModeProvider) == ThemeModeState.light
          ? ThemeMode.light
          : ThemeMode.dark,
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

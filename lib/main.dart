import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_wallet/screen/home.dart';

void main() async {
  const flavor = String.fromEnvironment("FLAVOR", defaultValue: "dev");
  await dotenv.load(fileName: ".env.$flavor");

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
      // home: MyWidget(),
    );
  }
}

class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  List<String> items = List.generate(20, (index) => "Item ${index + 1}");

  Future<void> _handleRefresh() async {
    // Simulate network fetch or database query
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      items = List.generate(20, (index) => "Item ${index + 1}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _handleRefresh,
          child: ListView.builder(
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index]),
              );
            },
            itemCount: items.length,
          ),
        ),
      ),
    );
  }
}

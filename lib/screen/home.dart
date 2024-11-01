import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account.dart';
import 'package:flutter_wallet/screen/budget/budget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screenList = [
    const AccountScreen(),
    const BudgetScreen()
  ];
  int _screenIndex = 0;

  changeScreen(int index) {
    Navigator.pop(context);
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              onTap: () => changeScreen(0),
              title: const Text("บัญชี"),
            ),
            ListTile(
              onTap: () => changeScreen(1),
              title: const Text("งบประมาณ"),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: _screenList[_screenIndex],
      ),
    );
  }
}

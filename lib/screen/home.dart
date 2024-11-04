import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account.dart';
import 'package:flutter_wallet/screen/budget/budget.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _screenList = [
    const TransactionListScreen(),
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
              title: const Text("รายการ"),
            ),
            const Divider(height: 1.0),
            ListTile(
              onTap: () => changeScreen(1),
              title: const Text("บัญชี"),
            ),
            const Divider(height: 1.0),
            ListTile(
              onTap: () => changeScreen(2),
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

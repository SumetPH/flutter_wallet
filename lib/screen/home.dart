import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account_list.dart';
import 'package:flutter_wallet/screen/budget/budget_list.dart';
import 'package:flutter_wallet/screen/category/category_list.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Map<String, dynamic>> _screenList = [
    {
      "title": "บัญชี",
      'widget': const AccountListScreen(),
    },
    {
      "title": "รายการ",
      'widget': const TransactionListScreen(),
    },
    {
      "title": "หมวดหมู่",
      'widget': const CategoryListScreen(),
    },
    {
      "title": "งบประมาณ",
      'widget': const BudgetListScreen(),
    },
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
        child: ListView.separated(
          itemCount: _screenList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => changeScreen(index),
              title: Text(_screenList[index]['title']),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 1.0);
          },
        ),
      ),
      body: SafeArea(
        child: _screenList[_screenIndex]['widget'],
      ),
    );
  }
}

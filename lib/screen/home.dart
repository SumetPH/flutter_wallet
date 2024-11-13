import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account_list_screen.dart';
import 'package:flutter_wallet/screen/budget/budget_list_screen.dart';
import 'package:flutter_wallet/screen/category/category_list_screen.dart';
import 'package:flutter_wallet/screen/setting/setting_screen.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // state
  int _screenIndex = 0;
  final List<String> _screenTitleList = [
    "บัญชี",
    "รายการ",
    "หมวดหมู่",
    "งบประมาณ",
    'ตั้งค่า',
  ];
  final List<Widget> _screenWidgetList = [
    const AccountListScreen(),
    const TransactionListScreen(title: 'รายการ', hasDrawer: true),
    const CategoryListScreen(),
    const BudgetListScreen(),
    const SettingScreen(),
  ];

  _changeScreen(int index) {
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
          itemCount: _screenTitleList.length,
          itemBuilder: (context, index) {
            return ListTile(
              onTap: () => _changeScreen(index),
              title: Text(_screenTitleList[index]),
            );
          },
          separatorBuilder: (context, index) {
            return const Divider(height: 1.0);
          },
        ),
      ),
      body: SafeArea(
        child: _screenWidgetList[_screenIndex],
      ),
    );
  }
}

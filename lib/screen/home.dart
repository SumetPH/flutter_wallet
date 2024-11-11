import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account_list_screen.dart';
import 'package:flutter_wallet/screen/budget/budget_list_screen.dart';
import 'package:flutter_wallet/screen/category/category_list_screen.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list_screen.dart';
import 'package:flutter_wallet/widget/menu.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // state
  final List<String> _screenTitleList = [
    "บัญชี",
    "รายการ",
    "หมวดหมู่",
    "งบประมาณ",
  ];
  int _screenIndex = 0;
  int _categoryTypeId = 0;

  _screen() {
    if (_screenIndex == 0) {
      return const AccountListScreen();
    } else if (_screenIndex == 1) {
      return const TransactionListScreen();
    } else if (_screenIndex == 2) {
      return CategoryListScreen(
        changeTab: (index) {
          setState(() {
            if (index == 0) {
              _categoryTypeId = 1;
            } else {
              _categoryTypeId = 2;
            }
          });
        },
      );
    } else if (_screenIndex == 3) {
      return const BudgetListScreen();
    } else {
      return const Center(child: Text('Screen not found'));
    }
  }

  _changeScreen(int index) {
    Navigator.pop(context);
    setState(() {
      _screenIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidth(
      child: Scaffold(
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
        appBar: AppBar(
          title: Text(
            _screenTitleList[_screenIndex],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert),
              onPressed: () {
                switch (_screenIndex) {
                  case 0:
                    accountMenu(
                      context: context,
                      setState: setState,
                    );
                    break;
                  case 1:
                    transactionMenu(
                      context: context,
                      setState: setState,
                    );
                    break;
                  case 2:
                    categoryMenu(
                      context: context,
                      setState: setState,
                      categoryTypeId: _categoryTypeId,
                    );
                    break;
                  case 3:
                    budgetMenu(
                      context: context,
                      setState: setState,
                    );
                    break;
                  default:
                    break;
                }
              },
            )
          ],
        ),
        body: SafeArea(
          child: _screen(),
        ),
      ),
    );
  }
}

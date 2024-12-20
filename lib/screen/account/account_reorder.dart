import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class AccountReorder extends StatefulWidget {
  const AccountReorder({super.key});

  @override
  State<AccountReorder> createState() => _AccountReorderState();
}

class _AccountReorderState extends State<AccountReorder> {
  // service
  final _accountService = AccountService();

  // state
  List<AccountModel> _accountList = [];
  bool _isLoading = true;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList();
    setState(() {
      _accountList = res;
      _isLoading = false;
    });
  }

  Future _updateOrder() async {
    try {
      setState(() {
        _isLoading = true;
      });

      final navigator = Navigator.of(context);
      List<Map<String, dynamic>> list = [];
      int count = 0;
      for (var accountType in _accountList) {
        for (var account in accountType.accountList!) {
          list.add({
            'accountId': account.id,
            'order': count,
          });
          count++;
        }
      }

      final res = await _accountService.orderAccount(list: list);

      setState(() {
        _isLoading = false;
      });

      if (res) {
        navigator.pop();
      } else {
        throw Exception('ทํารายการไม่สําเร็จ');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ทํารายการไม่สําเร็จ'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getAccountList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'จัดเรียงบัญชี',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              await _updateOrder();
            },
          ),
        ],
      ),
      body: ResponsiveWidth(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: _accountList.length,
                        itemBuilder: (ctx, index) {
                          final accountType = _accountList[index];
                          final accountList = accountType.accountList!;
                          return Column(
                            children: [
                              Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 8.0,
                                    horizontal: 16.0,
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        accountType.name!,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              ReorderableListView.builder(
                                shrinkWrap: true,
                                primary: false,
                                itemCount: accountList.length,
                                onReorder: (oldIndex, newIndex) {
                                  setState(() {
                                    if (oldIndex < newIndex) {
                                      newIndex -= 1;
                                    }
                                    final item = accountList.removeAt(oldIndex);
                                    accountList.insert(newIndex, item);
                                  });
                                },
                                itemBuilder: (context, index) {
                                  final account = accountList[index];
                                  return Column(
                                    key: Key(account.id.toString()),
                                    children: [
                                      ListTile(
                                        onTap: () {},
                                        title: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                '${index + 1}. ${account.name!}'),
                                            if (!kIsWeb)
                                              const Icon(Icons.drag_indicator),
                                          ],
                                        ),
                                      ),
                                      const Divider(height: 1.0),
                                    ],
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

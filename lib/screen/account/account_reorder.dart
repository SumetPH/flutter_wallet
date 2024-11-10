import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet/service/account_service.dart';

class AccountReorder extends StatefulWidget {
  const AccountReorder({super.key});

  @override
  State<AccountReorder> createState() => _AccountReorderState();
}

class _AccountReorderState extends State<AccountReorder> {
  // service
  final _accountService = AccountService();

  // state
  final List<Map<String, dynamic>> _accountTypeList = [
    {'id': 1, 'name': 'เงินสด', 'list': []},
    {'id': 2, 'name': 'ธนาคาร', 'list': []},
    {'id': 3, 'name': 'บัตรเครดิต', 'list': []},
    {'id': 4, 'name': 'หนี้สิน', 'list': []},
  ];
  bool _isLoading = true;

  // method
  Future _getAccountList() async {
    try {
      final res = await _accountService.getAccountList();
      setState(() {
        for (final accountType in _accountTypeList) {
          final list = res
              .where((account) => account.accountTypeId == accountType['id'])
              .toList();
          accountType['list'] = list;
        }
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future _updateOrder({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Map<String, dynamic>> list = [];
      int count = 0;
      for (var accountType in _accountTypeList) {
        for (var accountList in accountType['list']) {
          list.add({
            'accountId': accountList.id,
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
        Navigator.pop(context);
      } else {
        throw Exception('ทํารายการไม่สําเร็จ');
      }
    } catch (e) {
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
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.arrow_back),
                        ),
                      ),
                      GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        onTap: () async {
                          await _updateOrder(context: context);
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.check),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: _accountTypeList.length,
                      itemBuilder: (context, index) {
                        final accountType = _accountTypeList[index];
                        final list = accountType['list'];
                        return Column(
                          children: [
                            Container(
                              color: Colors.grey[200],
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
                                      accountType['name'],
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
                              itemCount: list.length,
                              onReorder: (oldIndex, newIndex) {
                                setState(() {
                                  if (oldIndex < newIndex) {
                                    newIndex -= 1;
                                  }
                                  final item = list.removeAt(oldIndex);
                                  list.insert(newIndex, item);
                                });
                              },
                              itemBuilder: (context, index) {
                                return Column(
                                  key: Key(list[index].id.toString()),
                                  children: [
                                    ListTile(
                                      onTap: () {},
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              '${index + 1}. ${list[index].name!}'),
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
    );
  }
}

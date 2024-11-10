import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list_screen.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/screen/account/account_form.dart';
import 'package:flutter_wallet/widget/account_list_widget.dart';

class AccountListScreen extends StatefulWidget {
  final Function(Widget)? menu;

  const AccountListScreen({
    super.key,
    this.menu,
  });

  @override
  State<AccountListScreen> createState() => _AccountListScreenState();
}

class _AccountListScreenState extends State<AccountListScreen> {
  final _accountService = AccountService();

  // method
  Future _deleteAccount(
      {required int accountId, required BuildContext context}) async {
    try {
      final res = await _accountService.deleteAccount(
        accountId: accountId,
      );

      if (res) {
        Navigator.pop(context);
        // refresh list
        setState(() {});
      } else {
        throw Exception('ไม่สามารถลบข้อมูลได้');
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ไม่สามารถลบข้อมูลได้'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Future.value();
            },
            child: FutureBuilder<List<AccountModel>>(
              future: _accountService.getAccountList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const Center(child: Text("ไม่พบบัญชี"))
                      : AccountListWidget(
                          accountList: snapshot.data ?? [],
                          onTab: (account) async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TransactionListScreen(
                                    accountId: account.id,
                                    showAppBar: true,
                                    title: account.name,
                                  );
                                },
                              ),
                            );
                            // refresh list
                            setState(() {});
                          },
                          onLongPress: (account) {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) {
                                return Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text(
                                          'เมนู',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    ListTile(
                                      title: const Text(
                                        "แก้ไขบัญชี",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () async {
                                        Navigator.pop(context);
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                AccountFormScreen(
                                              mode: AccountFormMode.edit,
                                              accountId: account.id,
                                            ),
                                          ),
                                        );
                                        // refresh list
                                        setState(() {});
                                      },
                                    ),
                                    const Divider(),
                                    ListTile(
                                      title: const Text(
                                        "ลบบัญชี",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () async {
                                        await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              title: const Text('ลบบัญชี'),
                                              content: Text(
                                                'คุณต้องการลบบัญชี ${account.name}',
                                              ),
                                              actions: [
                                                TextButton(
                                                  child: const Text('ตกลง'),
                                                  onPressed: () async {
                                                    await _deleteAccount(
                                                      accountId: account.id!,
                                                      context: context,
                                                    );
                                                  },
                                                ),
                                                TextButton(
                                                  child: const Text('ยกเลิก'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ),
        )
      ],
    );
  }
}

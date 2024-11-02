import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/transaction/expense_form.dart';
import 'package:flutter_wallet/screen/transaction/income_form.dart';
import 'package:flutter_wallet/screen/transaction/transfer_form.dart';
import 'package:flutter_wallet/data/db/account_db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/screen/account/account_form.dart';
import 'package:flutter_wallet/widget/account_list.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final accountDB = AccountDb();
  List<AccountModel> accounts = [];

  _getAccountList() async {
    final list = await accountDB.getAccountList();
    setState(() {
      accounts = list;
    });
  }

  _removeAccount(int id) async {
    await accountDB.deleteAccount(accountId: id);
    _getAccountList();
  }

  @override
  void initState() {
    super.initState();
    _getAccountList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  Scaffold.of(context).openDrawer();
                },
                child: const Icon(Icons.menu),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => Column(
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
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const AccountFormScreen(
                                  mode: AccountFormMode.create,
                                ),
                              ),
                            );
                            _getAccountList();
                          },
                          title: const Center(
                            child: Text(
                              "เพิ่มบัญชี",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1.0),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const ExpenseFormScreen(
                                  mode: ExpenseFormMode.create,
                                );
                              }),
                            );
                            _getAccountList();
                          },
                          title: const Center(
                            child: Text(
                              "รายจ่าย",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1.0),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const IncomeFormScreen(
                                  mode: IncomeFormMode.create,
                                );
                              }),
                            );
                            _getAccountList();
                          },
                          title: const Center(
                            child: Text(
                              "รายรับ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const Divider(height: 1.0),
                        ListTile(
                          onTap: () async {
                            Navigator.pop(context);
                            await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) {
                                return const TransferFormScreen(
                                  mode: TransferFormMode.create,
                                );
                              }),
                            );
                            _getAccountList();
                          },
                          title: const Center(
                            child: Text(
                              "โอน",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
                child: const Icon(Icons.more_vert),
              ),
            )
          ],
        ),
        Expanded(
          child: accounts.isEmpty
              ? const Center(child: Text("ไม่พบบัญชี"))
              : AccountList(
                  accountList: accounts,
                  onLongPress: (account) {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return Column(
                          children: [
                            const SizedBox(
                              width: double.infinity,
                              height: 24,
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
                                    builder: (context) => AccountFormScreen(
                                      mode: AccountFormMode.edit,
                                      accountId: account.id,
                                    ),
                                  ),
                                );
                                _getAccountList();
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
                                            await _removeAccount(account.id!);
                                            Navigator.pop(context);
                                            _getAccountList();
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
                ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_wallet/type/account_type.dart';
import 'package:flutter_wallet/db/account_db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/screen/account/account_form.dart';
import 'package:flutter_wallet/screen/transaction/transaction_form.dart';
import 'package:grouped_list/grouped_list.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final accountDB = AccountDb();
  List<AccountModel> accounts = [];

  _getAccountList() async {
    final list = await accountDB.getAccount();
    setState(() {
      accounts = list;
    });
  }

  _removeAccount(int id) async {
    await accountDB.removeAccount(id: id);
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
                    builder: (context) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 28.0),
                      child: Column(
                        children: [
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
                                  return const TransactionFormScreen(
                                    mode: TransactionFormMode.create,
                                  );
                                }),
                              );
                              _getAccountList();
                            },
                            title: const Center(
                              child: Text(
                                "เพิ่มรายการ",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
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
              : GroupedListView(
                  elements: accounts,
                  groupBy: (element) => element.type,
                  groupHeaderBuilder: (value) {
                    final sum = accounts
                        .where((a) => a.type == value.type)
                        .map((a) => a.balance)
                        .reduce((a, b) => a! + b!);
                    return Container(
                      color: Colors.grey[200],
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8.0,
                          horizontal: 16.0,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              AccountType.getName(value.type!),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              '${sum!.toStringAsFixed(2)} บาท',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: [1, 2].contains(value.type)
                                    ? Colors.green[600]
                                    : Colors.red[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  useStickyGroupSeparators: true,
                  separator: const Divider(
                    height: 1,
                  ),
                  itemBuilder: (context, element) => GestureDetector(
                    onTap: () async {},
                    onLongPress: () {
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
                                        accountId: element.id,
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
                                  await _removeAccount(element.id!);
                                  Navigator.pop(context);
                                  _getAccountList();
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CircleAvatar(
                            child: Icon(Icons.wallet),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    element.name!,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    '${element.balance!.toStringAsFixed(2)} บาท',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: [1, 2].contains(element.type)
                                          ? Colors.green[600]
                                          : Colors.red[600],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}

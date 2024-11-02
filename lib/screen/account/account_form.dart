import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/type/account_type.dart';
import 'package:flutter_wallet/data/db/account_db.dart';
import 'package:flutter_wallet/model/account_type_model.dart';

enum AccountFormMode { create, edit }

class AccountFormScreen extends StatefulWidget {
  final AccountFormMode mode;
  final int? accountId;

  const AccountFormScreen({
    super.key,
    required this.mode,
    this.accountId,
  });

  @override
  State<AccountFormScreen> createState() => _AccountFormScreenState();
}

class _AccountFormScreenState extends State<AccountFormScreen> {
  final accountDb = AccountDb();

  // state
  List<AccountTypeModel> accountTypeList = AccountType.list;
  TextEditingController nameController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  int accountType = 1;

  // method
  Future _getAccountDetail() async {
    final account = await accountDb.getAccountDetail(id: widget.accountId!);
    setState(() {
      nameController.text = account.name ?? '';
      amountController.text = account.amount.toString();
      accountType = account.type ?? -1;
    });
  }

  Future _addAccount() async {
    await accountDb.createAccount(
      name: nameController.text,
      amount: double.parse(amountController.text),
      type: accountType,
    );
  }

  Future _updateAccount() async {
    await accountDb.updateAccount(
      id: widget.accountId!,
      name: nameController.text,
      amount: double.parse(amountController.text),
      type: accountType,
    );
  }

  // lifecycle
  @override
  void initState() {
    super.initState();

    if (widget.mode == AccountFormMode.edit) {
      _getAccountDetail();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.chevron_left),
                  ),
                ),
                GestureDetector(
                  onTap: () async {
                    if (nameController.text.isEmpty ||
                        amountController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                        ),
                      );
                    } else {
                      if (widget.mode == AccountFormMode.create) {
                        await _addAccount();
                      } else {
                        await _updateAccount();
                      }
                      Navigator.pop(context);
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Icon(Icons.check),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('ชื่อบัญชี'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: nameController,
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ระบุ',
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('ยอดเริ่มต้น'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^-?\d*\.?\d{0,2}'),
                        ),
                      ],
                      textAlign: TextAlign.end,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'ระบุ',
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 14.0),
                    child: Text('ชนิดบัญชี'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(16.0),
                                child: Center(
                                  child: Text(
                                    'เลือกชนิดบัญชี',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 1);
                                  },
                                  itemCount: accountTypeList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        accountTypeList[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          accountType =
                                              accountTypeList[index].id;
                                        });
                                      },
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(AccountType.getName(accountType)),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}

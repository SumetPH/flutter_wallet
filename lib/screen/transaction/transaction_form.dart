import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/data/db/account_db.dart';
import 'package:flutter_wallet/data/db/transactions_db.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/model/transactions_type_model.dart';
import 'package:flutter_wallet/type/transactions_type.dart';
import 'package:flutter_wallet/widget/AccountSelectModal.dart';

enum TransactionFormMode { create, edit }

class TransactionFormScreen extends StatefulWidget {
  final TransactionFormMode mode;

  const TransactionFormScreen({
    super.key,
    required this.mode,
  });

  @override
  State<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends State<TransactionFormScreen> {
  final _transactionsDb = TransactionsDB();
  final _accountDb = AccountDB();

  // state
  List<AccountModel> _accountList = [];
  final List<TransactionsTypeModel> _transactionsTypeList = [
    TransactionsTypeModel(id: 1, name: 'รายจ่าย'),
    TransactionsTypeModel(id: 2, name: 'รายรับ'),
  ];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _transactionType = 1;
  int _accountId = -1;

  // method
  Future _getAccountList() async {
    final res = await _accountDb.getAccountList(type: '1,2');
    setState(() {
      _accountList = res;

      if (_accountList.isNotEmpty) {
        _accountId = _accountList.first.id!;
      }
    });
  }

  Future _createTransaction() async {
    await _transactionsDb.createTransaction(
      amount: double.parse(_amountController.text),
      note: _noteController.text,
      transactionTypeId: _transactionType,
      accountId: _accountId,
    );
  }

  String _getAccountName(int id) {
    try {
      return _accountList
          .firstWhere((element) => element.id == id)
          .name
          .toString();
    } catch (e) {
      return 'ระบุ';
    }
  }

  @override
  void initState() {
    super.initState();

    _getAccountList();
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
                    if (_amountController.text.isEmpty || _accountId == -1) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                        ),
                      );
                    } else {
                      if (widget.mode == TransactionFormMode.create) {
                        await _createTransaction();
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
                    child: Text('จำนวนเงิน'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _transactionType == 1
                            ? Colors.red[600]
                            : Colors.green[600],
                      ),
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
                    child: Text('บันทึก'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: TextField(
                      controller: _noteController,
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
                    child: Text('ประเภท'),
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
                                    'เลือกประเภท',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.separated(
                                  separatorBuilder: (context, index) {
                                    return const Divider(height: 1.0);
                                  },
                                  itemCount: _transactionsTypeList.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      title: Text(
                                        _transactionsTypeList[index].name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onTap: () {
                                        Navigator.pop(context);
                                        setState(() {
                                          _transactionType =
                                              _transactionsTypeList[index].id;
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
                          Text(TransactionsType.getName(_transactionType)),
                          const Icon(Icons.chevron_right),
                        ],
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
                    child: Text('บัญชี'),
                  ),
                  const SizedBox(width: 20.0),
                  Expanded(
                    child: GestureDetector(
                      onTap: () async {
                        accountSelectModal(
                          context: context,
                          accountList: _accountList,
                          onSelected: (value) {
                            setState(() {
                              _accountId = value;
                            });
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(_getAccountName(_accountId)),
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

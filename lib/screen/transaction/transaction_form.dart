import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/transaction_service.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/account_list.dart';

enum TransactionFormMode { create, edit }

class TransactionFormScreen extends StatefulWidget {
  final TransactionFormMode mode;

  const TransactionFormScreen({
    super.key,
    required this.mode,
  });

  @override
  State<TransactionFormScreen> createState() => TransactionFormScreenState();
}

class TransactionFormScreenState extends State<TransactionFormScreen> {
  final _transactionService = TransactionService();
  final _accountService = AccountService();
  final _categoryService = CategoryService();

  // state
  List<AccountModel> _accountList = [];
  List<CategoryModel> _categoryList = [];
  final List<Map<String, dynamic>> _transactionTypeList = [
    {'id': 1, 'name': 'รายจ่าย'},
    {'id': 2, 'name': 'รายรับ'},
  ];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int _transactionTypeId = 1;
  int? _accountId;
  int? _categoryId;
  final String _date = TimeUtils.dateString();
  final String _time = TimeUtils.timeString();
  bool _isLoading = false;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList(type: [1, 2, 3]);
    setState(() {
      _accountList = res;
    });
  }

  Future _getCategoryList() async {
    final res = await _categoryService.getCategoryList(
      categoryTypeId: _transactionTypeId,
    );
    setState(() {
      _categoryList = res;
    });
  }

  Future _createTransaction({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      final res = await _transactionService.creteTransaction(
        amount: double.parse(_amountController.text),
        accountId: _accountId!,
        categoryId: _categoryId!,
        note: _noteController.text,
        transactionTypeId: _transactionTypeId,
        date: _date,
        time: _time,
      );

      if (res) {
        setState(() {
          _isLoading = false;
        });
        Navigator.pop(context);
      } else {
        throw Exception('ทํารายการไม่สําเร็จ');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ทำรายการไม่สําเร็จ'),
      ));
    }
  }

  String _getTransactionTypeName() {
    try {
      return _transactionTypeList
          .firstWhere((element) => element['id'] == _transactionTypeId)['name']
          .toString();
    } catch (e) {
      return 'เลือก';
    }
  }

  String _getAccountName() {
    try {
      return _accountList
          .firstWhere((element) => element.id == _accountId)
          .name
          .toString();
    } catch (e) {
      return 'เลือก';
    }
  }

  String _getCategoryName() {
    try {
      return _categoryList
          .firstWhere((element) => element.id == _categoryId)
          .name
          .toString();
    } catch (e) {
      return 'เลือก';
    }
  }

  @override
  void initState() {
    super.initState();

    _getAccountList();
    _getCategoryList();
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
                        onTap: () => Navigator.pop(context),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Icon(Icons.chevron_left),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (_amountController.text.isEmpty ||
                              _accountId == null ||
                              _categoryId == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                              ),
                            );
                          } else {
                            if (widget.mode == TransactionFormMode.create) {
                              await _createTransaction(context: context);
                            }
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
                              color: _transactionTypeId == 1
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
                                builder: (context) {
                                  return Column(
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
                                          itemBuilder: (itemContext, index) {
                                            return ListTile(
                                              title: Text(
                                                  _transactionTypeList[index]
                                                      ['name']),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _transactionTypeId =
                                                      _transactionTypeList[
                                                          index]['id'];
                                                  _categoryId = null;
                                                });
                                                _getCategoryList();
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider(height: 1.0);
                                          },
                                          itemCount:
                                              _transactionTypeList.length,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_getTransactionTypeName()),
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
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'เลือกบัญชี',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: AccountList(
                                          accountList: _accountList,
                                          onTab: (account) {
                                            Navigator.pop(context);
                                            setState(() {
                                              _accountId = account.id;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_getAccountName()),
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
                          child: Text('หมวดหมู่'),
                        ),
                        const SizedBox(width: 20.0),
                        Expanded(
                          child: GestureDetector(
                            onTap: () async {
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Column(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(16.0),
                                        child: Center(
                                          child: Text(
                                            'เลือกหมวดหมู่',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: ListView.separated(
                                          itemBuilder: (itemContext, index) {
                                            return ListTile(
                                              title: Text(
                                                  _categoryList[index].name!),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _categoryId =
                                                      _categoryList[index].id;
                                                });
                                              },
                                            );
                                          },
                                          separatorBuilder: (context, index) {
                                            return const Divider(height: 1.0);
                                          },
                                          itemCount: _categoryList.length,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(_getCategoryName()),
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

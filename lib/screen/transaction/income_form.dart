import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/service/income_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/widget/account_list.dart';

enum IncomeFormMode { create, edit }

class IncomeFormScreen extends StatefulWidget {
  final IncomeFormMode mode;

  const IncomeFormScreen({
    super.key,
    required this.mode,
  });

  @override
  State<IncomeFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<IncomeFormScreen> {
  final _incomeService = IncomeService();
  final _accountService = AccountService();
  final _categoryService = CategoryService();

  // state
  List<AccountModel> _accountList = [];
  List<CategoryModel> _categoryList = [];
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int? _accountId;
  int? _categoryId;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList(type: [1, 2]);
    setState(() {
      _accountList = res;
    });
  }

  Future _getCategoryList() async {
    final res = await _categoryService.getCategoryList(categoryTypeId: 2);
    setState(() {
      _categoryList = res;
    });
  }

  Future _createIncome() async {
    await _incomeService.createIncome(
      amount: double.parse(_amountController.text),
      accountId: _accountId!,
      categoryId: _categoryId!,
      note: _noteController.text,
    );
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
                    if (_amountController.text.isEmpty || _accountId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                        ),
                      );
                    } else {
                      if (widget.mode == IncomeFormMode.create) {
                        await _createIncome();
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
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                        signed: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(
                          RegExp(r'^\d+\.?\d{0,2}'),
                        ),
                      ],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green[600],
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
                                          title:
                                              Text(_categoryList[index].name!),
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
                                      itemCount: _categoryList.length),
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

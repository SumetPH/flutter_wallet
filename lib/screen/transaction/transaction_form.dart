import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/transaction_service.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/account_list_widget.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

enum TransactionFormMode { create, edit }

class TransactionFormScreen extends StatefulWidget {
  final TransactionFormMode mode;
  final int? transactionId;

  const TransactionFormScreen({
    super.key,
    required this.mode,
    this.transactionId,
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
  String _accountName = 'เลือก';
  int? _categoryId;
  String _categoryName = 'เลือก';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isLoading = true;

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

  Future _getTransactionDetail({required int transactionId}) async {
    try {
      final res = await _transactionService.getTransactionDetail(
        transactionId: transactionId,
      );

      setState(() {
        _amountController.text = res.amount.toString();
        _accountId = res.accountId;
        _accountName = res.accountName ?? '';
        _categoryId = res.categoryId;
        _categoryName = res.categoryName ?? '';
        _noteController.text = res.note ?? '';
        _transactionTypeId = res.transactionTypeId!;
        _date = DateTime.parse(res.date!);
        _time = TimeUtils.timeOfDayFromString(time: res.time!);
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _createOrUpdateTransaction({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      bool res = false;
      if (widget.mode == TransactionFormMode.create) {
        res = await _transactionService.creteTransaction(
          amount: double.parse(_amountController.text),
          accountId: _accountId!,
          categoryId: _categoryId!,
          note: _noteController.text,
          transactionTypeId: _transactionTypeId,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
        );
      } else {
        res = await _transactionService.updateTransaction(
          transactionId: widget.transactionId!,
          amount: double.parse(_amountController.text),
          accountId: _accountId!,
          categoryId: _categoryId!,
          note: _noteController.text,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
        );
      }

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

  _getInitialValue() async {
    await _getAccountList();
    await _getCategoryList();
    if (widget.mode == TransactionFormMode.edit) {
      await _getTransactionDetail(transactionId: widget.transactionId!);
    }
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getInitialValue();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidth(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            '${widget.mode == TransactionFormMode.create ? 'เพิ่ม' : 'แก้ไข'}รายการ',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (_amountController.text.isEmpty ||
                    _accountId == null ||
                    _categoryId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                    ),
                  );
                } else {
                  await _createOrUpdateTransaction(context: context);
                }
              },
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  child: Column(
                    children: [
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
                              child: Text('ประเภท'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  // create mode only
                                  if (widget.mode ==
                                      TransactionFormMode.create) {
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
                                                itemBuilder:
                                                    (itemContext, index) {
                                                  return ListTile(
                                                    title: Text(
                                                        _transactionTypeList[
                                                            index]['name']),
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
                                                separatorBuilder:
                                                    (context, index) {
                                                  return const Divider(
                                                      height: 1.0);
                                                },
                                                itemCount:
                                                    _transactionTypeList.length,
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _getTransactionTypeName(),
                                      style: TextStyle(
                                        color: widget.mode ==
                                                TransactionFormMode.edit
                                            ? Colors.grey
                                            : null,
                                      ),
                                    ),
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
                                    isScrollControlled: true,
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
                                            child: AccountListWidget(
                                              accountList: _accountList,
                                              onTab: (account) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _accountId = account.id;
                                                  _accountName = account.name!;
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
                                    Expanded(
                                      child: Text(
                                        _accountName,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
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
                                    isScrollControlled: true,
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
                                              itemBuilder:
                                                  (itemContext, index) {
                                                return ListTile(
                                                  title: Text(
                                                      _categoryList[index]
                                                          .name!),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _categoryId =
                                                          _categoryList[index]
                                                              .id;
                                                      _categoryName =
                                                          _categoryList[index]
                                                              .name!;
                                                    });
                                                  },
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(
                                                    height: 1.0);
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
                                    Expanded(
                                      child: Text(
                                        _categoryName,
                                        overflow: TextOverflow.ellipsis,
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
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
                              child: Text('วันที่'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _date,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                  );

                                  if (date != null) {
                                    setState(() {
                                      _date = date;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(TimeUtils.dateString(dateTime: _date)),
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
                              child: Text('เวลา'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final time = await showTimePicker(
                                    context: context,
                                    initialTime: _time,
                                    initialEntryMode:
                                        TimePickerEntryMode.inputOnly,
                                    builder:
                                        (BuildContext context, Widget? child) {
                                      return MediaQuery(
                                        data: MediaQuery.of(context).copyWith(
                                            alwaysUse24HourFormat: true),
                                        child: child!,
                                      );
                                    },
                                  );
                                  if (time != null) {
                                    setState(() {
                                      _time = time;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(TimeUtils.timeOfDayToString(
                                        time: _time)),
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
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

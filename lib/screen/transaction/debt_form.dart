import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/service/debt_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/account_list.dart';

enum DebtFormMode { create, edit }

class DebtFormScreen extends StatefulWidget {
  final DebtFormMode mode;
  final int? transactionId;

  const DebtFormScreen({
    super.key,
    required this.mode,
    this.transactionId,
  });

  @override
  State<DebtFormScreen> createState() => DebtFormScreenState();
}

class DebtFormScreenState extends State<DebtFormScreen> {
  final _debtService = DebtService();
  final _accountService = AccountService();
  final _categoryService = CategoryService();

  // state
  List<AccountModel> _accountList = [];
  List<CategoryModel> _categoryList = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int? _accountIdFrom;
  int? _accountIdTo;
  int? _categoryId;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isLoading = false;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList();
    setState(() {
      _accountList = res;
    });
  }

  Future _getCategoryList() async {
    final res = await _categoryService.getCategoryList(
      categoryTypeId: 1,
    );
    setState(() {
      _categoryList = res;
    });
  }

  Future _getDebtDetail({required int transactionId}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final res = await _debtService.getDebtDetail(
        transactionId: transactionId,
      );

      setState(() {
        _isLoading = false;
        _amountController.text = res.amount.toString();
        _accountIdFrom = res.accountIdFrom;
        _accountIdTo = res.accountIdTo;
        _noteController.text = res.note ?? '';
        _date = DateTime.parse(res.date!);
        _time = TimeUtils.timeOfDayFromString(time: res.time!);
        _categoryId = res.categoryId;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context);
    }
  }

  Future _createOrUpdateDebt({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      bool res = false;

      if (widget.mode == DebtFormMode.create) {
        res = await _debtService.createDebt(
          amount: double.parse(_amountController.text),
          note: _noteController.text,
          accountIdFrom: _accountIdFrom!,
          accountIdTo: _accountIdTo!,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
          categoryId: _categoryId,
        );
      } else {
        res = await _debtService.updateDebt(
          transactionId: widget.transactionId!,
          amount: double.parse(_amountController.text),
          note: _noteController.text,
          accountIdFrom: _accountIdFrom!,
          accountIdTo: _accountIdTo!,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
          categoryId: _categoryId,
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
        content: Text('ทํารายการไม่สําเร็จ'),
      ));
    }
  }

  String _getAccountName(int? id) {
    try {
      return _accountList
          .firstWhere((element) => element.id == id)
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
    if (mounted) {
      _getAccountList();
      _getCategoryList();
      if (widget.mode == DebtFormMode.edit) {
        _getDebtDetail(transactionId: widget.transactionId!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.chevron_left),
                          ),
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_amountController.text.isEmpty ||
                                _accountIdTo == null ||
                                _accountIdFrom == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                                ),
                              );
                            } else {
                              await _createOrUpdateDebt(context: context);
                            }
                          },
                          child: const Padding(
                            padding: EdgeInsets.all(12.0),
                            child: Icon(Icons.check),
                          ),
                        ),
                      ],
                    ),
                    const Divider(),
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
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
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
                                          child: AccountList(
                                            accountList: _accountList
                                                .where((el) => [1, 2, 3]
                                                    .contains(el.accountTypeId))
                                                .toList(),
                                            disabledAccountId: _accountIdTo,
                                            onTab: (account) {
                                              if (account.id != _accountIdTo) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _accountIdFrom = account.id;
                                                });
                                              }
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
                                      _getAccountName(_accountIdFrom),
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
                            child: Text('บัญชีหนี้สิน'),
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
                                          child: AccountList(
                                            accountList: _accountList
                                                .where((el) => [3, 4]
                                                    .contains(el.accountTypeId))
                                                .toList(),
                                            disabledAccountId: _accountIdFrom,
                                            onTab: (account) {
                                              if (account.id !=
                                                  _accountIdFrom) {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _accountIdTo = account.id;
                                                });
                                              }
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
                                      _getAccountName(_accountIdTo),
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
                                  Expanded(
                                    child: Text(
                                      _getCategoryName(),
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
                                  Text(
                                      TimeUtils.timeOfDayToString(time: _time)),
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
    );
  }
}

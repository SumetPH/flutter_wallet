import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/transfer_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/account_list.dart';

enum TransferFormMode { create, edit }

class TransferFormScreen extends StatefulWidget {
  final TransferFormMode mode;

  const TransferFormScreen({
    super.key,
    required this.mode,
  });

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  final _transferService = TransferService();
  final _accountService = AccountService();

  // state
  List<AccountModel> _accountList = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int? _accountIdFrom;
  int? _accountIdTo;
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isLoading = false;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList(type: [1, 2]);
    setState(() {
      _accountList = res;
    });
  }

  Future _createTransfer({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final res = await _transferService.createTransfer(
        amount: double.parse(_amountController.text),
        note: _noteController.text,
        accountIdFrom: _accountIdFrom!,
        accountIdTo: _accountIdTo!,
        date: TimeUtils.dateString(dateTime: _date),
        time: TimeUtils.timeOfDayToString(time: _time),
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

  @override
  void initState() {
    super.initState();
    _getAccountList();
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
                            padding: EdgeInsets.all(8.0),
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
                              if (widget.mode == TransferFormMode.create) {
                                await _createTransfer(context: context);
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
                            child: Text('บัญชีต้นทาง'),
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
                                  Text(_getAccountName(_accountIdFrom)),
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
                            child: Text('บัญชีปลายทาง'),
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
                                  Text(_getAccountName(_accountIdTo)),
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

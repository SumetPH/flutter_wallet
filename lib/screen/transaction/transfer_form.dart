import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/transaction_service.dart';
import 'package:flutter_wallet/service/transfer_service.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/snackbar_validate_field.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/account_list_widget.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

enum TransferFormMode { create, edit }

class TransferFormScreen extends StatefulWidget {
  final TransferFormMode mode;
  final int? transactionId;

  const TransferFormScreen({
    super.key,
    required this.mode,
    this.transactionId,
  });

  @override
  State<TransferFormScreen> createState() => _TransferFormScreenState();
}

class _TransferFormScreenState extends State<TransferFormScreen> {
  // final _transferService = TransferService();
  final _accountService = AccountService();
  final _transactionService = TransactionService();

  // state
  List<AccountModel> _accountList = [];

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  int? _accountIdFrom;
  String _accountNameFrom = 'เลือก';
  int? _accountIdTo;
  String _accountNameTo = 'เลือก';
  DateTime _date = DateTime.now();
  TimeOfDay _time = TimeOfDay.now();
  bool _isLoading = true;

  // method
  Future _getAccountList() async {
    final res = await _accountService.getAccountList(type: [1, 2]);
    setState(() {
      _accountList = res;
    });
  }

  Future _getTransferDetail({required int transactionId}) async {
    try {
      final res = await _transactionService.getTransactionDetail(
        transactionId: transactionId,
      );

      setState(() {
        _amountController.text = res.amount.toString();
        _accountIdFrom = res.accountIdFrom;
        _accountNameFrom = res.accountIdFromName ?? '';
        _accountIdTo = res.accountIdTo;
        _accountNameTo = res.accountIdToName ?? '';
        _noteController.text = res.note ?? '';
        _date = DateTime.parse(res.date!);
        _time = TimeUtils.timeOfDayFromString(time: res.time!);
      });
    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);
    }
  }

  Future _createOrUpdateTransfer() async {
    try {
      setState(() {
        _isLoading = true;
      });

      if (widget.mode == TransferFormMode.create) {
        await _transactionService.creteTransaction(
          amount: double.parse(_amountController.text),
          transactionTypeId: 3,
          note: _noteController.text,
          accountIdFrom: _accountIdFrom!,
          accountIdTo: _accountIdTo!,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
        );
      } else {
        await _transactionService.updateTransaction(
          transactionId: widget.transactionId!,
          amount: double.parse(_amountController.text),
          note: _noteController.text,
          accountIdFrom: _accountIdFrom!,
          accountIdTo: _accountIdTo!,
          date: TimeUtils.dateString(dateTime: _date),
          time: TimeUtils.timeOfDayToString(time: _time),
        );
      }

      setState(() {
        _isLoading = false;
      });

      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ทํารายการไม่สําเร็จ'),
      ));
    }
  }

  _getInitialValue() async {
    await _getAccountList();
    if (widget.mode == TransferFormMode.edit) {
      await _getTransferDetail(transactionId: widget.transactionId!);
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${widget.mode == TransferFormMode.create ? 'เพิ่ม' : 'แก้ไข'}การโอน',
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () async {
              if (_amountController.text.isEmpty ||
                  _accountIdTo == null ||
                  _accountIdFrom == null) {
                snackBarValidateField(context: context);
              } else {
                await _createOrUpdateTransfer();
              }
            },
          ),
        ],
      ),
      body: ResponsiveWidth(
        child: SafeArea(
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
                                              disabledAccountId: _accountIdTo,
                                              onTab: (account) {
                                                if (account.id !=
                                                    _accountIdTo) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _accountIdFrom = account.id;
                                                    _accountNameFrom =
                                                        account.name!;
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
                                        _accountNameFrom,
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
                              child: Text('บัญชีปลายทาง'),
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
                                              disabledAccountId: _accountIdFrom,
                                              onTab: (account) {
                                                if (account.id !=
                                                    _accountIdFrom) {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _accountIdTo = account.id;
                                                    _accountNameTo =
                                                        account.name!;
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
                                        _accountNameTo,
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

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/service/schedule_service.dart';
import 'package:flutter_wallet/utils/snackbar_validate_field.dart';
import 'package:flutter_wallet/utils/time_utils.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

enum ScheduleFormMode { add, edit }

class ScheduleForm extends StatefulWidget {
  final ScheduleFormMode mode;
  const ScheduleForm({super.key, required this.mode});

  @override
  State<ScheduleForm> createState() => _ScheduleFormState();
}

class _ScheduleFormState extends State<ScheduleForm> {
  // service
  final ScheduleService _scheduleService = ScheduleService();

  // state
  final List<Map<String, dynamic>> _transactionTypeList = [
    {'id': 1, 'name': 'รายจ่าย'},
    {'id': 4, 'name': 'ชำระหนี้'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now();
  int _transactionTypeId = 1;
  bool _isLoading = false;

  // method
  _createSchedule() async {
    try {
      setState(() {
        _isLoading = true;
      });
      final res = await _scheduleService.createSchedule(
        name: _nameController.text,
        amount: double.parse(_amountController.text),
        startDate: TimeUtils.dateString(dateTime: _startDate),
        endDate: TimeUtils.dateString(dateTime: _endDate),
        transactionTypeId: _transactionTypeId,
      );
      if (res) {
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        throw Exception('ทํารายการไม่สําเร็จ');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (!mounted) return;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == ScheduleFormMode.add
              ? 'เพิ่มรายการประจำ'
              : 'แก้ไขรายการประจำ',
        ),
        actions: [
          IconButton(
            onPressed: () async {
              if (_amountController.text.isEmpty ||
                  _nameController.text.isEmpty) {
                snackBarValidateField(context: context);
              } else {
                await _createSchedule();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: SafeArea(
        child: ResponsiveWidth(
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
                              child: Text('ชื่อ'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: TextField(
                                controller: _nameController,
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
                                                    });
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
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      _getTransactionTypeName(),
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
                              child: Text('วันที่เริ่มต้น'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _startDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                  );

                                  if (date != null) {
                                    setState(() {
                                      _startDate = date;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(TimeUtils.dateString(
                                        dateTime: _startDate)),
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
                              child: Text('วันที่สิ้นสุด'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  final date = await showDatePicker(
                                    context: context,
                                    initialDate: _endDate,
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                    initialEntryMode:
                                        DatePickerEntryMode.calendarOnly,
                                  );

                                  if (date != null) {
                                    setState(() {
                                      _endDate = date;
                                    });
                                  }
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(TimeUtils.dateString(
                                        dateTime: _endDate)),
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
        ),
      ),
    );
  }
}

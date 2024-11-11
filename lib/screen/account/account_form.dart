import 'package:flutter/material.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/service/account_type_service.dart';
import 'package:flutter_wallet/model/account_type_model.dart';
import 'package:flutter_wallet/utils/currency_input_formatter.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

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
  final _accountService = AccountService();
  final _accountTypeService = AccountTypeService();

  // state
  List<AccountTypeModel> _accountTypeList = [];
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int? _accountTypeId;
  bool _isLoading = true;

  // method
  Future _getAccountTypeList() async {
    final res = await _accountTypeService.getAccountTypeList();
    setState(() {
      _accountTypeList = res;
    });
  }

  Future _getAccountDetail() async {
    try {
      final accountDetail =
          await _accountService.getAccountDetail(accountId: widget.accountId!);
      setState(() {
        _nameController.text = accountDetail.name ?? '';
        _amountController.text = accountDetail.amount.toString();
        _accountTypeId = accountDetail.accountTypeId;
      });
    } catch (e) {
      print(e);
    }
  }

  String _getAccountTypeName() {
    try {
      return _accountTypeList
          .firstWhere((account) => account.id == _accountTypeId)
          .name!;
    } catch (e) {
      return 'เลือก';
    }
  }

  _getInitialValue() async {
    await _getAccountTypeList();
    if (widget.mode == AccountFormMode.edit) {
      await _getAccountDetail();
    }
    setState(() {
      _isLoading = false;
    });
  }

  // lifecycle
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
              '${widget.mode == AccountFormMode.create ? 'เพิ่ม' : 'แก้ไข'}บัญชี'),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _amountController.text.isEmpty ||
                    _accountTypeId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                    ),
                  );
                } else {
                  if (widget.mode == AccountFormMode.create) {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      final created = await _accountService.createAccount(
                        name: _nameController.text,
                        amount: double.parse(_amountController.text),
                        accountTypeId: _accountTypeId!,
                      );
                      if (created) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      } else {
                        throw Exception('Failed to create account');
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                          ),
                        ),
                      );
                    }
                  } else {
                    try {
                      setState(() {
                        _isLoading = true;
                      });
                      final created = await _accountService.updateAccount(
                        accountId: widget.accountId!,
                        name: _nameController.text,
                        amount: double.parse(_amountController.text),
                        accountTypeId: _accountTypeId!,
                      );
                      if (created) {
                        setState(() {
                          _isLoading = false;
                        });
                        Navigator.pop(context);
                      } else {
                        throw Exception('Failed to create account');
                      }
                    } catch (e) {
                      setState(() {
                        _isLoading = false;
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'เกิดข้อผิดพลาด กรุณาลองใหม่อีกครั้ง',
                          ),
                        ),
                      );
                    }
                  }
                }
              },
            )
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
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
                            child: Text('ยอดเริ่มต้น'),
                          ),
                          const SizedBox(width: 20.0),
                          Expanded(
                            child: TextField(
                              controller: _amountController,
                              inputFormatters: [CurrencyInputFormatter()],
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
                                          itemCount: _accountTypeList.length,
                                          itemBuilder: (context, index) {
                                            return ListTile(
                                              title: Text(
                                                _accountTypeList[index].name!,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              onTap: () {
                                                Navigator.pop(context);
                                                setState(() {
                                                  _accountTypeId =
                                                      _accountTypeList[index]
                                                          .id;
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
                                  Text(_getAccountTypeName()),
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
    );
  }
}

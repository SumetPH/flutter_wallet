import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/service/budget_service.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

enum BudgetFormMode { create, edit }

class BudgetFormScreen extends StatefulWidget {
  final BudgetFormMode mode;
  final int? budgetId;

  const BudgetFormScreen({
    super.key,
    required this.mode,
    this.budgetId,
  });

  @override
  State<BudgetFormScreen> createState() => BudgetFormScreenState();
}

class BudgetFormScreenState extends State<BudgetFormScreen> {
  // service
  final _budgetService = BudgetService();
  final _categoryService = CategoryService();

  // state
  List<CategoryModel> _categoryList = [];
  final List<int> _dateOfMonth = List.generate(30, (index) => index + 1);

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  int _startDate = 1;
  List<int> _categoryId = [];
  bool _isLoading = true;

  // method
  Future _getCategoryList() async {
    final res = await _categoryService.getCategoryList(categoryTypeId: 1);
    setState(() {
      _categoryList = res;
    });
  }

  Future _getBudgetDetail({required int budgetId}) async {
    try {
      final res = await _budgetService.getBudgetDetail(budgetId: budgetId);

      setState(() {
        _isLoading = false;
        _nameController.text = res.budget?.name ?? '';
        _amountController.text = res.budget?.amount.toString() ?? '';
        _startDate = res.budget?.startDate ?? 1;
        _categoryId = res.category != null
            ? res.category!.map((el) => el.categoryId!).toList()
            : [];
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _createOrUpdateBudget({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      bool res = false;
      if (widget.mode == BudgetFormMode.create) {
        res = await _budgetService.createBudget(
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          startDate: _startDate,
          categoryId: _categoryId,
        );
      } else {
        res = await _budgetService.updateBudget(
          budgetId: widget.budgetId!,
          name: _nameController.text,
          amount: double.parse(_amountController.text),
          startDate: _startDate,
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
        content: Text('ทำรายการไม่สําเร็จ'),
      ));
    }
  }

  _selectCategory({required int categoryId}) {
    if (_categoryId.contains(categoryId)) {
      _categoryId.remove(categoryId);
    } else {
      _categoryId.add(categoryId);
    }
  }

  _getInitialValue() async {
    await _getCategoryList();
    if (widget.mode == BudgetFormMode.edit) {
      await _getBudgetDetail(budgetId: widget.budgetId!);
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
            '${widget.mode == BudgetFormMode.create ? 'เพิ่ม' : 'แก้ไข'}งบประมาณ',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (_nameController.text.isEmpty ||
                    _amountController.text.isEmpty ||
                    _categoryId.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                    ),
                  );
                } else {
                  await _createOrUpdateBudget(context: context);
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
                              child: Text('จำนวน'),
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
                                    fontWeight: FontWeight.bold),
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
                              child: Text('หมวดหมู่'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return Column(
                                            children: [
                                              const Padding(
                                                padding: EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    'เลือกหมวดหมู่',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              Expanded(
                                                child: ListView.separated(
                                                  itemBuilder:
                                                      (itemContext, index) {
                                                    final id =
                                                        _categoryList[index]
                                                            .id!;
                                                    return ListTile(
                                                        onTap: () {
                                                          setState(() {
                                                            _selectCategory(
                                                                categoryId: id);
                                                          });
                                                        },
                                                        title: Row(
                                                          children: [
                                                            Checkbox(
                                                                value: _categoryId
                                                                    .contains(
                                                                        id),
                                                                onChanged:
                                                                    (value) {
                                                                  setState(() {
                                                                    setState(
                                                                        () {
                                                                      _selectCategory(
                                                                          categoryId:
                                                                              id);
                                                                    });
                                                                  });
                                                                }),
                                                            Text(_categoryList[
                                                                    index]
                                                                .name!)
                                                          ],
                                                        ));
                                                  },
                                                  separatorBuilder:
                                                      (context, index) {
                                                    return const Divider(
                                                        height: 1.0);
                                                  },
                                                  itemCount:
                                                      _categoryList.length,
                                                ),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('เลือก ${_categoryId.length}'),
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
                              child: Text('วันเริ่มต้น'),
                            ),
                            const SizedBox(width: 20.0),
                            Expanded(
                              child: GestureDetector(
                                onTap: () async {
                                  await showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Column(
                                        children: [
                                          const Padding(
                                            padding: EdgeInsets.all(16.0),
                                            child: Center(
                                              child: Text(
                                                'เลือกวันเริ่มต้น',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            child: ListView.separated(
                                              itemCount: _dateOfMonth.length,
                                              itemBuilder:
                                                  (itemContext, index) {
                                                return ListTile(
                                                  onTap: () {
                                                    setState(() {
                                                      _startDate =
                                                          _dateOfMonth[index];
                                                    });
                                                    Navigator.pop(context);
                                                  },
                                                  title: Row(
                                                    children: [
                                                      Text(
                                                        _dateOfMonth[index]
                                                            .toString(),
                                                      )
                                                    ],
                                                  ),
                                                );
                                              },
                                              separatorBuilder:
                                                  (context, index) {
                                                return const Divider(
                                                    height: 1.0);
                                              },
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                  setState(() {});
                                },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(_startDate.toString()),
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

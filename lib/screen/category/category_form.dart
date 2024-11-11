import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/category_type_model.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/service/category_type_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

enum CategoryFormMode { create, edit }

class CategoryFormScreen extends StatefulWidget {
  final CategoryFormMode mode;
  final int? categoryId;

  const CategoryFormScreen({
    super.key,
    required this.mode,
    this.categoryId,
  });

  @override
  State<CategoryFormScreen> createState() => CategoryFormScreenState();
}

class CategoryFormScreenState extends State<CategoryFormScreen> {
  final _categoryService = CategoryService();
  final _categoryTypeService = CategoryTypeService();

  // state
  List<CategoryTypeModel> _categoryTypeList = [];
  final TextEditingController _nameController = TextEditingController();
  int? _categoryTypeId;
  bool _isLoading = true;

  // method
  Future _getCategoryTypeList() async {
    final res = await _categoryTypeService.getCategoryTypeList();
    setState(() {
      _categoryTypeList = res;
    });
  }

  Future _getCategoryDetail({required int categoryId}) async {
    try {
      final res =
          await _categoryService.getCategoryDetail(categoryId: categoryId);

      setState(() {
        _nameController.text = res.name ?? '';
        _categoryTypeId = res.categoryTypeId;
      });
    } catch (e) {
      Navigator.pop(context);
    }
  }

  Future _createOrUpdateCategory({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });
      bool res = false;
      if (widget.mode == CategoryFormMode.create) {
        res = await _categoryService.createCategory(
          name: _nameController.text,
          categoryTypeId: _categoryTypeId!,
        );
      } else {
        res = await _categoryService.updateCategory(
          categoryId: widget.categoryId!,
          name: _nameController.text,
          categoryTypeId: _categoryTypeId!,
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

  String _getCategoryTypeName() {
    try {
      return _categoryTypeList
          .firstWhere((element) => element.id == _categoryTypeId)
          .name
          .toString();
    } catch (e) {
      return 'เลือก';
    }
  }

  _getInitialValue() async {
    await _getCategoryTypeList();
    if (widget.mode == CategoryFormMode.edit) {
      await _getCategoryDetail(categoryId: widget.categoryId!);
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
            '${widget.mode == CategoryFormMode.create ? 'เพิ่ม' : 'แก้ไข'}หมวดหมู่',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                if (_nameController.text.isEmpty || _categoryTypeId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                    ),
                  );
                } else {
                  await _createOrUpdateCategory(context: context);
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
                                              itemBuilder:
                                                  (itemContext, index) {
                                                return ListTile(
                                                  title: Text(
                                                      _categoryTypeList[index]
                                                          .name!),
                                                  onTap: () {
                                                    Navigator.pop(context);
                                                    setState(() {
                                                      _categoryTypeId =
                                                          _categoryTypeList[
                                                                  index]
                                                              .id;
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
                                                  _categoryTypeList.length,
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
                                    Text(_getCategoryTypeName()),
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

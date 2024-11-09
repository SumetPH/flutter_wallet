import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/category_type_model.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/service/category_type_service.dart';

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
  bool _isLoading = false;

  // method
  Future _getCategoryTypeList() async {
    final res = await _categoryTypeService.getCategoryTypeList();
    setState(() {
      _categoryTypeList = res;
    });
  }

  Future _getCategoryDetail({required int categoryId}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final res =
          await _categoryService.getCategoryDetail(categoryId: categoryId);

      setState(() {
        _isLoading = false;
        _nameController.text = res.name ?? '';
        _categoryTypeId = res.categoryTypeId;
      });

      await _getCategoryTypeList();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });

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

  @override
  void initState() {
    super.initState();
    if (widget.mode == CategoryFormMode.edit) {
      _getCategoryDetail(categoryId: widget.categoryId!);
    } else {
      _getCategoryTypeList();
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
                            if (_nameController.text.isEmpty ||
                                _categoryTypeId == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('กรุณากรอกข้อมูลให้ครบถ้วน'),
                                ),
                              );
                            } else {
                              await _createOrUpdateCategory(context: context);
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
                                            itemBuilder: (itemContext, index) {
                                              return ListTile(
                                                title: Text(
                                                    _categoryTypeList[index]
                                                        .name!),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  setState(() {
                                                    _categoryTypeId =
                                                        _categoryTypeList[index]
                                                            .id;
                                                  });
                                                },
                                              );
                                            },
                                            separatorBuilder: (context, index) {
                                              return const Divider(height: 1.0);
                                            },
                                            itemCount: _categoryTypeList.length,
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
    );
  }
}

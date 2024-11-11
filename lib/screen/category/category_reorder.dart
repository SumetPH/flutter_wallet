import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/category_model.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class CategoryReorder extends StatefulWidget {
  final int categoryTypeId;

  const CategoryReorder({
    super.key,
    required this.categoryTypeId,
  });

  @override
  State<CategoryReorder> createState() => _CategoryReorderState();
}

class _CategoryReorderState extends State<CategoryReorder> {
  // service
  final _categoryService = CategoryService();

// state
  List<CategoryModel> _categoryList = [];
  bool _isLoading = true;

  Future _getCategoryList() async {
    try {
      final res = await _categoryService.getCategoryList(
        categoryTypeId: widget.categoryTypeId,
      );
      setState(() {
        _categoryList = res;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future _updateOrder({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Map<String, dynamic>> list = [];
      _categoryList.forEach((element) {
        list.add({
          'categoryId': element.id,
          'order': _categoryList.indexOf(element),
        });
      });

      final res = await _categoryService.orderCategory(list: list);

      setState(() {
        _isLoading = false;
      });

      if (res) {
        Navigator.pop(context);
      } else {
        throw Exception('ทํารายการไม่สําเร็จ');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('ทํารายการไม่สําเร็จ'),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _getCategoryList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidth(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'จัดเรียงหมวดหมู่',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.check),
              onPressed: () async {
                await _updateOrder(context: context);
              },
            ),
          ],
        ),
        body: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Expanded(
                      child: ReorderableListView.builder(
                        itemCount: _categoryList.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = _categoryList.removeAt(oldIndex);
                            _categoryList.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            key: Key(_categoryList[index].id.toString()),
                            children: [
                              ListTile(
                                onTap: () {},
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${index + 1}. ${_categoryList[index].name!}'),
                                    if (!kIsWeb)
                                      const Icon(Icons.drag_indicator),
                                  ],
                                ),
                              ),
                              const Divider(height: 1.0),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

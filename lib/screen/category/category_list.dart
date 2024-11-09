import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/category/category_form.dart';
import 'package:flutter_wallet/screen/category/category_reorder.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list.dart';
import 'package:flutter_wallet/service/category_service.dart';
import 'package:flutter_wallet/utils/number_utils.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen>
    with SingleTickerProviderStateMixin {
  // service
  final _categoryService = CategoryService();

  // state
  final List<Tab> _tabs = [
    const Tab(text: 'รายจ่าย'),
    const Tab(text: 'รายรับ'),
  ];
  final List<Map<String, dynamic>> _tabsData = [
    {'categoryTypeId': 1, "title": "รายจ่าย"},
    {'categoryTypeId': 2, 'title': "รายรับ"},
  ];

  late TabController _tabController;

  // method
  Future _deleteCategory({
    required int categoryId,
    required BuildContext context,
  }) async {
    try {
      final res = await _categoryService.deleteCategory(categoryId: categoryId);
      if (res) {
        Navigator.pop(context);
        setState(() {});
      } else {
        throw Exception('ไม่สามารถลบข้อมูลได้');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ไม่สามารถลบข้อมูลได้'),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                Scaffold.of(context).openDrawer();
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.menu),
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => Column(
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'เมนู',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return const CategoryFormScreen(
                                  mode: CategoryFormMode.create,
                                );
                              },
                            ),
                          );
                          // refresh list
                          setState(() {});
                        },
                        title: const Center(
                          child: Text(
                            "เพิ่มหมวดหมู่",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const Divider(height: 1.0),
                      ListTile(
                        onTap: () async {
                          Navigator.pop(context);
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) {
                                return CategoryReorder(
                                  categoryTypeId:
                                      _tabsData[_tabController.index]
                                          ['categoryTypeId'],
                                );
                              },
                            ),
                          );
                          // refresh list
                          setState(() {});
                        },
                        title: const Center(
                          child: Text(
                            "จัดเรียงหมวดหมู่",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
              child: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.more_vert),
              ),
            ),
          ],
        ),
        TabBar(
          controller: _tabController,
          tabs: _tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: _tabsData.map((el) {
              return FutureBuilder(
                future: _categoryService.getCategoryList(
                  categoryTypeId: el['categoryTypeId'],
                ),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Text(snapshot.error.toString()),
                      ),
                    );
                  } else if (snapshot.hasData) {
                    return ListView.separated(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          behavior: HitTestBehavior.opaque,
                          onTap: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return TransactionListScreen(
                                    categoryId: [snapshot.data![index].id!],
                                    showBackButton: true,
                                  );
                                },
                              ),
                            );
                            // refresh list
                            setState(() {});
                          },
                          onLongPress: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (context) => Column(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(16.0),
                                    child: Center(
                                      child: Text(
                                        'เมนู',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  ListTile(
                                    onTap: () async {
                                      Navigator.pop(context);
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (context) {
                                          return CategoryFormScreen(
                                            mode: CategoryFormMode.edit,
                                            categoryId:
                                                snapshot.data![index].id,
                                          );
                                        }),
                                      );
                                      // refresh list
                                      setState(() {});
                                    },
                                    title: const Center(
                                      child: Text(
                                        "แก้ไขหมวดหมู่",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1.0),
                                  ListTile(
                                    onTap: () async {
                                      await showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('ลบบัญชี'),
                                            content: Text(
                                              'คุณต้องการลบหมวดหมู่ ${snapshot.data![index].name}',
                                            ),
                                            actions: [
                                              TextButton(
                                                child: const Text('ตกลง'),
                                                onPressed: () async {
                                                  await _deleteCategory(
                                                    categoryId: snapshot
                                                        .data![index].id!,
                                                    context: context,
                                                  );
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                              TextButton(
                                                child: const Text('ยกเลิก'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                    title: const Center(
                                      child: Text(
                                        "ลบหมวดหมู่",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                CircleAvatar(
                                  backgroundColor:
                                      snapshot.data![index].categoryTypeId == 1
                                          ? Colors.red[600]
                                          : Colors.green[600],
                                  child: Icon(
                                    snapshot.data![index].categoryTypeId == 1
                                        ? Icons.arrow_downward
                                        : Icons.arrow_upward,
                                    color: Colors.white,
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          snapshot.data![index].name!,
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          '${NumberUtils.formatNumber(double.parse(snapshot.data![index].amount!))} บาท',
                                          style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold,
                                            color: snapshot.data![index]
                                                        .categoryTypeId ==
                                                    1
                                                ? Colors.red[600]
                                                : Colors.green[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return const Divider(height: 1.0);
                      },
                    );
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              );
            }).toList(),
          ),
        )
      ],
    );
  }
}

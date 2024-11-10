import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/budget/budget_form.dart';
import 'package:flutter_wallet/screen/budget/budget_reorder.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list.dart';
import 'package:flutter_wallet/service/budget_service.dart';
import 'package:flutter_wallet/utils/number_utils.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  final _budgetService = BudgetService();

  Future _deleteBudget({
    required int budgetId,
    required BuildContext context,
  }) async {
    try {
      final res = await _budgetService.deleteBudget(budgetId: budgetId);
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
                                return const BudgetFormScreen(
                                  mode: BudgetFormMode.create,
                                );
                              },
                            ),
                          );
                          // refresh list
                          setState(() {});
                        },
                        title: const Center(
                          child: Text(
                            "เพิ่มงบประมาณ",
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
                                return const BudgetReorder();
                              },
                            ),
                          );
                          // refresh list
                          setState(() {});
                        },
                        title: const Center(
                          child: Text(
                            "จัดเรียงงบประมาณ",
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
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              setState(() {});
              return Future.value();
            },
            child: FutureBuilder(
              future: _budgetService.getBudgetList(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                } else if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? const Center(child: Text('ไม่พบข้อมูล'))
                      : ListView.separated(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data![index];
                            return GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) {
                                      return TransactionListScreen(
                                        showBackButton: true,
                                        categoryId: snapshot
                                            .data![index].category
                                            ?.map((el) => el.categoryId!)
                                            .toList(),
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
                                            MaterialPageRoute(
                                              builder: (context) {
                                                return BudgetFormScreen(
                                                  mode: BudgetFormMode.edit,
                                                  budgetId: data.id,
                                                );
                                              },
                                            ),
                                          );
                                          // refresh list
                                          setState(() {});
                                        },
                                        title: const Center(
                                          child: Text(
                                            "แก้ไขงบประมาณ",
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
                                                  'คุณต้องการลบงบประมาณ ${data.name}',
                                                ),
                                                actions: [
                                                  TextButton(
                                                    child: const Text('ตกลง'),
                                                    onPressed: () async {
                                                      await _deleteBudget(
                                                        budgetId: data.id!,
                                                        context: context,
                                                      );
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('ยกเลิก'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                        title: const Center(
                                          child: Text(
                                            "ลบงบประมาณ",
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
                                  // mainAxisAlignment:
                                  //     MainAxisAlignment.spaceBetween,
                                  children: [
                                    const CircleAvatar(
                                      child: Icon(Icons.category),
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
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                            Text(
                                              '${NumberUtils.formatNumber(double.parse(data.amount!))} บาท',
                                              style: const TextStyle(
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            '${NumberUtils.formatNumber(double.parse(data.balance!))} บาท',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red[600],
                                            ),
                                          ),
                                          SizedBox(
                                            width: double.infinity,
                                            child: LinearProgressIndicator(
                                              value: double.parse(
                                                      data.balance!) *
                                                  100 /
                                                  double.parse(data.amount!) /
                                                  100,
                                              backgroundColor: Colors.green,
                                              minHeight: 8.0,
                                              borderRadius:
                                                  const BorderRadius.all(
                                                Radius.circular(4.0),
                                              ),
                                              valueColor:
                                                  const AlwaysStoppedAnimation(
                                                Colors.red,
                                              ),
                                            ),
                                          ),
                                          Text(
                                            '${NumberUtils.formatNumber(double.parse(data.amount!) - double.parse(data.balance!))} บาท',
                                            style: TextStyle(
                                              fontSize: 15.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.green[600],
                                            ),
                                          ),
                                        ],
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
            ),
          ),
        )
      ],
    );
  }
}

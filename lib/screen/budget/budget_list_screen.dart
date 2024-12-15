import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/budget/budget_form.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list_screen.dart';
import 'package:flutter_wallet/service/budget_service.dart';
import 'package:flutter_wallet/utils/number_utils.dart';
import 'package:flutter_wallet/widget/menu.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class BudgetListScreen extends StatefulWidget {
  const BudgetListScreen({super.key});

  @override
  State<BudgetListScreen> createState() => _BudgetListScreenState();
}

class _BudgetListScreenState extends State<BudgetListScreen> {
  final _budgetService = BudgetService();

  Future _deleteBudget({
    required int budgetId,
  }) async {
    try {
      final res = await _budgetService.deleteBudget(budgetId: budgetId);
      if (res) {
        if (!mounted) return;
        Navigator.pop(context);
        setState(() {});
      } else {
        throw Exception('ไม่สามารถลบข้อมูลได้');
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('ไม่สามารถลบข้อมูลได้'),
      ));
    }
  }

  double _calculateProgressIndicatorValue({
    required double amount,
    required double balance,
  }) {
    if (amount == 0) {
      return 0;
    }
    return ((balance * 100) / amount) / 100;
  }

  Color? _colorAmount({
    required double amount,
    required double balance,
  }) {
    if ((amount - balance) < 0) {
      return Colors.red;
    }
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('งบประมาณ'),
        leading: IconButton(
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () async {
              budgetMenu(
                context: context,
                afterGoBack: () {
                  setState(() {});
                },
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: ResponsiveWidth(
          child: Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () {
                    setState(() {});
                    return Future.value();
                  },
                  child: FutureBuilder(
                    future: _budgetService.getBudgetList(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (snapshot.hasError) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(snapshot.error.toString()),
                          ),
                        );
                      }

                      if (snapshot.data == null || snapshot.data!.isEmpty) {
                        return const Center(child: Text("ไม่พบข้อมูล"));
                      }

                      return ListView.separated(
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
                                      hasDrawer: false,
                                      title:
                                          '${data.periodStartDate} ถึง ${data.periodEndDate}',
                                      categoryId: data.category
                                          ?.map((el) => el.categoryId!)
                                          .toList(),
                                      startDate: data.periodStartDate,
                                      endDate: data.periodEndDate,
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
                                                    final navigator =
                                                        Navigator.of(context);
                                                    await _deleteBudget(
                                                      budgetId: data.id!,
                                                    );
                                                    navigator.pop();
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
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 7,
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
                                                    overflow:
                                                        TextOverflow.ellipsis,
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
                                          flex: 5,
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
                                                  value:
                                                      _calculateProgressIndicatorValue(
                                                    amount: double.parse(
                                                      data.amount!,
                                                    ),
                                                    balance: double.parse(
                                                      data.balance!,
                                                    ),
                                                  ),
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
                                                  color: _colorAmount(
                                                    amount: double.parse(
                                                      data.amount!,
                                                    ),
                                                    balance: double.parse(
                                                      data.balance!,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
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
                    },
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

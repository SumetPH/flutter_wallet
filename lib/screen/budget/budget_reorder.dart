import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/budget_model.dart';
import 'package:flutter_wallet/service/budget_service.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';

class BudgetReorder extends StatefulWidget {
  const BudgetReorder({
    super.key,
  });

  @override
  State<BudgetReorder> createState() => BudgetReorderState();
}

class BudgetReorderState extends State<BudgetReorder> {
  // service
  final _budgetService = BudgetService();

// state
  List<BudgetModel> _budgetList = [];
  bool _isLoading = true;

  Future _getBudgetList() async {
    final res = await _budgetService.getBudgetList();
    setState(() {
      _budgetList = res;
      _isLoading = false;
    });
  }

  Future _updateOrder({required BuildContext context}) async {
    try {
      setState(() {
        _isLoading = true;
      });

      List<Map<String, dynamic>> list = [];
      for (final element in _budgetList) {
        list.add({
          'budgetId': element.id,
          'order': _budgetList.indexOf(element),
        });
      }

      final res = await _budgetService.orderBudget(list: list);

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
      _getBudgetList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveWidth(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'จัดเรียงงบประมาณ',
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
                        itemCount: _budgetList.length,
                        onReorder: (oldIndex, newIndex) {
                          setState(() {
                            if (oldIndex < newIndex) {
                              newIndex -= 1;
                            }
                            final item = _budgetList.removeAt(oldIndex);
                            _budgetList.insert(newIndex, item);
                          });
                        },
                        itemBuilder: (context, index) {
                          return Column(
                            key: Key(_budgetList[index].id.toString()),
                            children: [
                              ListTile(
                                onTap: () {},
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        '${index + 1}. ${_budgetList[index].name!}'),
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

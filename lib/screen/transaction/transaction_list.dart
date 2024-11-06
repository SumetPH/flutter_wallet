import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/transaction/transaction_form.dart';
import 'package:flutter_wallet/screen/transaction/transfer_form.dart';
import 'package:flutter_wallet/service/transaction_service.dart';
import 'package:flutter_wallet/service/transfer_service.dart';
import 'package:flutter_wallet/widget/transaction_list.dart';

class TransactionListScreen extends StatefulWidget {
  // property
  final int? accountId;

  // constructor
  const TransactionListScreen({
    super.key,
    this.accountId,
  });

  @override
  State<TransactionListScreen> createState() => TransactionListScreenState();
}

class TransactionListScreenState extends State<TransactionListScreen> {
  final _transactionService = TransactionService();
  final _transferService = TransferService();

  Future _deleteTransaction({
    required int transactionId,
    required BuildContext context,
  }) async {
    try {
      final res = await _transactionService.deleteTransaction(
        transactionId: transactionId,
      );
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

  Future _deleteTransfer({
    required int transactionId,
    required BuildContext context,
  }) async {
    try {
      final res = await _transferService.deleteTransfer(
        transactionId: transactionId,
      );
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
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (widget.accountId != null) {
                      Navigator.pop(context);
                    } else {
                      Scaffold.of(context).openDrawer();
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: widget.accountId != null
                        ? const Icon(Icons.chevron_left)
                        : const Icon(Icons.menu),
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
                                MaterialPageRoute(builder: (context) {
                                  return const TransactionFormScreen(
                                    mode: TransactionFormMode.create,
                                  );
                                }),
                              );
                              // refresh list
                              setState(() {});
                            },
                            title: const Center(
                              child: Text(
                                "เพิ่มรายการ",
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
                                MaterialPageRoute(builder: (context) {
                                  return const TransferFormScreen(
                                    mode: TransferFormMode.create,
                                  );
                                }),
                              );
                              // refresh list
                              setState(() {});
                            },
                            title: const Center(
                              child: Text(
                                "โอน",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          )
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
              child: FutureBuilder(
                future: _transactionService.getTransactionList(
                  accountId: widget.accountId,
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
                    if (snapshot.data!.isEmpty) {
                      return const Center(child: Text("ไม่พบข้อมูล"));
                    } else {
                      return TransactionList(
                        transactionList: snapshot.data ?? [],
                        onLongPress: (transaction) {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Column(
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
                                      // edit transaction
                                      if ([1, 2].contains(
                                        transaction.transactionTypeId,
                                      )) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return TransactionFormScreen(
                                              mode: TransactionFormMode.edit,
                                              transactionId: transaction.id,
                                            );
                                          }),
                                        );
                                      }
                                      if ([3].contains(
                                        transaction.transactionTypeId,
                                      )) {
                                        await Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) {
                                            return TransferFormScreen(
                                              mode: TransferFormMode.edit,
                                              transactionId: transaction.id,
                                            );
                                          }),
                                        );
                                      }
                                      // refresh list
                                      setState(() {});
                                    },
                                    title: const Center(
                                      child: Text(
                                        "แก้ไข",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const Divider(height: 1.0),
                                  ListTile(
                                    onTap: () async {
                                      // delete transaction
                                      if ([1, 2].contains(
                                        transaction.transactionTypeId,
                                      )) {
                                        await _deleteTransaction(
                                          transactionId: transaction.id!,
                                          context: context,
                                        );
                                      }
                                      // delete transfer
                                      if ([3].contains(
                                        transaction.transactionTypeId,
                                      )) {
                                        await _deleteTransfer(
                                          transactionId: transaction.id!,
                                          context: context,
                                        );
                                      }
                                    },
                                    title: const Center(
                                      child: Text(
                                        "ลบ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      );
                    }
                  } else {
                    return const Center(child: CircularProgressIndicator());
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_wallet/service/transaction_service.dart';
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
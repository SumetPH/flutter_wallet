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
  // List<TransactionModel> _transactionList = [];

  // method
  // _getTransactionList() async {
  //   final res = await _transactionService.getTransactionList(
  //     accountId: widget.accountId,
  //   );
  //   setState(() {
  //     _transactionList = res;
  //   });
  // }

  // @override
  // void initState() {
  //   super.initState();
  // }

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
                    Navigator.pop(context);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.chevron_left),
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

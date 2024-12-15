import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/transaction/debt_form.dart';
import 'package:flutter_wallet/screen/transaction/transaction_form.dart';
import 'package:flutter_wallet/service/schedule_service.dart';

class ScheduleTransactionListScreen extends StatefulWidget {
  final String title;
  final int scheduleId;

  const ScheduleTransactionListScreen({
    super.key,
    required this.title,
    required this.scheduleId,
  });

  @override
  State<ScheduleTransactionListScreen> createState() =>
      _ScheduleTransactionListScreenState();
}

class _ScheduleTransactionListScreenState
    extends State<ScheduleTransactionListScreen> {
  final _scheduleService = ScheduleService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: FutureBuilder(
          future: _scheduleService.getScheduleTransactionList(
              scheduleId: widget.scheduleId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(snapshot.error.toString()),
                ),
              );
            } else {
              return ListView.separated(
                separatorBuilder: (context, index) =>
                    const Divider(height: 8.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final item = snapshot.data![index];
                  return ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.date ?? '-'),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: item.status == 'ยังไม่จ่าย'
                                ? Colors.red[600]
                                : Colors.grey[600],
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(8.0),
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 8.0,
                              horizontal: 20.0,
                            ),
                          ),
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  if (item.transactionId == null) {
                                    if (item.transactionTypeId == 1) {
                                      return TransactionFormScreen(
                                        mode: TransactionFormMode.create,
                                        scheduleId: item.id,
                                        amount: item.amount,
                                        accountId: item.expenseAccountId,
                                        accountName: item.expenseAccountName,
                                      );
                                    } else {
                                      return DebtFormScreen(
                                        mode: DebtFormMode.create,
                                        scheduleId: item.id,
                                        amount: item.amount,
                                        accountIdFrom: item.debtAccountIdFrom,
                                        accountNameFrom:
                                            item.debtAccountNameFrom,
                                        accountIdTo: item.debtAccountIdTo,
                                        accountNameTo: item.debtAccountNameTo,
                                      );
                                    }
                                  } else {
                                    if (item.transactionTypeId == 1) {
                                      return TransactionFormScreen(
                                        mode: TransactionFormMode.edit,
                                        transactionId: item.transactionId,
                                      );
                                    } else {
                                      return DebtFormScreen(
                                        mode: DebtFormMode.edit,
                                        transactionId: item.transactionId,
                                      );
                                    }
                                  }
                                },
                              ),
                            );
                            setState(() {});
                          },
                          child: Column(
                            children: [
                              Text(
                                item.status != null
                                    ? item.status!
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        item.status!.substring(1)
                                    : '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                item.amount ?? '-',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}

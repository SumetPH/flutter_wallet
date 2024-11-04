import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:flutter_wallet/utils/number_utils.dart';
import 'package:grouped_list/grouped_list.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactionList;
  final Function(TransactionModel transaction)? onTab;
  final Function(TransactionModel transaction)? onLongPress;

  const TransactionList({
    super.key,
    required this.transactionList,
    this.onTab,
    this.onLongPress,
  });

  Color? _ColorAmount(int transactionTypeId) {
    if (transactionTypeId == 1) {
      return Colors.green[600];
    } else if (transactionTypeId == 2) {
      return Colors.red[600];
    } else {
      return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      elements: transactionList,
      groupBy: (transaction) => transaction.date,
      order: GroupedListOrder.DESC,
      separator: const Divider(
        height: 1,
      ),
      useStickyGroupSeparators: true,
      groupHeaderBuilder: (value) {
        // final sum = accountList
        //     .where((a) => a.accountTypeId == value.accountTypeId)
        //     .map((a) => a.balance!)
        //     .reduce((a, b) => a + b);
        return Container(
          color: Colors.grey[200],
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 8.0,
              horizontal: 16.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  value.date!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                // Text(
                //   '${NumberUtils.formatNumber(double.parse(sum))} บาท',
                //   style: TextStyle(
                //     fontWeight: FontWeight.bold,
                //     color: double.parse(sum) >= 0
                //         ? Colors.green[600]
                //         : Colors.red[600],
                //   ),
                // ),
              ],
            ),
          ),
        );
      },
      itemBuilder: (context, element) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          if (onTab != null) {
            onTab!(element);
          }
        },
        onLongPress: () {
          if (onLongPress != null) {
            onLongPress!(element);
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                child: Icon(Icons.wallet),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ([1, 2].contains(element.transactionTypeId))
                        Row(
                          children: [
                            Text(
                              element.transactionTypeName ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.categoryName ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      if ([3].contains(element.transactionTypeId))
                        Row(
                          children: [
                            Text(
                              element.transactionTypeName ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.accountTransferFromName ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.arrow_right_alt),
                            ),
                            Text(
                              element.accountTransferToName ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                          ],
                        ),
                      Text(
                        '${NumberUtils.formatNumber(double.parse(element.amount ?? '0'))} บาท',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: _ColorAmount(element.transactionTypeId!),
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
      ),
    );
  }
}

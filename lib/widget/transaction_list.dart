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

  Color? _colorAmount(int transactionTypeId) {
    if (transactionTypeId == 1) {
      return Colors.red[600];
    } else if (transactionTypeId == 2) {
      return Colors.green[600];
    } else {
      return Colors.black;
    }
  }

  Icon _getIcon({int? transactionTypeId}) {
    if (transactionTypeId == 1) {
      return const Icon(Icons.remove);
    } else if (transactionTypeId == 2) {
      return const Icon(Icons.add);
    } else if (transactionTypeId == 3) {
      return const Icon(Icons.sync);
    } else if (transactionTypeId == 4) {
      return const Icon(Icons.credit_score);
    } else {
      return const Icon(Icons.money);
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
              CircleAvatar(
                child: _getIcon(transactionTypeId: element.transactionTypeId),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // transaction
                      if ([1, 2].contains(element.transactionTypeId))
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              element.transactionTypeName ?? '',
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            if (element.transactionTypeId == 1)
                              Text(
                                element.expenseAccountName ?? "",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            if (element.transactionTypeId == 2)
                              Text(
                                element.incomeAccountName ?? "",
                                style: const TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.categoryName ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.time ?? "",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      // transfer
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
                              element.transferAccountNameFrom ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.arrow_right_alt),
                            ),
                            Text(
                              element.transferAccountNameTo ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.time ?? "",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      // debt
                      if ([4].contains(element.transactionTypeId))
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
                              element.debtAccountNameFrom ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4.0),
                              child: Icon(Icons.arrow_right_alt),
                            ),
                            Text(
                              element.debtAccountNameTo ?? "",
                              style: const TextStyle(
                                fontSize: 16.0,
                              ),
                            ),
                            const SizedBox(width: 8.0),
                            Text(
                              element.time ?? "",
                              style: TextStyle(color: Colors.grey[700]),
                            ),
                          ],
                        ),
                      Text(
                        '${NumberUtils.formatNumber(double.parse(element.amount ?? '0'))} บาท',
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: _colorAmount(element.transactionTypeId!),
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

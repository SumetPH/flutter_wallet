import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:flutter_wallet/utils/number_utils.dart';

class TransactionList extends StatelessWidget {
  final List<TransactionModel> transactionListGroup;
  final Function(TransactionListItem transaction)? onTab;
  final Function(TransactionListItem transaction)? onLongPress;

  const TransactionList({
    super.key,
    required this.transactionListGroup,
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
    double screenWidth = MediaQuery.of(context).size.width;
    double maxWidthText = screenWidth * 0.15;

    return ListView.builder(
      itemCount: transactionListGroup.length,
      itemBuilder: (context, index) {
        final transactionList = transactionListGroup[index];
        return Column(
          children: [
            Container(
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
                      transactionList.day!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: transactionList.transactionList!.length,
              separatorBuilder: (context, i) => const Divider(height: 1.0),
              itemBuilder: (context, i) {
                final transaction = transactionList.transactionList![i];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (onTab != null) {
                      onTab!(transaction);
                    }
                  },
                  onLongPress: () {
                    if (onLongPress != null) {
                      onLongPress!(transaction);
                    }
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          child: _getIcon(
                            transactionTypeId: transaction.transactionTypeId,
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 12.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // transaction
                                if ([1, 2]
                                    .contains(transaction.transactionTypeId))
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        transaction.transactionTypeName ?? '',
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      if (transaction.transactionTypeId == 1)
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: maxWidthText,
                                          ),
                                          child: Text(
                                            transaction.expenseAccountName ??
                                                "",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      if (transaction.transactionTypeId == 2)
                                        Container(
                                          constraints: BoxConstraints(
                                            maxWidth: maxWidthText,
                                          ),
                                          child: Text(
                                            transaction.incomeAccountName ?? "",
                                            style: const TextStyle(
                                              fontSize: 16.0,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.categoryName ?? "",
                                          style: const TextStyle(
                                              fontSize: 16.0,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ),
                                    ],
                                  ),
                                // transfer
                                if ([3].contains(transaction.transactionTypeId))
                                  Row(
                                    children: [
                                      Text(
                                        transaction.transactionTypeName ?? "",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.transferAccountNameFrom ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(Icons.arrow_right_alt),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.transferAccountNameTo ??
                                              "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                // debt
                                if ([4].contains(transaction.transactionTypeId))
                                  Row(
                                    children: [
                                      Text(
                                        transaction.transactionTypeName ?? "",
                                        style: const TextStyle(
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.debtAccountNameFrom ?? "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 2.0),
                                        child: Icon(Icons.arrow_right_alt),
                                      ),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.debtAccountNameTo ?? "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Container(
                                        constraints: BoxConstraints(
                                          maxWidth: maxWidthText,
                                        ),
                                        child: Text(
                                          transaction.categoryName ?? "",
                                          style: const TextStyle(
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                Text(
                                  '${NumberUtils.formatNumber(double.parse(transaction.amount!))} บาท',
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _colorAmount(
                                        transaction.transactionTypeId!),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Text(
                          transaction.time ?? "",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        );
      },
    );
  }
}

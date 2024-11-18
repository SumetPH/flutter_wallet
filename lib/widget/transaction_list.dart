import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/transaction_model.dart';
import 'package:flutter_wallet/utils/number_utils.dart';
import 'package:jiffy/jiffy.dart';

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

  Color? _colorAmount({
    required BuildContext context,
    required int transactionTypeId,
  }) {
    if ([1, 4].contains(transactionTypeId)) {
      return Colors.red[600];
    } else if ([2].contains(transactionTypeId)) {
      return Colors.green[600];
    } else {
      return Theme.of(context).brightness == Brightness.light
          ? Colors.black
          : Colors.white;
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

  String _isCurrentDate({required String? date}) {
    final now = Jiffy.now().format(pattern: 'yyyy-MM-dd');
    if (now == date) {
      return '(วันนี้)';
    }
    return '';
  }

  double _sumIncome({required List<TransactionListItem> list}) {
    final sum = list
        .where((e) => [2].contains(e.transactionTypeId))
        .fold(0.00, (sum, item) => sum + double.parse(item.amount!));

    return sum;
  }

  double _sumExpense({required List<TransactionListItem> list}) {
    final sum = list
        .where((e) => [1, 4].contains(e.transactionTypeId))
        .fold(0.00, (sum, item) => sum + double.parse(item.amount!));

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: transactionListGroup.length,
      itemBuilder: (ctx, index) {
        final transactionGroup = transactionListGroup[index];
        return Column(
          children: [
            Container(
              color: Theme.of(context).colorScheme.surfaceContainer,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                  horizontal: 16.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${transactionGroup.day!} ${_isCurrentDate(date: transactionGroup.day)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Row(
                      children: [
                        if (_sumIncome(
                                list: transactionGroup.transactionList!) >
                            0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '+${NumberUtils.formatNumber(_sumIncome(list: transactionGroup.transactionList!))}',
                              style: TextStyle(color: Colors.green[600]),
                            ),
                          ),
                        if (_sumExpense(
                                list: transactionGroup.transactionList!) >
                            0)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              '-${NumberUtils.formatNumber(_sumExpense(list: transactionGroup.transactionList!))}',
                              style: TextStyle(color: Colors.red[600]),
                            ),
                          ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: transactionGroup.transactionList!.length,
              separatorBuilder: (context, i) => const Divider(height: 1.0),
              itemBuilder: (context, i) {
                final transaction = transactionGroup.transactionList![i];
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
                                        Expanded(
                                          child: Text(
                                            transaction.expenseAccountName ??
                                                "",
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      if (transaction.transactionTypeId == 2)
                                        Expanded(
                                          child: Text(
                                            transaction.incomeAccountName ?? "",
                                            style: const TextStyle(
                                              fontSize: 14.0,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        transaction.time ?? "",
                                        style: const TextStyle(fontSize: 14.0),
                                      )
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
                                      Expanded(
                                        child: LayoutBuilder(
                                            builder: (ctx, constraint) {
                                          return Row(
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      constraint.maxWidth * 0.4,
                                                ),
                                                child: Text(
                                                  transaction
                                                          .transferAccountNameFrom ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_right_alt,
                                                  size: 14.0,
                                                ),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      constraint.maxWidth * 0.4,
                                                ),
                                                child: Text(
                                                  transaction
                                                          .transferAccountNameTo ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        transaction.time ?? "",
                                        style: const TextStyle(fontSize: 14.0),
                                      )
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
                                      Expanded(
                                        child: LayoutBuilder(
                                            builder: (ctx, constraint) {
                                          return Row(
                                            children: [
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      constraint.maxWidth * 0.4,
                                                ),
                                                child: Text(
                                                  transaction
                                                          .debtAccountNameFrom ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: 4.0,
                                                ),
                                                child: Icon(
                                                  Icons.arrow_right_alt,
                                                  size: 14.0,
                                                ),
                                              ),
                                              ConstrainedBox(
                                                constraints: BoxConstraints(
                                                  maxWidth:
                                                      constraint.maxWidth * 0.4,
                                                ),
                                                child: Text(
                                                  transaction
                                                          .debtAccountNameTo ??
                                                      "",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          );
                                        }),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        transaction.time ?? "",
                                        style: const TextStyle(fontSize: 14.0),
                                      )
                                    ],
                                  ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${NumberUtils.formatNumber(double.parse(transaction.amount!))} บาท',
                                      style: TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                        color: _colorAmount(
                                          context: context,
                                          transactionTypeId:
                                              transaction.transactionTypeId!,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        transaction.note ?? '',
                                        style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8.0),
                                    Expanded(
                                      child: Text(
                                        transaction.categoryName ?? '',
                                        style: const TextStyle(
                                          fontSize: 14.0,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
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

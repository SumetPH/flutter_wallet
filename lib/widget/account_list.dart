import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/number_utils.dart';
import 'package:grouped_list/grouped_list.dart';

class AccountList extends StatelessWidget {
  final List<AccountModel> accountList;
  final Function(AccountModel account)? onTab;
  final Function(AccountModel account)? onLongPress;
  final int? disabledAccountId;

  const AccountList({
    super.key,
    required this.accountList,
    this.onTab,
    this.onLongPress,
    this.disabledAccountId,
  });

  @override
  Widget build(BuildContext context) {
    return GroupedListView(
      elements: accountList,
      groupBy: (account) => account.accountTypeId,
      separator: const Divider(
        height: 1,
      ),
      useStickyGroupSeparators: true,
      groupHeaderBuilder: (value) {
        final sum = accountList
            .where((a) => a.accountTypeId == value.accountTypeId)
            .map((a) => double.parse(a.balance!))
            .reduce((a, b) => a + b);
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
                  value.accountTypeName!,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${NumberUtils.formatNumber(sum)} บาท',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: sum >= 0 ? Colors.green[600] : Colors.red[600],
                  ),
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
        child: Container(
          color: element.id == disabledAccountId ? Colors.grey[300] : null,
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
                        Text(
                          element.name!,
                          style: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${NumberUtils.formatNumber(double.parse(element.balance!))} บาท',
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: double.parse(element.balance!) >= 0
                                ? Colors.green[600]
                                : Colors.red[600],
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
      ),
    );
  }
}

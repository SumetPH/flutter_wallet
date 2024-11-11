import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/utils/number_utils.dart';

class AccountListWidget extends StatelessWidget {
  final List<AccountModel> accountList;
  final Function(AccountList account)? onTab;
  final Function(AccountList account)? onLongPress;
  final int? disabledAccountId;

  const AccountListWidget({
    super.key,
    required this.accountList,
    this.onTab,
    this.onLongPress,
    this.disabledAccountId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: accountList.length,
      itemBuilder: (context, index) {
        final accountType = accountList[index];
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
                      accountType.name!,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${NumberUtils.formatNumber(double.parse(accountType.total!))} บาท',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: double.parse(accountType.total!) >= 0
                            ? Colors.green[600]
                            : Colors.red[600],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ListView.separated(
              shrinkWrap: true,
              primary: false,
              itemCount: accountType.accountList!.length,
              separatorBuilder: (context, i) => const Divider(height: 1.0),
              itemBuilder: (context, i) {
                final account = accountType.accountList![i];
                return GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    if (onTab != null) {
                      onTab!(account);
                    }
                  },
                  onLongPress: () {
                    if (onLongPress != null) {
                      onLongPress!(account);
                    }
                  },
                  child: Container(
                    color: account.id == disabledAccountId
                        ? Colors.grey[300]
                        : null,
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
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    account.name!,
                                    style: const TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '${NumberUtils.formatNumber(double.parse(account.balance!))} บาท',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                      color: double.parse(account.balance!) >= 0
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
                );
              },
            )
          ],
        );
      },
    );
  }
}
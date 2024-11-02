import 'package:flutter/material.dart';
import 'package:flutter_wallet/model/account_model.dart';
import 'package:flutter_wallet/type/account_type.dart';
import 'package:grouped_list/grouped_list.dart';

accountSelectModal({
  required BuildContext context,
  required List<AccountModel> accountList,
  required Function(int) onSelected,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'เลือกบัญชี',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Expanded(
          child: GroupedListView(
            elements: accountList,
            groupBy: (account) => account.type,
            separator: const Divider(
              height: 1,
            ),
            useStickyGroupSeparators: true,
            groupHeaderBuilder: (value) {
              final sum = accountList
                  .where((a) => a.type == value.type)
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
                        AccountType.getName(value.type!),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '${sum.toStringAsFixed(2)} บาท',
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
                Navigator.pop(context);
                onSelected(element.id!);
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
                            Text(
                              element.name!,
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              '${element.balance!} บาท',
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
        )
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/account/account_form.dart';
import 'package:flutter_wallet/screen/account/account_reorder.dart';
import 'package:flutter_wallet/screen/budget/budget_form.dart';
import 'package:flutter_wallet/screen/budget/budget_reorder.dart';
import 'package:flutter_wallet/screen/category/category_form.dart';
import 'package:flutter_wallet/screen/category/category_reorder.dart';
import 'package:flutter_wallet/screen/transaction/debt_form.dart';
import 'package:flutter_wallet/screen/transaction/transaction_form.dart';
import 'package:flutter_wallet/screen/transaction/transfer_form.dart';

accountMenu({required BuildContext context, required Function setState}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'เมนู',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountFormScreen(
                  mode: AccountFormMode.create,
                ),
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "เพิ่มบัญชี",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1.0),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AccountReorder(),
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "จัดเรียงบัญชี",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

transactionMenu({required BuildContext context, required Function setState}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'เมนู',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const TransactionFormScreen(
                  mode: TransactionFormMode.create,
                );
              }),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "เพิ่มรายการ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1.0),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const TransferFormScreen(
                  mode: TransferFormMode.create,
                );
              }),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "โอน",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1.0),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(builder: (context) {
                return const DebtFormScreen(
                  mode: DebtFormMode.create,
                );
              }),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "ชำระหนี้",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        )
      ],
    ),
  );
}

categoryMenu({
  required BuildContext context,
  required Function setState,
  required int categoryTypeId,
}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'เมนู',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const CategoryFormScreen(
                    mode: CategoryFormMode.create,
                  );
                },
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "เพิ่มหมวดหมู่",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1.0),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return CategoryReorder(
                    categoryTypeId: categoryTypeId,
                  );
                },
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "จัดเรียงหมวดหมู่",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

budgetMenu({required BuildContext context, required Function setState}) {
  return showModalBottomSheet(
    context: context,
    builder: (context) => Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text(
              'เมนู',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const BudgetFormScreen(
                    mode: BudgetFormMode.create,
                  );
                },
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "เพิ่มงบประมาณ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        const Divider(height: 1.0),
        ListTile(
          onTap: () async {
            Navigator.pop(context);
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) {
                  return const BudgetReorder();
                },
              ),
            );
            // refresh list
            setState(() {});
          },
          title: const Center(
            child: Text(
              "จัดเรียงงบประมาณ",
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_wallet/screen/transaction/transaction_list_screen.dart';
import 'package:flutter_wallet/service/account_service.dart';
import 'package:flutter_wallet/utils/number_utils.dart';
import 'package:flutter_wallet/widget/responsive_width_widget.dart';
import 'package:jiffy/jiffy.dart';

class AccountCreditScreen extends StatefulWidget {
  final int accountId;
  final String accountName;
  final int creditStartDate;
  const AccountCreditScreen({
    super.key,
    required this.accountId,
    required this.accountName,
    required this.creditStartDate,
  });

  @override
  State<AccountCreditScreen> createState() => _AccountCreditScreenState();
}

class _AccountCreditScreenState extends State<AccountCreditScreen> {
  // service
  final _accountService = AccountService();

  // method
  Color? _colorBalanceBG({required double balance}) {
    if (balance < 0) {
      return Colors.red[600];
    } else if (balance > 0) {
      return Colors.green[600];
    } else {
      return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.accountName),
      ),
      body: SafeArea(
        child: ResponsiveWidth(
          child: FutureBuilder(
              future: _accountService.getAccountCredit(
                  accountId: widget.accountId,
                  creditStartDate: widget.creditStartDate),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(snapshot.error.toString()),
                    ),
                  );
                }

                if (snapshot.data == null || snapshot.data!.isEmpty) {
                  return const Center(child: Text("ไม่พบข้อมูล"));
                }

                return ListView.separated(
                  itemCount: snapshot.data!.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      height: 1.0,
                    );
                  },
                  itemBuilder: (context, index) {
                    final accountCredit = snapshot.data![index];
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TransactionListScreen(
                              hasDrawer: false,
                              title: widget.accountName,
                              accountId: widget.accountId,
                              startDate: Jiffy.parse(
                                accountCredit.startDate!,
                                pattern: 'dd/MM/yyyy',
                              ).format(pattern: 'yyyy-MM-dd'),
                              endDate: Jiffy.parse(
                                accountCredit.endDate!,
                                pattern: 'dd/MM/yyyy',
                              ).format(pattern: 'yyyy-MM-dd'),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12.0,
                                    vertical: 4.0,
                                  ),
                                  decoration: BoxDecoration(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(16.0)),
                                    color: _colorBalanceBG(
                                        balance: double.parse(
                                            accountCredit.balance ?? '0')),
                                  ),
                                  child: Text(
                                    '${NumberUtils.formatNumber(
                                      double.parse(accountCredit.balance!),
                                    )} บาท',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12.0),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                color: Theme.of(context)
                                    .colorScheme
                                    .surfaceContainer,
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16.0,
                                vertical: 8.0,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Text(
                                    '${accountCredit.startDate ?? ''} - ${accountCredit.endDate ?? ''}',
                                    textAlign: TextAlign.center,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${NumberUtils.formatNumber(double.parse(accountCredit.expense ?? '0'))} บาท',
                                        style: TextStyle(
                                          color: Colors.red[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                      const SizedBox(width: 8.0),
                                      Text(
                                        '+${NumberUtils.formatNumber(double.parse(accountCredit.income ?? '0'))} บาท',
                                        style: TextStyle(
                                          color: Colors.green[600],
                                          fontWeight: FontWeight.bold,
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_wallet/service/account_service.dart';

class AccountCreditScreen extends StatefulWidget {
  final int accountId;
  final int creditStartDate;
  const AccountCreditScreen({
    super.key,
    required this.accountId,
    required this.creditStartDate,
  });

  @override
  State<AccountCreditScreen> createState() => _AccountCreditScreenState();
}

class _AccountCreditScreenState extends State<AccountCreditScreen> {
  // service
  final _accountService = AccountService();

  // method
  _getAccountCredit() async {
    final res = await _accountService.getAccountCredit(
      accountId: widget.accountId,
      creditStartDate: widget.creditStartDate,
    );
    print(res);
  }

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _getAccountCredit();
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

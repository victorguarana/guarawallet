import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';
import 'package:guarawallet/models/account.dart';

class AccountWidget extends StatelessWidget {
  final Account account;

  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(account.name),
              Text('Saldo esp.:', style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
          Column(
            children: [
              RealText(value: account.currentBalance),
              RealText(
                value: account.expectedBalance,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}

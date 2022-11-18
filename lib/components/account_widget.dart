import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';
import 'package:guarawallet/models/account.dart';

class AccountWidget extends StatelessWidget {
  final Account account;

  const AccountWidget({super.key, required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                Text(account.name),
                Text('Saldo esp.:',
                    style: Theme.of(context).textTheme.bodySmall),
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
      ),
      const Divider(color: Colors.grey, thickness: 1),
    ]);
  }
}

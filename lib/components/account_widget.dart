import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';

class AccountWidget extends StatelessWidget {
  final int? id;
  final String name;
  final double currentBalance;
  final double expectedBalance;

  const AccountWidget(
      {super.key,
      this.id,
      required this.name,
      required this.currentBalance,
      required this.expectedBalance});

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
                Text(name),
                Text('Saldo esp.:',
                    style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Column(
              children: [
                RealText(value: currentBalance),
                RealText(
                  value: expectedBalance,
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

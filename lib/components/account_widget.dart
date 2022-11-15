import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';

class AccountWidget extends StatelessWidget {
  final String name;
  final double currentBalance;
  final double expectedBalance;

  const AccountWidget(
      {super.key,
      required this.name,
      required this.currentBalance,
      required this.expectedBalance});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(name),
              Text('Saldo esp.:', style: Theme.of(context).textTheme.bodySmall),
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
    );
  }
}

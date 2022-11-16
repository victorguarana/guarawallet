import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';

// TODO: Add Account and others fields to this widget
class TransactionWidget extends StatelessWidget {
  final String name;
  final double value;
  final String account;
  const TransactionWidget(
      {super.key,
      required this.name,
      required this.value,
      required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(name),
              RealText(value: value),
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }
}

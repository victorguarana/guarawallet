import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';

// TODO: Add Account and others fields to this widget
class TransactionWidget extends StatelessWidget {
  final int? id;
  final String name;
  final double value;
  final String account;
  const TransactionWidget(
      {super.key,
      this.id,
      required this.name,
      required this.value,
      required this.account});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(name),
                  RealText(value: value),
                ],
              ),
              Row(children: [
                Text(
                  account,
                  style: Theme.of(context).textTheme.bodySmall,
                )
              ])
            ],
          ),
        ),
        const Divider(color: Colors.grey, thickness: 1),
      ],
    );
  }
}

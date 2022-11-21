import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';
import 'package:guarawallet/models/bank_transaction.dart';

// TODO: Add Account and others fields to this widget
class TransactionWidget extends StatelessWidget {
  final BankTransaction transaction;
  const TransactionWidget({super.key, required this.transaction});

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
                  Text(transaction.name),
                  RealText(value: transaction.value),
                ],
              ),
              Row(children: [
                Text(
                  transaction.account,
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

import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';
import 'package:guarawallet/models/bank_transaction.dart';

class BankTransactionWidget extends StatelessWidget {
  final BankTransaction transaction;
  const BankTransactionWidget({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: transaction.alreadyPaid
                  ? const Icon(
                      Icons.attach_money,
                      size: 20,
                      color: Colors.green,
                    )
                  : const Icon(
                      Icons.money_off,
                      size: 20,
                      color: Colors.orange,
                    ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(transaction.name),
                Text(
                  transaction.account,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ]),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              RealText(value: transaction.value, changeColor: true),
              Text(
                transaction.payDayFormatted(),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}

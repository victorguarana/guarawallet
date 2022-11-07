import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      cardContent: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Transações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(color: Colors.grey, thickness: 1),
            const TransactionWidget(name: 'Mercado', value: 100),
            const Divider(color: Colors.grey, thickness: 1),
            const TransactionWidget(name: 'Padaria', value: 50),
            const Divider(color: Colors.grey, thickness: 1),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/components/basic_card.dart';

class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
        cardContent: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Contas', style: Theme.of(context).textTheme.titleMedium),
          const Divider(color: Colors.grey, thickness: 1),
          const AccountWidget(
              name: 'Itau', currentBalance: 1000.00, expectedBalance: 200),
          const Divider(color: Colors.grey, thickness: 1),
          const AccountWidget(
              name: 'Nubank', currentBalance: 1500.00, expectedBalance: 300),
          const Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    ));
  }
}

import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/components/real_text.dart';

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
          const _Account(name: 'Itau', balance: 1000.00, expected: 200),
          const Divider(color: Colors.grey, thickness: 1),
          const _Account(name: 'Nubank', balance: 1500.00, expected: 300),
          const Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    ));
  }
}

class _Account extends StatelessWidget {
  final String name;
  final double balance;
  final double expected;

  const _Account(
      {required this.name, required this.balance, required this.expected});

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
              RealText(value: balance),
              RealText(
                value: expected,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          )
        ],
      ),
    );
  }
}

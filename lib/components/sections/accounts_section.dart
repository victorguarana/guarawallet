import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';

class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
        cardContent: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: const [
          Text(
            'Contas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          _Divider(),
          Account(name: 'Itau', balance: 1000.00, expected: 200),
          _Divider(),
          Account(name: 'Nubank', balance: 1500.00, expected: 300),
          _Divider(),
        ],
      ),
    ));
  }
}

class Account extends StatelessWidget {
  final String name;
  final double balance;
  final double expected;

  const Account(
      {super.key,
      required this.name,
      required this.balance,
      required this.expected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Text(
                'Saldo esp.:',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'R\$ $balance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ $expected',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w300,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: Divider(
        color: Colors.grey,
        height: 2,
        thickness: 2,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';

class GoalsSection extends StatelessWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
        cardContent: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: const [
          Text(
            'Metas',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Divider(color: Colors.grey, thickness: 1),
          _Goal(name: 'Viagem', balance: 100, missing: 200, expected: 300),
          Divider(color: Colors.grey, thickness: 1),
          _Goal(
              name: 'Casamento', balance: 3500, missing: 1500, expected: 5000),
          Divider(color: Colors.grey, thickness: 1),
        ],
      ),
    ));
  }
}

class _Goal extends StatelessWidget {
  final String name;
  final double balance;
  final double expected;
  final double missing;

  const _Goal(
      {required this.name,
      required this.balance,
      required this.expected,
      required this.missing});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'R\$ $balance',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 5, bottom: 5),
            child: Container(
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
              ),
              child: LinearProgressIndicator(
                minHeight: 6,
                value: balance / expected,
                backgroundColor: Colors.grey,
                color: Colors.green,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  const Text(
                    'Faltam:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  Text(
                    'R\$ $missing',
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  const Text(
                    'Expectativa:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
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
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/components/real_text.dart';

class GoalsSection extends StatelessWidget {
  const GoalsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
        cardContent: Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          Text('Metas', style: Theme.of(context).textTheme.titleMedium),
          const Divider(color: Colors.grey, thickness: 1),
          const _Goal(
              name: 'Viagem', balance: 100, missing: 200, expected: 300),
          const Divider(color: Colors.grey, thickness: 1),
          const _Goal(
              name: 'Casamento', balance: 3500, missing: 1500, expected: 5000),
          const Divider(color: Colors.grey, thickness: 1),
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
              ),
              RealText(
                value: balance,
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
                  RealText(
                      value: missing,
                      style: Theme.of(context).textTheme.bodySmall),
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
                  RealText(
                    value: expected,
                    style: Theme.of(context).textTheme.bodySmall,
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

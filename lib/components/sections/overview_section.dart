import 'package:flutter/material.dart';

class OverviewSection extends StatelessWidget {
  const OverviewSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius:
              const BorderRadius.vertical(bottom: Radius.circular(25))),
      child: const Padding(
        padding: EdgeInsets.fromLTRB(25, 60, 25, 30),
        child: SummaryWidget(),
      ),
    );
  }
}

class SummaryWidget extends StatelessWidget {
  const SummaryWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: const [
          Text(
            'Saldo Geral:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Text(
            'R\$ 2500,00',
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ],
      ),
      Column(
        children: const [
          Text(
            'Saldo Esperado:',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
          Text(
            'R\$ 500,00',
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    ]);
  }
}

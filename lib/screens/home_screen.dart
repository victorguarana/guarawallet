import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarawallet/components/sections/accounts_section.dart';
import 'package:guarawallet/components/sections/goals_section.dart';
import 'package:guarawallet/components/sections/overview_section.dart';
import 'package:guarawallet/components/sections/transactions_section.dart';
import 'package:guarawallet/screens/transaction_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: OverviewSection(),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(bottom: 120),
              children: const [
                AccountsSection(),
                TransactionsSection(),
                GoalsSection(),
              ],
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        animatedIcon: AnimatedIcons.menu_close,
        spacing: 10,
        children: [
          SpeedDialChild(
            label: 'Adicionar transação',
            child: const Icon(Icons.note_add),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (contextNew) => const TransactionFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

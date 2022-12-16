import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarawallet/components/sections/accounts_section.dart';
import 'package:guarawallet/components/sections/overview_section.dart';
import 'package:guarawallet/components/sections/bank_transactions_section.dart';
import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/bank_transaction_dao.dart';
import 'package:guarawallet/screens/account_form_screen.dart';
import 'package:guarawallet/screens/bank_transaction_form_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const OverviewSection(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 10, bottom: 120),
              children: const [
                AccountsSection(),
                BankTransactionsSection(),
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
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Adicionar saída',
            child: Icon(Icons.swap_horiz, color: Colors.red[400]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const BankTransactionFormScreen(isDebit: true),
                ),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Adicionar entrada',
            child: Icon(Icons.swap_horiz, color: Colors.green[400]),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const BankTransactionFormScreen(isDebit: false),
                ),
              );
            },
          ),
          SpeedDialChild(
            backgroundColor: Theme.of(context).primaryColor,
            label: 'Adicionar conta',
            child: const Icon(Icons.account_balance),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AccountFormScreen(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:guarawallet/components/sections/accounts_section.dart';
import 'package:guarawallet/components/sections/goals_section.dart';
import 'package:guarawallet/components/sections/overview_section.dart';
import 'package:guarawallet/components/sections/transactions_section.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/account_form_screen.dart';
import 'package:guarawallet/screens/transaction_form_screen.dart';

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
                TransactionsSection(),
                // GoalsSection(),
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
            child: const Icon(Icons.swap_horiz),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TransactionFormScreen(),
                ),
              );
            },
          ),
          SpeedDialChild(
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
          SpeedDialChild(
            label: 'Limpar transações (Sem refresh)',
            child: const Icon(Icons.clear_all),
            onTap: () {
              BankTransactionsRepository().deleteAll();
            },
          ),
          SpeedDialChild(
            label: 'Limpar Contas (Sem refresh)',
            child: const Icon(Icons.clear_all),
            onTap: () {
              AccountsRepository().deleteAll();
            },
          ),
        ],
      ),
    );
  }
}

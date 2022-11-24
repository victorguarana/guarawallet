import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/account_form_screen.dart';
import 'package:provider/provider.dart';

class AccountsListScreen extends StatefulWidget {
  const AccountsListScreen({super.key});

  @override
  State<AccountsListScreen> createState() => _AccountsListScreenState();
}

class _AccountsListScreenState extends State<AccountsListScreen> {
  late BankTransactionsRepository bankTransactionsRepository;

  @override
  Widget build(BuildContext context) {
    bankTransactionsRepository = context.watch<BankTransactionsRepository>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contas'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Consumer<AccountsRepository>(
        builder: (context, accounts, child) {
          if (accounts.allAccounts.isEmpty) {
            return const _NoAccounts();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              itemCount: accounts.allAccounts.length,
              itemBuilder: (context, index) {
                Account account = accounts.allAccounts[index];
                return Dismissible(
                    key: UniqueKey(),
                    background: Container(
                      alignment: Alignment.centerRight,
                      color: Colors.red,
                      child: const Padding(
                        padding: EdgeInsets.only(right: 15),
                        child: Icon(Icons.delete),
                      ),
                    ),
                    onDismissed: (direction) {
                      print('WIP');
                    },
                    child: Column(
                      children: [
                        const ListCardDivider(),
                        AccountWidget(account: account),
                        const ListCardDivider()
                      ],
                    ));
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountFormScreen(),
            ),
          );
        },
      ),
    );
  }
}

class _NoAccounts extends StatelessWidget {
  const _NoAccounts();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.no_accounts,
            size: 68,
          ),
          Text(
            'Não existem contas cadastradas.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

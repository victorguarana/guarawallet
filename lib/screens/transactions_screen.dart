import 'package:flutter/material.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transctions_repository.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  @override
  Widget build(BuildContext context) {
    bankTransactionsRepository = context.watch<BankTransactionsRepository>();
    accountsRepository = context.watch<AccountsRepository>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transações'),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Padding(
          padding: const EdgeInsets.all(0),
          child: Consumer<BankTransactionsRepository>(
            builder: (context, accounts, child) {
              if (accounts.allTransactions.isEmpty) {
                return Container();
              } else {
                return ListView.builder(
                  // physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
                  itemCount: accounts.allTransactions.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(accounts.allTransactions[index].id.toString()),
                      background: Container(color: Colors.red),
                      direction: DismissDirection.endToStart,
                      onDismissed: (direction) {
                        bankTransactionsRepository.delete(
                            accounts.allTransactions[index],
                            accountsRepository);
                        // setState(() {
                        //   items.removeAt(index);
                        // });
                        // Scaffold.of(context).showSnackBar(
                        //     SnackBar(content: Text("$item dismissed")));
                      },
                      child: Column(children: [
                        TransactionWidget(
                            transaction: accounts.allTransactions[index]),
                        const ListCardDivider()
                      ]),
                    );
                  },
                );
              }
            },
          )),
    );
  }
}

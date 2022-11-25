import 'package:flutter/material.dart';
import 'package:guarawallet/components/list_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/screens/transaction_form_screen.dart';
import 'package:provider/provider.dart';

class TransactionsScreen extends StatefulWidget {
  const TransactionsScreen({super.key});

  @override
  State<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  // TODO: Check if exists a better way to get accounts repository outside this class
  // (Maybe inside other repositories?)
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  @override
  Widget build(BuildContext context) {
    bankTransactionsRepository = context.watch<BankTransactionsRepository>();
    accountsRepository = context.watch<AccountsRepository>();

    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: const Text('Transações'),
      ),
      body: Consumer<BankTransactionsRepository>(
        builder: (context, transactions, child) {
          if (transactions.allTransactions.isEmpty) {
            return const _NoTransactions();
          } else {
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(10, 30, 10, 10),
              itemCount: transactions.allTransactions.length,
              itemBuilder: (context, index) {
                BankTransaction banckTransaction =
                    transactions.allTransactions[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    alignment: Alignment.centerRight,
                    color: Colors.red,
                    child: const Padding(
                      padding: EdgeInsets.only(right: 15),
                      child: Icon(Icons.delete, color: Colors.white),
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await showDialog(
                      context: context,
                      builder: ((context) {
                        return AlertDialog(
                          content: Text(
                            'Deseja deletar esta transação?',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          actions: [
                            TextButton(
                              child: const Text(
                                'Cancelar',
                                style: TextStyle(color: Colors.grey),
                              ),
                              onPressed: () => Navigator.of(context).pop(false),
                            ),
                            TextButton(
                              child: const Text(
                                'Confirmar',
                              ),
                              onPressed: () => Navigator.of(context).pop(true),
                            ),
                          ],
                        );
                      }),
                    );
                  },
                  onDismissed: (direction) {
                    bankTransactionsRepository.delete(
                        banckTransaction, accountsRepository);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.grey,
                        content: Text(
                            'Transação \'${banckTransaction.name}\' foi deletada!'),
                      ),
                    );
                  },
                  child: Column(children: [
                    const ListCardDivider(),
                    TransactionWidget(transaction: banckTransaction),
                    const ListCardDivider()
                  ]),
                );
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
              builder: (context) => const TransactionFormScreen(),
            ),
          );
        },
      ),
    );
  }
}

class _NoTransactions extends StatelessWidget {
  const _NoTransactions();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: const [
          Icon(
            Icons.swap_horiz,
            size: 68,
          ),
          Text(
            'Não existem transações.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          )
        ],
      ),
    );
  }
}

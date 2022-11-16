import 'package:flutter/material.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/data/transaction_dao.dart';

class TransactionsSection extends StatelessWidget {
  const TransactionsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      cardHeight: 230,
      cardContent: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text(
              'Transações',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Divider(color: Colors.grey, thickness: 1),
            Expanded(
              child: FutureBuilder<List<TransactionWidget>>(
                future: TransactionDao().findAll(),
                builder: (context, snapshot) {
                  List<TransactionWidget>? itens = snapshot.data;
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.grey,
                              backgroundColor: Colors.white));
                    case ConnectionState.waiting:
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.grey,
                              backgroundColor: Colors.white));
                    case ConnectionState.active:
                      return const Center(
                          child: CircularProgressIndicator(
                              color: Colors.grey,
                              backgroundColor: Colors.white));
                    case ConnectionState.done:
                      if (snapshot.hasData && itens != null) {
                        if (itens.isNotEmpty) {
                          return ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              padding: const EdgeInsets.all(0),
                              itemCount: itens.length,
                              itemBuilder: (BuildContext context, int index) {
                                final TransactionWidget transaction =
                                    itens[index];
                                return transaction;
                              });
                        }
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
                      return Center(
                          child: Column(children: const [
                        Icon(
                          Icons.error_outline,
                          size: 128,
                        ),
                        Text(
                          'Erro ao carregar comentários.',
                          style: TextStyle(fontSize: 32),
                        )
                      ]));
                    // break;
                  }
                  return const Text('Erro Desconhecido');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

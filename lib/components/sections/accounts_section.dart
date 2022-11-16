import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/components/basic_card.dart';
import 'package:guarawallet/data/account_dao.dart';

class AccountsSection extends StatelessWidget {
  const AccountsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BasicCard(
      cardHeight: 300,
      cardContent: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            Text('Contas', style: Theme.of(context).textTheme.titleMedium),
            const Divider(color: Colors.grey, thickness: 1),
            Expanded(
              child: FutureBuilder<List<AccountWidget>>(
                future: AccountDao().findAll(),
                builder: (context, snapshot) {
                  List<AccountWidget>? itens = snapshot.data;
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
                                final AccountWidget account = itens[index];
                                return account;
                              });
                        }
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: const [
                            Icon(
                              Icons.error_outline,
                              size: 68,
                            ),
                            Text(
                              'Erro ao carregar contas.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),
                            )
                          ],
                        ),
                      );
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

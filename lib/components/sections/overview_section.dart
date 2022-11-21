import 'package:flutter/material.dart';
import 'package:guarawallet/components/real_text.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:provider/provider.dart';

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
        child: _SummaryWidget(),
      ),
    );
  }
}

class _SummaryWidget extends StatefulWidget {
  const _SummaryWidget({super.key});

  @override
  State<_SummaryWidget> createState() => _SummaryWidgetState();
}

class _SummaryWidgetState extends State<_SummaryWidget> {
  late AccountsRepository accountsRepository;

  @override
  Widget build(BuildContext context) {
    accountsRepository = context.watch<AccountsRepository>();

    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Column(
        children: [
          const Text(
            'Saldo Geral:',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          Consumer<AccountsRepository>(builder: (context, accounts, child) {
            return RealText(
              value: accounts.generalCurrentBalance,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            );
          }),
        ],
      ),
      Column(
        children: [
          const Text(
            'Saldo Esperado:',
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 12),
          ),
          Consumer<AccountsRepository>(builder: (context, accounts, child) {
            return RealText(
              value: accounts.generalExpectedBalance,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            );
          }),
        ],
      ),
    ]);
  }
}

import 'package:flutter/material.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transctions_repository.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => TransactionFormScreenState();
}

class TransactionFormScreenState extends State<TransactionFormScreen> {
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  Account? _selectedAccount;

  final List<DropdownMenuItem> _accountsList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() async {
    List<Account> accounts = await AccountsRepository().findAll();
    for (Account account in accounts) {
      final DropdownMenuItem accountItem = DropdownMenuItem(
        value: account,
        child: Center(child: Text(account.name)),
      );
      setState(() {
        _accountsList.add(accountItem);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  bool fieldValidator(String? field) {
    if (field != null && field.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    bankTransactionsRepository = context.watch<BankTransactionsRepository>();
    accountsRepository = context.watch<AccountsRepository>();

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Transação'),
          backgroundColor: Theme.of(context).primaryColor,
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (fieldValidator(value)) {
                      return 'Insira o nome da Transação';
                    }
                    return null;
                  },
                  controller: nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    hintText: 'Nome',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (fieldValidator(value)) {
                      return 'Insira o valor da Transação';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: valueController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    hintText: 'Valor',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  validator: (value) {
                    if (value == null) {
                      return 'Insira a conta da Transação';
                    }
                    return null;
                  },
                  onChanged: (value) {
                    _selectedAccount = value;
                  },
                  items: _accountsList,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_balance),
                    hintText: 'Conta',
                    filled: true,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    bankTransactionsRepository.save(
                        BankTransaction(
                          name: nameController.text,
                          value: double.parse(valueController.text),
                          account: _selectedAccount!.name,
                          createdWhen: DateTime.now(),
                        ),
                        accountsRepository);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Criando uma nova Transação'),
                      ),
                    );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Adicionar!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

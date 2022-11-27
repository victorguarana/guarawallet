import 'package:flutter/material.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/utils/util.dart';
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
        child: Text(account.name),
      );
      setState(() {
        _accountsList.add(accountItem);
      });
    }
  }

  final _formKey = GlobalKey<FormState>();

  bool _fieldValidator(String? field) {
    if (field != null && field.isEmpty) {
      return true;
    }
    return false;
  }

  bool _zeroValidator(String? value) {
    double? valueDouble = double.tryParse(value!);
    if (valueDouble == null || valueDouble == 0) return true;

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
        ),
        body: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (_fieldValidator(value)) {
                      return 'Insira o nome da Transação';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.text_snippet),
                    hintText: 'Nome',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (_fieldValidator(value)) {
                      return 'Insira o valor da Transação';
                    } else if (_zeroValidator(value)) {
                      return 'Transação não pode ter valor 0';
                    }
                    return null;
                  },
                  onChanged: (string) {
                    string = Util.formatCurrency(string);
                    valueController.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(offset: string.length),
                    );
                  },
                  keyboardType: TextInputType.number,
                  controller: valueController,
                  decoration: InputDecoration(
                    prefixText: Util.currency,
                    icon: const Icon(Icons.attach_money),
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
                          value: double.parse(
                              Util.formatDoubleToParse(valueController.text)),
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

import 'package:flutter/material.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/data/transaction_dao.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => TransactionFormScreenState();
}

class TransactionFormScreenState extends State<TransactionFormScreen> {
  String _selectedAccount = '';

  final List<DropdownMenuItem> _accountsList = [];

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() async {
    List<DropdownMenuItem> menuItemList = await AccountDao().findAllNames();
    for (DropdownMenuItem menuItem in menuItemList) {
      setState(() {
        _accountsList.add(menuItem);
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
                    TransactionDao().save(TransactionWidget(
                      name: nameController.text,
                      value: double.parse(valueController.text),
                      account: _selectedAccount!,
                    ));
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

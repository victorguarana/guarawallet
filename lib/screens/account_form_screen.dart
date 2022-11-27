import 'package:flutter/material.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/utils/util.dart';
import 'package:provider/provider.dart';

class AccountFormScreen extends StatefulWidget {
  const AccountFormScreen({super.key});

  @override
  State<AccountFormScreen> createState() => AccountFormScreenState();
}

class AccountFormScreenState extends State<AccountFormScreen> {
  late AccountsRepository accountsRepository;

  TextEditingController nameController = TextEditingController();
  TextEditingController currentBalanceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool fieldValidator(String? name) {
    if (name != null && name.isEmpty) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    accountsRepository = context.watch<AccountsRepository>();

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Conta'),
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
                      return 'Insira o nome da Conta';
                    }
                    return null;
                  },
                  controller: nameController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Nome da conta',
                    filled: true,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  validator: (String? value) {
                    if (fieldValidator(value)) {
                      return 'Insira o saldo da Conta';
                    }
                    return null;
                  },
                  onChanged: (string) {
                    string = Util.formatCurrency(string);
                    currentBalanceController.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(offset: string.length),
                    );
                  },
                  keyboardType: TextInputType.number,
                  controller: currentBalanceController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixText: Util.currency,
                    icon: const Icon(Icons.attach_money),
                    hintText: 'Saldo Atual',
                    filled: true,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    accountsRepository.save(Account(
                      name: nameController.text,
                      currentBalance:
                          double.parse(currentBalanceController.text),
                      expectedBalance:
                          double.parse(currentBalanceController.text),
                    ));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Criando uma nova Conta'),
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

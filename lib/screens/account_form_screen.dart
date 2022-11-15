import 'package:flutter/material.dart';
import 'package:guarawallet/components/account_widget.dart';
import 'package:guarawallet/data/account_dao.dart';

class AccountFormScreen extends StatefulWidget {
  const AccountFormScreen({super.key});

  @override
  State<AccountFormScreen> createState() => AccountFormScreenState();
}

class AccountFormScreenState extends State<AccountFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController currentBalanceController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  bool nameValidator(String? name) {
    if (name != null && name.isEmpty) {
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
                    if (nameValidator(value)) {
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
                  keyboardType: TextInputType.number,
                  controller: currentBalanceController,
                  textAlign: TextAlign.center,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.attach_money),
                    hintText: 'Saldo Atual',
                    filled: true,
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    AccountDao().save(AccountWidget(
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

import 'package:flutter/material.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:intl/intl.dart';
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

// TODO: Remove letters and other chars that are not [0-9 , .]
  String _formatNumber(String value) {
    if (value.indexOf(',') != value.lastIndexOf(',')) {
      int index = value.lastIndexOf(',');
      value = value.substring(0, index) + value.substring(index + 1);
    }

    if (value.endsWith(',')) return value;

    try {
      value = value.replaceAll('.', '').replaceAll(',', '.');
      double valueDouble = double.parse(value);
      valueDouble = (valueDouble * 100).truncateToDouble() / 100;
      return NumberFormat.decimalPattern('pt_Br').format(valueDouble);
    } on FormatException {
      print('ops');
      return value;
    }
  }

  String get _currency =>
      NumberFormat.compactSimpleCurrency(locale: 'pt_Br').currencySymbol;

  final _formKey = GlobalKey<FormState>();

  bool textValidator(String? name) {
    if (name != null && name.isEmpty) {
      return true;
    }
    return false;
  }

// TODO: Use this method
  bool zeroValidator(String? value) {
    double? valueDouble = double.tryParse(value!);
    if (valueDouble == null || valueDouble == 0) return false;

    return true;
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
                    if (textValidator(value)) {
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
                    if (textValidator(value)) {
                      return 'Insira o saldo da Conta';
                    }
                    // else if (zeroValidator(value)) {
                    //   return 'Valor não pode ser 0';
                    // }
                    return null;
                  },
                  onChanged: (string) {
                    // double value = double.parse(string.replaceAll('.', ''));
                    string = _formatNumber(string);
                    currentBalanceController.value = TextEditingValue(
                      text: string,
                      selection: TextSelection.collapsed(offset: string.length),
                    );
                  },
                  keyboardType: TextInputType.number,
                  controller: currentBalanceController,
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    prefixText: _currency,
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

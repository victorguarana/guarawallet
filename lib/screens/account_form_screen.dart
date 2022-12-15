import 'package:flutter/material.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_manager.dart';
import 'package:guarawallet/themes/theme_colors.dart';
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

  void _renderResult(bool success) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Conta criada com sucesso!'),
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao criar Conta'),
          backgroundColor: ThemeColors.scaffoldMessengerColor,
        ),
      );
    }
  }

  bool fieldValidator(String? name) {
    if (name != null && name.isEmpty) {
      return true;
    }
    return false;
  }

  bool accountNameValidator(String? name) {
    return accountsRepository.allAccounts
        .any((account) => account.name.toLowerCase() == name!.toLowerCase());
  }

  @override
  Widget build(BuildContext context) {
    accountsRepository = context.watch<AccountsRepository>();

    return Form(
      key: _formKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Nova Conta'),
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
                    if (accountNameValidator(value)) {
                      return 'Já existe uma Conta com este nome';
                    }
                    return null;
                  },
                  controller: nameController,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.account_box),
                    hintText: 'Nome da conta',
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
                  decoration: InputDecoration(
                    prefixText: Util.currency,
                    icon: const Icon(Icons.attach_money),
                    hintText: 'Saldo Atual',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    Account account = Account(
                      name: nameController.text,
                      currentBalance: double.parse(Util.formatDoubleToParse(
                          currentBalanceController.text)),
                      expectedBalance: double.parse(Util.formatDoubleToParse(
                          currentBalanceController.text)),
                    );
                    bool success = await BankManager.createAccount(
                        account, accountsRepository);
                    _renderResult(success);
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

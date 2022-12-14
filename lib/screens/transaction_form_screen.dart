import 'package:flutter/material.dart';
import 'package:guarawallet/data/account_dao.dart';
import 'package:guarawallet/models/account.dart';
import 'package:guarawallet/models/bank_transaction.dart';
import 'package:guarawallet/repositories/accounts_repository.dart';
import 'package:guarawallet/repositories/bank_manager.dart';
import 'package:guarawallet/repositories/bank_transactions_repository.dart';
import 'package:guarawallet/themes/theme_colors.dart';
import 'package:guarawallet/utils/util.dart';
import 'package:provider/provider.dart';

class TransactionFormScreen extends StatefulWidget {
  final bool isDebit;
  const TransactionFormScreen({super.key, required this.isDebit});

  @override
  State<TransactionFormScreen> createState() => TransactionFormScreenState();
}

class TransactionFormScreenState extends State<TransactionFormScreen> {
  late BankTransactionsRepository bankTransactionsRepository;
  late AccountsRepository accountsRepository;

  String? _selectedAccount;
  bool _alreadyPaid = true;
  DateTime? _payDay = DateTime.now();

  final List<DropdownMenuItem> _accountsList = [];
  final _formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();
  TextEditingController dateController =
      TextEditingController(text: Util.formatShow(DateTime.now()));

  @override
  void initState() {
    super.initState();
    _loadAccounts();
  }

  void _loadAccounts() async {
    List<Account> accounts = await AccountDAO.findAll();
    for (Account account in accounts) {
      final DropdownMenuItem accountItem = DropdownMenuItem(
        value: account.name,
        child: Text(account.name),
      );
      setState(() {
        _accountsList.add(accountItem);
      });
    }
  }

  void _renderResult(bool success) {
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transação criada com sucesso!')),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Erro ao salvar Transação'),
          backgroundColor: ThemeColors.scaffoldMessengerColor,
        ),
      );
    }
  }

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
          title: widget.isDebit
              ? const Text('Nova saída')
              : const Text('Nova entrada'),
          backgroundColor: widget.isDebit ? Colors.red : Colors.green,
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
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    icon: Icon(Icons.date_range),
                    hintText: 'Data de Pagamento',
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100));

                    if (pickedDate != null) {
                      String formattedDate = Util.formatShow(pickedDate);
                      setState(() {
                        _payDay = pickedDate;
                        dateController.text = formattedDate;
                      });
                    } else {
                      _payDay = null;
                      dateController.text = '';
                    }
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Checkbox(
                      onChanged: (value) {
                        setState(() {
                          _alreadyPaid = !_alreadyPaid;
                        });
                      },
                      value: _alreadyPaid,
                    ),
                    const Text('Já foi debitado?'),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    BankTransaction bankTransaction = BankTransaction(
                      payDay: _payDay,
                      alreadyPaid: _alreadyPaid,
                      name: nameController.text,
                      value: widget.isDebit
                          ? double.parse(Util.formatDoubleToParse(
                                  valueController.text)) *
                              -1
                          : double.parse(
                              Util.formatDoubleToParse(valueController.text)),
                      account: _selectedAccount!,
                    );

                    bool success = await BankManager.createTransaction(
                        bankTransaction,
                        bankTransactionsRepository,
                        accountsRepository);

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

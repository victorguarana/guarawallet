import 'package:flutter/material.dart';
import 'package:guarawallet/components/transaction_widget.dart';
import 'package:guarawallet/data/transaction_dao.dart';

class TransactionFormScreen extends StatefulWidget {
  const TransactionFormScreen({super.key});

  @override
  State<TransactionFormScreen> createState() => TransactionFormScreenState();
}

class TransactionFormScreenState extends State<TransactionFormScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController valueController = TextEditingController();

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
                    if (nameValidator(value)) {
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
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    TransactionDao().save(TransactionWidget(
                        name: nameController.text,
                        value: double.parse(valueController.text)));
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

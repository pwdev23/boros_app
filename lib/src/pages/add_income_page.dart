import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../collections/collections.dart' show Income;
import '../providers/providers.dart' show incomesProvider;
import '../utils.dart';

class AddIncomePage extends ConsumerStatefulWidget {
  static const routeName = '/add-income';

  const AddIncomePage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends ConsumerState<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const p = EdgeInsets.symmetric(horizontal: 16.0);
    const hintText = 'e.g., Freelance work, Salary';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add income'),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: p,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: const InputDecoration(
                        counterText: '', hintText: '99999'),
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: p,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: const InputDecoration(
                        counterText: '', hintText: hintText),
                    maxLength: 16,
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: _formKey.currentState != null &&
                          _formKey.currentState!.validate()
                      ? () => _onAddIncome()
                      : null,
                  child: const Text('Add income'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onAddIncome() async {
    final nav = Navigator.of(context);
    final now = DateTime.now();

    var income = Income()
      ..amount = double.parse(_amountController.text)
      ..title = _titleController.text
      ..createdAt = now;

    await addIncome(income: income)
        .then((_) => ref.invalidate(incomesProvider))
        .then((_) => nav.pop());
  }
}

class AddIncomeArgs {
  AddIncomeArgs(this.currencyCode);

  final String currencyCode;
}

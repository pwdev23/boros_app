import 'package:flutter/material.dart';

import '../collections/collections.dart' show Expense;
import '../constants.dart' show kCategorySuggestions;
import '../isar_services.dart' show addExpense;

class AddExpensePage extends StatefulWidget {
  static const routeName = '/add-expense';

  const AddExpensePage({super.key, required this.locale});

  final String locale;

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String selectedCategory = 'n/a';
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text('Choose a category', style: textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: kCategorySuggestions
                  .map((e) => ChoiceChip(
                      onSelected: (_) {
                        if ('${e['title']}' == selectedCategory) {
                          setState(() => selectedCategory = 'n/a');
                          return;
                        }
                        setState(() => selectedCategory = '${e['title']}');
                      },
                      label: Text('${e['title']}'),
                      selected: selectedCategory == '${e['title']}'))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8.0),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Amount',
                      counterText: '',
                      hintText: '99999',
                    ),
                    maxLength: 16,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid amount';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      labelText: 'Title',
                      hintText: 'e.g., Internet bill, Dinner out',
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Expense title is required';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _notesController,
                    decoration: const InputDecoration(
                      hintText: 'Bought groceries for the week',
                      labelText: 'Notes',
                    ),
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: _formKey.currentState != null &&
                            _formKey.currentState!.validate() &&
                            selectedCategory != 'n/a'
                        ? () => _onAddExpense()
                        : null,
                    child: const Text('Add expense'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddExpense() async {
    final nav = Navigator.of(context);
    final now = DateTime.now();

    var expense = Expense()
      ..amount = double.parse(_amountController.text)
      ..title = _titleController.text.trim()
      ..notes =
          _notesController.text.isEmpty ? 'n/a' : _notesController.text.trim()
      ..createdAt = now;

    await addExpense(expense: expense)
        .then((_) => nav.pushNamedAndRemoveUntil('/', (route) => false));
  }
}

class AddExpenseArgs {
  const AddExpenseArgs({required this.locale});

  final String locale;
}

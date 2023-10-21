import 'package:flutter/material.dart';

class AddExpensePage extends StatelessWidget {
  static const routeName = '/add-expense';

  const AddExpensePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add expense'),
      ),
    );
  }
}

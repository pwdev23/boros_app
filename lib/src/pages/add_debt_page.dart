import 'package:flutter/material.dart';

class AddDebtPage extends StatelessWidget {
  static const routeName = '/add-debt';

  const AddDebtPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add debt'),
      ),
    );
  }
}

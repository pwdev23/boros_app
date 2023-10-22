import 'package:flutter/material.dart';

class DebtsPage extends StatefulWidget {
  static const routeName = '/debts';

  const DebtsPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  State<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends State<DebtsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
      ),
    );
  }
}

class DebtsArgs {
  const DebtsArgs({required this.currencyCode});

  final String currencyCode;
}

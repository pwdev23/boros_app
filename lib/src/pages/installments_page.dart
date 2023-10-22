import 'package:flutter/material.dart';

class InstallmentsPage extends StatefulWidget {
  static const routeName = '/installments';

  const InstallmentsPage({super.key});

  @override
  State<InstallmentsPage> createState() => _InstallmentsPageState();
}

class _InstallmentsPageState extends State<InstallmentsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Installments'),
      ),
    );
  }
}

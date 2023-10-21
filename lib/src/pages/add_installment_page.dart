import 'package:flutter/material.dart';

class AddInstallmentPage extends StatelessWidget {
  static const routeName = '/add-installment';

  const AddInstallmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add installment'),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  static const routeName = '/home';

  const HomePage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(currencyCode),
      ),
    );
  }
}

class HomeArgs {
  const HomeArgs(this.currencyCode);

  final String currencyCode;
}

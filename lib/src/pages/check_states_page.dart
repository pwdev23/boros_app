import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_page.dart' show HomeArgs;

class CheckStatesPage extends StatefulWidget {
  static const routeName = '/';

  const CheckStatesPage({super.key});

  @override
  State<CheckStatesPage> createState() => _CheckStatesPageState();
}

class _CheckStatesPageState extends State<CheckStatesPage> {
  @override
  void initState() {
    super.initState();

    final nav = Navigator.of(context);
    _checkState(
      onCurrencyCode: (code) => nav.pushNamedAndRemoveUntil(
          '/home', (route) => false,
          arguments: HomeArgs(code)),
      onEmpty: (_) =>
          nav.pushNamedAndRemoveUntil('/currency', (route) => false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> _checkState({
    required Function(String) onCurrencyCode,
    required Function(String) onEmpty,
  }) async {
    // The delay is also utilized to wait for the database to update.
    await Future.delayed(const Duration(seconds: 3));

    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('currencyCode') == null) {
      onEmpty('');
    } else {
      onCurrencyCode(prefs.getString('currencyCode')!);
    }
  }
}

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    _checkState().then((value) {
      if (value) {
        nav.pushNamedAndRemoveUntil('/home', (route) => false);
      } else {
        nav.pushNamedAndRemoveUntil('/currency', (route) => false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<bool> _checkState() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getString('currencyCode') == null) {
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }
}

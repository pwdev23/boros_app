import 'package:flutter/material.dart';

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
    _checkState()
        .then((_) => nav.pushNamedAndRemoveUntil('/home', (route) => false));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator.adaptive(),
      ),
    );
  }

  Future<void> _checkState() async {
    await Future.delayed(const Duration(seconds: 3));
    // TODO: check a few states
  }
}

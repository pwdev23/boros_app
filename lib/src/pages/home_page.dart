import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../utils.dart' show findLang;
import 'add_income_page.dart' show AddIncomeArgs;

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  late String _lang;
  final _speedDials = ['Installment', 'Income', 'Expense', 'Debt'];

  @override
  void initState() {
    super.initState();

    _lang = findLang(widget.currencyCode);
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.simpleCurrency(locale: _lang);
    var incomes = ref.watch(incomesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.currencyCode),
      ),
      body: ListView(
        children: [
          incomes.when(
            data: (data) {
              if (data.isEmpty) {
                return Text(currency.format(0));
              }

              double? sum = data
                  .map((e) => e.amount)
                  .reduce((value, element) => value! + element!);

              return Text(currency.format(sum));
            },
            error: (error, stackTrace) => const Text('Failed to load'),
            loading: () => const Text('...'),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: _speedDials
            .map((e) => SpeedDialChild(
                  label: e,
                  onTap: () => _onSpeedDial(e),
                ))
            .toList(),
      ),
    );
  }

  void _onSpeedDial(String dial) {
    switch (dial) {
      case 'Installment':
        break;
      case 'Income':
        _onIncome();
        break;
      case 'Expense':
        break;
      case 'Debt':
        break;
      default:
    }
  }

  void _onIncome() {
    final nav = Navigator.of(context);
    final args = AddIncomeArgs(widget.currencyCode);

    nav.pushNamed('/add-income', arguments: args);
  }
}

class HomeArgs {
  const HomeArgs(this.currencyCode);

  final String currencyCode;
}

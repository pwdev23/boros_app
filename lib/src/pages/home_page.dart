import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import '../utils.dart';
import 'pages.dart';

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
    final currency = NumberFormat.currency(locale: _lang, symbol: '');
    var incomes = ref.watch(incomesProvider);
    final textTheme = Theme.of(context).textTheme;
    final nav = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Text(
            'Budget',
            style: textTheme.titleMedium,
            textAlign: TextAlign.center,
          ),
          incomes.when(
            data: (data) {
              if (data.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: null,
                      child: Text.rich(
                        TextSpan(
                          text: findSign(widget.currencyCode),
                          style: textTheme.bodySmall,
                          children: [
                            TextSpan(
                              text: '0,00',
                              style: textTheme.titleLarge,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }

              double? sum = data
                  .map((e) => e.amount)
                  .reduce((value, element) => value! + element!);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  OutlinedButton(
                    onPressed: () => nav.pushNamed('/incomes',
                        arguments:
                            IncomesArgs(currencyCode: widget.currencyCode)),
                    child: Text.rich(
                      TextSpan(
                        text: findSign(widget.currencyCode),
                        style: textTheme.bodySmall,
                        children: [
                          TextSpan(
                            text: currency.format(sum),
                            style: textTheme.titleLarge,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
            error: (_, __) => const Text('Failed to load'),
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

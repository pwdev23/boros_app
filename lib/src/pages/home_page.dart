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
  final _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _lang = findLang(widget.currencyCode);
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(locale: _lang, symbol: '');
    final compact = NumberFormat.compactCurrency(locale: _lang, symbol: '');
    var incomes = ref.watch(incomesProvider);
    var expenses = ref.watch(expensesProvider);
    var installment = ref.watch(installmentsProvider);
    var debts = ref.watch(debtsProvider);
    final textTheme = Theme.of(context).textTheme;
    final nav = Navigator.of(context);
    final dividerColor = Theme.of(context).dividerColor;
    final thisMonth = DateFormat.MMMM().format(_now);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(thisMonth),
      ),
      body: ListView(
        children: [
          incomes.when(
            data: (data) {
              final code = widget.currencyCode;
              final incomesArgs = IncomesArgs(currencyCode: code);

              if (data.isEmpty) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    OutlinedButton.icon(
                      onPressed: () => nav.pushNamed('/add-income'),
                      icon: const Icon(Icons.add),
                      label: const Text('Add income'),
                    ),
                  ],
                );
              }

              double? sum = data
                  .map((e) => e.amount)
                  .reduce((value, element) => value! + element!);

              return Stack(
                alignment: Alignment.centerRight,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: Text.rich(
                      TextSpan(
                        text: findSign(code),
                        style: textTheme.titleMedium,
                        children: [
                          TextSpan(
                            text: '${compact.format(sum)}\n',
                            style: textTheme.displayMedium,
                          ),
                          TextSpan(
                            text: '${findSign(code)}${currency.format(sum)}',
                            style: textTheme.bodySmall!
                                .copyWith(color: dividerColor),
                          ),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: IconButton.outlined(
                      onPressed: () => nav.pushNamed(
                        '/incomes',
                        arguments: incomesArgs,
                      ),
                      icon: const Icon(Icons.arrow_forward),
                    ),
                  ),
                ],
              );
            },
            error: (_, __) => const Text('Failed to load'),
            loading: () => Text.rich(
              TextSpan(
                text: findSign(widget.currencyCode),
                style: textTheme.titleMedium,
                children: [
                  TextSpan(
                    text: '${compact.format(0)}\n',
                    style: textTheme.displayMedium,
                  ),
                  TextSpan(
                    text:
                        '${findSign(widget.currencyCode)}${currency.format(0)}',
                    style: textTheme.bodySmall!.copyWith(color: dividerColor),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: [
                expenses.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return FilledButton.icon(
                        onPressed: null,
                        icon: const Text('0'),
                        label: const Text('Expenses'),
                      );
                    }

                    var length = data.length;

                    return FilledButton.icon(
                      onPressed: () => nav.pushNamed('/expenses',
                          arguments:
                              ExpensesArgs(currencyCode: widget.currencyCode)),
                      icon: Text('$length'),
                      label: const Text('Expenses'),
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const FilledButton(
                    onPressed: null,
                    child: Text('Expenses'),
                  ),
                ),
                installment.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return FilledButton.icon(
                        onPressed: null,
                        icon: const Text('0'),
                        label: const Text('Installments'),
                      );
                    }

                    var length = data.length;

                    return FilledButton.icon(
                      onPressed: () {},
                      icon: Text('$length'),
                      label: const Text('Installments'),
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const FilledButton(
                    onPressed: null,
                    child: Text('Installments'),
                  ),
                ),
                debts.when(
                  data: (data) {
                    if (data.isEmpty) {
                      return FilledButton.icon(
                        onPressed: null,
                        icon: const Text('0'),
                        label: const Text('Debts'),
                      );
                    }

                    var length = data.length;

                    return FilledButton.icon(
                      onPressed: () {},
                      icon: Text('$length'),
                      label: const Text('Debts'),
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const FilledButton(
                    onPressed: null,
                    child: Text('Debts'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 5.0,
        children: _speedDials
            .map((e) => SpeedDialChild(
                  label: e,
                  labelStyle: textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.normal,
                  ),
                  onTap: () => _onSpeedDial(e),
                  backgroundColor: e == 'Expense' ? colorScheme.primary : null,
                  foregroundColor:
                      e == 'Expense' ? colorScheme.onPrimary : null,
                  shape: const CircleBorder(),
                  child: const Icon(Icons.add),
                ))
            .toList(),
      ),
    );
  }

  void _onSpeedDial(String dial) {
    final nav = Navigator.of(context);
    final locale = Localizations.localeOf(context).toString();
    final addExpenseArgs = AddExpenseArgs(locale: locale);

    switch (dial) {
      case 'Installment':
        nav.pushNamed('/add-installment');
        break;
      case 'Income':
        nav.pushNamed('/add-income');
        break;
      case 'Expense':
        nav.pushNamed('/add-expense', arguments: addExpenseArgs);
        break;
      case 'Debt':
        nav.pushNamed('/add-debt');
        break;
      default:
        return;
    }
  }
}

class HomeArgs {
  const HomeArgs(this.currencyCode);

  final String currencyCode;
}

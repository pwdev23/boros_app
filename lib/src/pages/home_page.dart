import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart';
import 'pages.dart';

class HomePage extends ConsumerStatefulWidget {
  static const routeName = '/home';

  const HomePage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  final _speedDials = ['Installment', 'Income', 'Expense', 'Debt'];
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var expenses = ref.watch(expensesProvider);
    var installment = ref.watch(installmentsProvider);
    var debts = ref.watch(debtsProvider);
    final textTheme = Theme.of(context).textTheme;
    final nav = Navigator.of(context);
    final thisMonth = DateFormat.MMMM().format(_now);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(thisMonth),
      ),
      body: ListView(
        children: [
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
                      onPressed: () => nav.pushNamed(
                        '/expenses',
                        arguments:
                            ExpensesArgs(currencyCode: widget.currencyCode),
                      ),
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
                      onPressed: () => nav.pushNamed(
                        '/installments',
                        arguments:
                            InstallmentsArgs(currencyCode: widget.currencyCode),
                      ),
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
                      onPressed: () => nav.pushNamed(
                        '/debts',
                        arguments: DebtsArgs(currencyCode: widget.currencyCode),
                      ),
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
    const args = AddInstallmentArgs('main');

    switch (dial) {
      case 'Installment':
        nav.pushNamed('/add-installment', arguments: args);
        break;
      case 'Income':
        nav.pushNamed('/add-income');
        break;
      case 'Expense':
        nav.pushNamed('/add-expense');
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

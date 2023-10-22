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
  final _speedDials = ['Installment', 'Income', 'Expense', 'Debt'];
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var expenses = ref.watch(expensesProvider);
    var installment = ref.watch(installmentsProvider);
    var debts = ref.watch(debtsProvider);
    var incomes = ref.watch(incomesProvider);
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
              spacing: 16.0,
              runSpacing: 16.0,
              children: [
                incomes.when(
                  data: (data) {
                    var args = IncomesArgs(currencyCode: widget.currencyCode);

                    if (data.isEmpty) {
                      return _CardButton(
                        onPressed: () => nav.pushNamed(
                          '/incomes',
                          arguments: args,
                        ),
                        title: 'Incomes',
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        length: 0,
                        sum: 0,
                        currencyCode: widget.currencyCode,
                      );
                    }

                    var length = data.length;
                    var sum = data
                        .map((e) => e.amount)
                        .reduce((value, element) => value! + element!);

                    return _CardButton(
                      onPressed: () => nav.pushNamed(
                        '/incomes',
                        arguments: args,
                      ),
                      title: 'Incomes',
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      length: length,
                      sum: sum!,
                      currencyCode: widget.currencyCode,
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                expenses.when(
                  data: (data) {
                    var args = ExpensesArgs(currencyCode: widget.currencyCode);

                    if (data.isEmpty) {
                      return _CardButton(
                        onPressed: () => nav.pushNamed(
                          '/expenses',
                          arguments: args,
                        ),
                        title: 'Expenses',
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        length: 0,
                        sum: 0,
                        currencyCode: widget.currencyCode,
                      );
                    }

                    var length = data.length;
                    var sum = data
                        .map((e) => e.amount)
                        .reduce((value, element) => value! + element!);

                    return _CardButton(
                      onPressed: () => nav.pushNamed(
                        '/expenses',
                        arguments: args,
                      ),
                      title: 'Expenses',
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      length: length,
                      sum: sum!,
                      currencyCode: widget.currencyCode,
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                installment.when(
                  data: (data) {
                    var code = widget.currencyCode;
                    var args = InstallmentsArgs(currencyCode: code);

                    if (data.isEmpty) {
                      return _CardButton(
                        onPressed: () => nav.pushNamed(
                          '/installments',
                          arguments: args,
                        ),
                        title: 'Installments',
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        length: 0,
                        sum: 0,
                        currencyCode: widget.currencyCode,
                      );
                    }

                    var length = data.length;
                    var sum = data
                        .map((e) => e.amount)
                        .reduce((value, element) => value! + element!);

                    return _CardButton(
                      onPressed: () => nav.pushNamed(
                        '/installments',
                        arguments: args,
                      ),
                      title: 'Installments',
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      length: length,
                      sum: sum!,
                      currencyCode: widget.currencyCode,
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                ),
                debts.when(
                  data: (data) {
                    var code = widget.currencyCode;
                    var args = DebtsArgs(currencyCode: code);
                    if (data.isEmpty) {
                      return _CardButton(
                        onPressed: () => nav.pushNamed(
                          '/debts',
                          arguments: args,
                        ),
                        title: 'Debts',
                        backgroundColor: colorScheme.primary,
                        foregroundColor: colorScheme.onPrimary,
                        length: 0,
                        sum: 0,
                        currencyCode: widget.currencyCode,
                      );
                    }

                    var length = data.length;
                    var sum = data
                        .map((e) => e.amount)
                        .reduce((value, element) => value! + element!);

                    return _CardButton(
                      onPressed: () => nav.pushNamed(
                        '/debts',
                        arguments: args,
                      ),
                      title: 'Debts',
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      length: length,
                      sum: sum!,
                      currencyCode: widget.currencyCode,
                    );
                  },
                  error: (_, __) => const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
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
    const installmentArgs = AddInstallmentArgs('main');
    const debtArgs = AddDebtArgs('main');

    switch (dial) {
      case 'Installment':
        nav.pushNamed('/add-installment', arguments: installmentArgs);
        break;
      case 'Income':
        nav.pushNamed('/add-income');
        break;
      case 'Expense':
        nav.pushNamed('/add-expense');
        break;
      case 'Debt':
        nav.pushNamed('/add-debt', arguments: debtArgs);
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

class _CardButton extends StatelessWidget {
  const _CardButton({
    required this.onPressed,
    required this.title,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.length,
    required this.currencyCode,
    required this.sum,
  });

  final VoidCallback onPressed;
  final String title;
  final Color backgroundColor;
  final Color foregroundColor;
  final int length;
  final String currencyCode;
  final double sum;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final locale = findLang(currencyCode);
    final symbol = findSign(currencyCode);
    final currency = NumberFormat.currency(locale: locale, symbol: symbol);
    final compact = NumberFormat.compact(locale: locale);

    return Container(
      width: 155.0,
      height: 155.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                constraints: const BoxConstraints(
                  minHeight: 20.0,
                  minWidth: 20.0,
                  maxHeight: double.infinity,
                  maxWidth: double.infinity,
                ),
                margin: const EdgeInsets.only(left: 8.0, top: 8.0),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: foregroundColor,
                ),
                child: Text(
                  '$length',
                  style: TextStyle(color: backgroundColor),
                ),
              ),
            ],
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text.rich(
              TextSpan(
                text: symbol,
                style: textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.normal, color: foregroundColor),
                children: [
                  TextSpan(
                    text: '${compact.format(sum)}\n',
                    style: textTheme.displaySmall!
                        .copyWith(color: foregroundColor),
                  ),
                  TextSpan(
                    text: currency.format(sum),
                    style:
                        textTheme.bodySmall!.copyWith(color: foregroundColor),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: TextButton.icon(
              onPressed: onPressed,
              label: const Icon(Icons.arrow_forward, size: 16.0),
              style: TextButton.styleFrom(
                backgroundColor: backgroundColor,
                foregroundColor: foregroundColor,
                shadowColor: foregroundColor,
              ),
              icon: Text('\t$title'),
            ),
          ),
          const SizedBox(height: 4.0),
        ],
      ),
    );
  }
}

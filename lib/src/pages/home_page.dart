import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

import '../common.dart';
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
  final _speedDials = ['installment', 'income', 'expense', 'debt'];
  final _now = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    var expenses = ref.watch(expensesProvider);
    var installment = ref.watch(installmentsProvider);
    var debts = ref.watch(debtsProvider);
    var incomes = ref.watch(incomesProvider);
    var idleMoney = ref.watch(idleMoneyProvider);
    final textTheme = Theme.of(context).textTheme;
    final nav = Navigator.of(context);
    final thisMonth = DateFormat.MMMM().format(_now);
    final colorScheme = Theme.of(context).colorScheme;
    final currency = NumberFormat.currency(
        locale: findLang(widget.currencyCode),
        symbol: findSign(widget.currencyCode));
    final compact = NumberFormat.compact(locale: findLang(widget.currencyCode));
    final weekExpenses = ref.watch(weekExpensesProvider);
    var flTitlesData = FlTitlesData(
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 44,
          showTitles: true,
          getTitlesWidget: (v, _) => Text(
            '${findSign(widget.currencyCode)}${compact.format(v)}',
            style: textTheme.bodySmall!.copyWith(color: colorScheme.surface),
            textAlign: TextAlign.right,
          ),
        ),
      ),
      topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          reservedSize: 30,
          showTitles: true,
          getTitlesWidget: (v, _) => Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Text(
              _getDay(v.toInt()),
              style: textTheme.bodySmall!.copyWith(
                  color: v.toInt() == 0
                      ? colorScheme.onPrimary
                      : colorScheme.surface,
                  fontWeight:
                      v.toInt() == 0 ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(thisMonth),
      ),
      body: ListView(
        children: [
          idleMoney.when(
            data: (data) => Text.rich(
              TextSpan(
                text: data.isNegative
                    ? '${l10n.lackOfFunds}\n'
                    : '${l10n.idleMoney}\n',
                style: textTheme.titleSmall!.copyWith(
                    color: data.isNegative ? colorScheme.tertiary : null),
                children: [
                  TextSpan(
                    text: findSign(widget.currencyCode),
                    style: textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: '${compact.format(data)}\n',
                    style: textTheme.displayMedium,
                  ),
                  TextSpan(
                    text: currency.format(data),
                    style: textTheme.bodySmall,
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
            error: (_, __) => const SizedBox.shrink(),
            loading: () => Text.rich(
              TextSpan(
                text: '${l10n.idleMoney}\n',
                style: textTheme.titleSmall,
                children: [
                  TextSpan(
                    text: findSign(widget.currencyCode),
                    style: textTheme.bodyMedium,
                  ),
                  TextSpan(
                    text: '${compact.format(0)}\n',
                    style: textTheme.displaySmall,
                  ),
                  TextSpan(
                    text: currency.format(0),
                    style: textTheme.bodySmall,
                  )
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (weekExpenses.hasValue)
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
              child: Text(
                l10n.myExpenses,
                style: textTheme.titleMedium!
                    .copyWith(color: colorScheme.onSurface),
              ),
            ),
          weekExpenses.when(
            data: (data) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.fromLTRB(8.0, 32.0, 8.0, 8.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: colorScheme.primary,
              ),
              height: 240.0,
              child: BarChart(
                BarChartData(
                  backgroundColor: colorScheme.primary,
                  barGroups: data
                      .map((e) => BarChartGroupData(
                            x: int.parse('${e['id']}'),
                            barRods: <BarChartRodData>[
                              BarChartRodData(
                                toY: double.parse('${e['amount']}'),
                                color: colorScheme.surface,
                                borderRadius: BorderRadius.zero,
                              )
                            ],
                          ))
                      .toList(),
                  titlesData: flTitlesData,
                  borderData: FlBorderData(show: false),
                ),
                swapAnimationDuration: const Duration(milliseconds: 800),
                swapAnimationCurve: Curves.easeInOut,
              ),
            ),
            error: (error, stackTrace) => Text('$error'),
            loading: () => const SizedBox.shrink(),
          ),
          const SizedBox(height: 16.0),
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
                        title: l10n.incomes,
                        backgroundColor: colorScheme.primaryContainer,
                        foregroundColor: colorScheme.onPrimaryContainer,
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
                      title: l10n.incomes,
                      backgroundColor: colorScheme.primaryContainer,
                      foregroundColor: colorScheme.onPrimaryContainer,
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
                        title: l10n.expenses,
                        backgroundColor: colorScheme.tertiaryContainer,
                        foregroundColor: colorScheme.onTertiaryContainer,
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
                      title: l10n.expenses,
                      backgroundColor: colorScheme.tertiaryContainer,
                      foregroundColor: colorScheme.onTertiaryContainer,
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
                        title: l10n.installments,
                        backgroundColor: colorScheme.secondary,
                        foregroundColor: colorScheme.onSecondary,
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
                      title: l10n.installments,
                      backgroundColor: colorScheme.secondary,
                      foregroundColor: colorScheme.onSecondary,
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
                        title: l10n.debts,
                        backgroundColor: colorScheme.surfaceVariant,
                        foregroundColor: colorScheme.onSurfaceVariant,
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
                      title: l10n.debts,
                      backgroundColor: colorScheme.surfaceVariant,
                      foregroundColor: colorScheme.onSurfaceVariant,
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
          const SizedBox(height: kToolbarHeight),
        ],
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 5.0,
        children: _speedDials
            .map((e) => SpeedDialChild(
                  label: t(e),
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

  String t(String title) {
    final t = AppLocalizations.of(context)!;

    switch (title) {
      case 'income':
        return t.income;
      case 'installment':
        return t.installment;
      case 'expense':
        return t.expense;
      case 'debt':
        return t.debt;
      default:
        return 'n/a';
    }
  }

  String _getDay(int id) {
    final t = AppLocalizations.of(context)!;

    switch (id) {
      case 0:
        return t.sun;
      case 1:
        return t.mon;
      case 2:
        return t.tue;
      case 3:
        return t.wed;
      case 4:
        return t.thu;
      case 5:
        return t.fri;
      case 6:
        return t.sat;
      default:
        return 'n/a';
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

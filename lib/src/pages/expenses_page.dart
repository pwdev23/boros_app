import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart' show expensesProvider;
import '../utils.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  static const routeName = '/expenses';

  const ExpensesPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );
    final expenses = ref.watch(expensesProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Expenses'),
      ),
      body: expenses.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('There\'s no expenses'));
          }

          return ListView.separated(
            itemBuilder: (context, index) => ListTile(
              title: Text(currency.format(data[index].amount)),
              subtitle: Text(data[index].title!),
            ),
            separatorBuilder: (_, __) => const Divider(height: 0.0),
            itemCount: data.length,
          );
        },
        error: (_, __) => const Center(
          child: Text('Failed to load'),
        ),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class ExpensesArgs {
  const ExpensesArgs({required this.currencyCode});

  final String currencyCode;
}

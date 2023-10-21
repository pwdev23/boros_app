import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart' show incomesProvider;
import '../utils.dart';

class IncomesPage extends ConsumerWidget {
  static const routeName = '/incomes';

  const IncomesPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final incomes = ref.watch(incomesProvider);
    final currency = NumberFormat.currency(
      locale: findLang(currencyCode),
      symbol: findSign(currencyCode),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Incomes'),
      ),
      body: incomes.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('Income is empty'));
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
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}

class IncomesArgs {
  const IncomesArgs({required this.currencyCode});

  final String currencyCode;
}

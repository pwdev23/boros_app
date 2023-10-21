import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../collections/collections.dart' show Expense;
import '../providers/providers.dart' show expensesProvider;
import '../shared/bottom_sheet_handle.dart';
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
              onTap: () => _showDetails(data[index]),
              onLongPress: () {},
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

  void _showDetails(Expense data) {
    final code = widget.currencyCode;
    final currency =
        NumberFormat.currency(locale: findLang(code), symbol: findSign(code));
    final mMMMEEEEd = DateFormat.MMMMEEEEd().format(data.createdAt!);
    final hM = DateFormat.Hm().format(data.createdAt!);
    final textTheme = Theme.of(context).textTheme;
    final dividerColor = Theme.of(context).dividerColor;

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          const BottomSheetHandle(),
          ListTile(
            title: Text('$mMMMEEEEd, $hM'),
            subtitle: const Text('Created at'),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text(data.category!),
            subtitle: const Text('Category'),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text(currency.format(data.amount)),
            subtitle: const Text('Amount'),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text(data.title!),
            subtitle: const Text('Title'),
          ),
          if (data.notes != 'n/a') const Divider(height: 0.0),
          if (data.notes != 'n/a')
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 14.0),
                      Text(
                        'Notes',
                        style: textTheme.bodyLarge,
                      ),
                      Text(
                        data.notes!,
                        style:
                            textTheme.bodySmall!.copyWith(color: dividerColor),
                      )
                    ],
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}

class ExpensesArgs {
  const ExpensesArgs({required this.currencyCode});

  final String currencyCode;
}

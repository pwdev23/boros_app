import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../collections/collections.dart' show Expense;
import '../isar_services.dart' show deleteExpenses;
import '../providers/providers.dart' show expensesProvider, idleMoneyProvider;
import '../shared/bottom_sheet_handle.dart';
import '../shared/tiny_circle_border.dart';
import '../utils.dart';

class ExpensesPage extends ConsumerStatefulWidget {
  static const routeName = '/expenses';

  const ExpensesPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  bool _loading = false;
  final Set<int> _ids = {};

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );
    final nav = Navigator.of(context);
    final expenses = ref.watch(expensesProvider);

    return WillPopScope(
      onWillPop: () => Future.value(!_loading),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Expenses'),
          actions: [
            if (_ids.isNotEmpty) TinyCircleBorder(text: '${_ids.length}'),
            _ids.isEmpty
                ? IconButton(
                    color: colorScheme.surfaceTint,
                    onPressed: () => nav.pushNamed('/add-expense'),
                    icon: const Icon(Icons.add),
                  )
                : IconButton(
                    onPressed: () async {
                      setState(() => _loading = true);

                      const s = Duration(seconds: 3);
                      final message = ScaffoldMessenger.of(context);
                      const snackBar = SnackBar(
                          content: Text('The data successfully deleted'));

                      await deleteExpenses(ids: _ids.toList());
                      await Future.delayed(s, () {
                        ref.invalidate(expensesProvider);
                        ref.invalidate(idleMoneyProvider);
                      })
                          .then((_) => _ids.clear())
                          .then((_) => setState(() => _loading = false))
                          .then((_) => message.showSnackBar(snackBar));
                    },
                    icon: const Icon(Icons.delete),
                  ),
          ],
        ),
        body: expenses.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('There\'s no expenses'));
            }

            return Stack(
              children: [
                ListView.separated(
                  itemBuilder: (context, index) => ListTile(
                    onTap: () {
                      if (_loading) return;

                      if (_ids.isEmpty) {
                        _showDetails(data[index]);
                        return;
                      }

                      if (_ids.contains(data[index].id)) {
                        _ids.remove(data[index].id);
                      } else {
                        _ids.add(data[index].id);
                      }

                      setState(() {});
                    },
                    onLongPress: () {
                      if (_loading) return;

                      _ids.add(data[index].id);
                      setState(() {});
                    },
                    title: Text(currency.format(data[index].amount)),
                    subtitle: Text(data[index].title!),
                    tileColor: _ids.contains(data[index].id)
                        ? colorScheme.primaryContainer
                        : null,
                  ),
                  separatorBuilder: (_, __) => const Divider(height: 0.0),
                  itemCount: data.length,
                ),
                if (_loading) const LinearProgressIndicator(),
              ],
            );
          },
          error: (_, __) => const Center(
            child: Text('Failed to load'),
          ),
          loading: () =>
              const Center(child: CircularProgressIndicator.adaptive()),
        ),
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
            title: Text(t(context, data.category!)),
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
          const Divider(height: 0.0),
          ListTile(
            title: Text('$mMMMEEEEd, $hM'),
            subtitle: const Text('Created at'),
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

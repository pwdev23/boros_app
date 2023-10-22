import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../collections/collections.dart' show Debt;
import '../isar_services.dart' show deleteDebts;
import '../providers/providers.dart' show debtsProvider;
import '../shared/bottom_sheet_handle.dart';
import '../shared/tiny_circle_border.dart';
import '../utils.dart';
import 'add_debt_page.dart' show AddDebtArgs;

class DebtsPage extends ConsumerStatefulWidget {
  static const routeName = '/debts';

  const DebtsPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends ConsumerState<DebtsPage> {
  final Set<int> _ids = {};
  bool _loading = false;
  @override
  Widget build(BuildContext context) {
    final debts = ref.watch(debtsProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Navigator.of(context);
    const args = AddDebtArgs('main');
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Debts'),
        actions: [
          if (_ids.isNotEmpty) TinyCircleBorder(text: '${_ids.length}'),
          _ids.isEmpty
              ? IconButton(
                  onPressed: () => nav.pushNamed(
                    '/add-debt',
                    arguments: args,
                  ),
                  icon: Icon(Icons.add, color: colorScheme.surfaceTint),
                )
              : IconButton(
                  onPressed: () async {
                    setState(() => _loading = true);

                    const s = Duration(seconds: 3);
                    final message = ScaffoldMessenger.of(context);
                    const snackBar = SnackBar(
                        content: Text('The data successfully deleted'));

                    await deleteDebts(ids: _ids.toList());
                    await Future.delayed(s, () => ref.invalidate(debtsProvider))
                        .then((_) => _ids.clear())
                        .then((_) => setState(() => _loading = false))
                        .then((_) => message.showSnackBar(snackBar));
                  },
                  icon: const Icon(Icons.delete),
                )
        ],
      ),
      body: debts.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('There\'s no debt yet'));
          }

          return Stack(
            children: [
              ListView.separated(
                itemBuilder: (context, index) => ListTile(
                  title: Text(currency.format(data[index].amount)),
                  subtitle: Text(data[index].title!),
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
        error: (_, __) => const Center(child: Text('Failed to load')),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }

  void _showDetails(Debt data) {
    final code = widget.currencyCode;
    final currency =
        NumberFormat.currency(locale: findLang(code), symbol: findSign(code));
    final mMMMEEEEd = DateFormat.MMMMEEEEd();
    final hM = DateFormat.Hm();
    final textTheme = Theme.of(context).textTheme;
    final dividerColor = Theme.of(context).dividerColor;
    final createdAt =
        '${mMMMEEEEd.format(data.createdAt!)}, ${hM.format(data.createdAt!)}';

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          const BottomSheetHandle(),
          ListTile(
            title: Text(mMMMEEEEd.format(data.dueDate!)),
            subtitle: const Text('Due date'),
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
            title: Text(createdAt),
            subtitle: const Text('Created at'),
          ),
          const Divider(height: 0.0),
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

class DebtsArgs {
  const DebtsArgs({required this.currencyCode});

  final String currencyCode;
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../collections/collections.dart' show Income;
import '../providers/providers.dart' show incomesProvider;
import '../shared/bottom_sheet_handle.dart';
import '../utils.dart';
import '../isar_services.dart' show deleteIncomes;

class IncomesPage extends ConsumerStatefulWidget {
  static const routeName = '/incomes';

  const IncomesPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<IncomesPage> createState() => _IncomesPageState();
}

class _IncomesPageState extends ConsumerState<IncomesPage> {
  final Set<int> _ids = {};
  bool _loading = false;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final incomes = ref.watch(incomesProvider);
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );

    return WillPopScope(
      onWillPop: () => Future.value(!_loading),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Incomes'),
          actions: [
            if (_ids.isNotEmpty) _Circle(text: '${_ids.length}'),
            _ids.isEmpty
                ? IconButton(
                    color: colorScheme.surfaceTint,
                    onPressed: () {
                      final nav = Navigator.of(context);
                      nav.pushNamed('/add-income');
                    },
                    icon: const Icon(Icons.add),
                  )
                : IconButton(
                    onPressed: () async {
                      setState(() => _loading = true);

                      const s = Duration(seconds: 3);
                      final message = ScaffoldMessenger.of(context);
                      const snackBar = SnackBar(
                          content: Text('Income data successfully deleted'));

                      await deleteIncomes(ids: _ids.toList());
                      await Future.delayed(
                              s, () => ref.invalidate(incomesProvider))
                          .then((_) => _ids.clear())
                          .then((_) => setState(() => _loading = false))
                          .then((_) => message.showSnackBar(snackBar));
                    },
                    icon: const Icon(Icons.delete),
                  ),
          ],
        ),
        body: incomes.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('There\'s no income yet'));
            }

            return Stack(
              children: [
                if (_loading) const LinearProgressIndicator(),
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
              ],
            );
          },
          error: (_, __) => const Center(
            child: Text('Failed to load'),
          ),
          loading: () => const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
    );
  }

  void _showDetails(Income data) {
    final code = widget.currencyCode;
    final currency = NumberFormat.currency(locale: findLang(code));
    final mMMMEEEEd = DateFormat.MMMMEEEEd().format(data.createdAt!);
    final hM = DateFormat.Hm().format(data.createdAt!);

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
            title: Text(data.title!),
            subtitle: const Text('Title'),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text(currency.format(data.amount)),
            subtitle: const Text('Amount'),
          ),
        ],
      ),
    );
  }
}

class IncomesArgs {
  const IncomesArgs({required this.currencyCode});

  final String currencyCode;
}

class _Circle extends StatelessWidget {
  const _Circle({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: colorScheme.inverseSurface,
      ),
      child: Text(text, style: TextStyle(color: colorScheme.onInverseSurface)),
    );
  }
}

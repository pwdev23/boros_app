import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../common.dart';
import '../collections/collections.dart' show Income;
import '../providers/providers.dart' show incomesProvider, idleMoneyProvider;
import '../shared/bottom_sheet_handle.dart';
import '../shared/tiny_circle_border.dart';
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
    final l10n = AppLocalizations.of(context)!;
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
          title: Text(l10n.incomes),
          actions: [
            if (_ids.isNotEmpty) TinyCircleBorder(text: '${_ids.length}'),
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
                          content: Text('The data successfully deleted'));

                      await deleteIncomes(ids: _ids.toList());
                      await Future.delayed(s, () {
                        ref.invalidate(incomesProvider);
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
        body: incomes.when(
          data: (data) {
            if (data.isEmpty) {
              return const Center(child: Text('There\'s no income yet'));
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

  void _showDetails(Income data) {
    final l10n = AppLocalizations.of(context)!;
    final code = widget.currencyCode;
    final currency =
        NumberFormat.currency(locale: findLang(code), symbol: findSign(code));
    final mMMMEEEEd = DateFormat.MMMMEEEEd().format(data.createdAt!);
    final hM = DateFormat.Hm().format(data.createdAt!);

    showModalBottomSheet(
      context: context,
      builder: (context) => Column(
        children: [
          const BottomSheetHandle(),
          ListTile(
            title: Text(currency.format(data.amount)),
            subtitle: Text(l10n.amount),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text(data.title!),
            subtitle: Text(l10n.title),
          ),
          const Divider(height: 0.0),
          ListTile(
            title: Text('$mMMMEEEEd, $hM'),
            subtitle: Text(l10n.createdAt),
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

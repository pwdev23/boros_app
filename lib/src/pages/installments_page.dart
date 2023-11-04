import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../common.dart';
import '../collections/collections.dart' show Installment;
import '../isar_services.dart' show deleteInstallments;
import '../providers/providers.dart'
    show installmentsProvider, idleMoneyProvider;
import '../shared/bottom_sheet_handle.dart';
import '../shared/tiny_circle_border.dart';
import '../utils.dart';
import 'add_installment_page.dart' show AddInstallmentArgs;

class InstallmentsPage extends ConsumerStatefulWidget {
  static const routeName = '/installments';

  const InstallmentsPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<InstallmentsPage> createState() => _InstallmentsPageState();
}

class _InstallmentsPageState extends ConsumerState<InstallmentsPage> {
  bool _loading = false;
  final Set<int> _ids = {};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final nav = Navigator.of(context);
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );
    var installments = ref.watch(installmentsProvider);
    const args = AddInstallmentArgs('main');

    return WillPopScope(
      onWillPop: () => Future.value(!_loading),
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.installments),
          actions: [
            if (_ids.isNotEmpty) TinyCircleBorder(text: '${_ids.length}'),
            _ids.isEmpty
                ? IconButton(
                    onPressed: () => nav.pushNamed(
                      '/add-installment',
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

                      await deleteInstallments(ids: _ids.toList());
                      await Future.delayed(s, () {
                        ref.invalidate(installmentsProvider);
                        ref.invalidate(idleMoneyProvider);
                      })
                          .then((_) => _ids.clear())
                          .then((_) => setState(() => _loading = false))
                          .then((_) => message.showSnackBar(snackBar));
                    },
                    icon: const Icon(Icons.delete),
                  )
          ],
        ),
        body: installments.when(
          data: (data) {
            if (data.isEmpty) {
              return Center(child: Text(l10n.noInstallment));
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
      ),
    );
  }

  void _showDetails(Installment data) {
    final l10n = AppLocalizations.of(context)!;
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
            subtitle: Text(l10n.dueDate),
          ),
          const Divider(height: 0.0),
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
            title: Text(createdAt),
            subtitle: Text(l10n.createdAt),
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
                        l10n.notes,
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

class InstallmentsArgs {
  const InstallmentsArgs({required this.currencyCode});

  final String currencyCode;
}

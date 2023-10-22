import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../providers/providers.dart' show installmentsProvider;
import '../utils.dart';

class InstallmentsPage extends ConsumerStatefulWidget {
  static const routeName = '/installments';

  const InstallmentsPage({super.key, required this.currencyCode});

  final String currencyCode;

  @override
  ConsumerState<InstallmentsPage> createState() => _InstallmentsPageState();
}

class _InstallmentsPageState extends ConsumerState<InstallmentsPage> {
  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat.currency(
      locale: findLang(widget.currencyCode),
      symbol: findSign(widget.currencyCode),
    );
    var installments = ref.watch(installmentsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Installments'),
      ),
      body: installments.when(
        data: (data) {
          if (data.isEmpty) {
            return const Center(child: Text('There\'s no installment yet'));
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
        error: (_, __) => const Center(child: Text('Failed to load')),
        loading: () =>
            const Center(child: CircularProgressIndicator.adaptive()),
      ),
    );
  }
}

class InstallmentsArgs {
  const InstallmentsArgs({required this.currencyCode});

  final String currencyCode;
}

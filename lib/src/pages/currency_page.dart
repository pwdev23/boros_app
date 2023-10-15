import '../common.dart';

class CurrencyPage extends StatelessWidget {
  static const routeName = '/currency';

  const CurrencyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setCurrency),
      ),
    );
  }
}

import '../common.dart';
import '../currency_code.dart';

class CurrencyPage extends StatefulWidget {
  static const routeName = '/currency';

  const CurrencyPage({super.key});

  @override
  State<CurrencyPage> createState() => _CurrencyPageState();
}

class _CurrencyPageState extends State<CurrencyPage> {
  String _code = 'IDR';
  String _name = 'Indonesia';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setCurrency),
      ),
      body: ListView(
        children: [
          ListTile(
            onTap: () => _showCurrencyCodePicker(),
            title: Text(_code),
            subtitle: Text(_name),
          ),
        ],
      ),
    );
  }

  void _showCurrencyCodePicker() {
    final nav = Navigator.of(context);

    showModalBottomSheet(
      context: context,
      builder: (context) => SingleChildScrollView(
        child: Column(
          children: List.generate(
            kCurrencyCode.length,
            (index) => ListTile(
              onTap: () {
                setState(() {
                  _code = '${kCurrencyCode[index]['code']}';
                  _name = '${kCurrencyCode[index]['name']}';
                });

                nav.pop();
              },
              title: Text('${kCurrencyCode[index]['code']}'),
              subtitle: Text('${kCurrencyCode[index]['name']}'),
            ),
          ),
        ),
      ),
    );
  }
}

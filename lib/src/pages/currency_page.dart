import '../common.dart';
import '../currency_code.dart';
import 'home_page.dart' show HomeArgs;

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
    final nav = Navigator.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.setCurrency),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          _CurrencyButton(
            onPressed: () => _showCurrencyCodePicker(),
            code: _code,
            name: _name,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () =>
            nav.pushReplacementNamed('/home', arguments: HomeArgs(_code)),
        label: const Text('Next'),
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

class _CurrencyButton extends StatelessWidget {
  const _CurrencyButton({
    required this.onPressed,
    required this.code,
    required this.name,
  });

  final VoidCallback onPressed;
  final String code;
  final String name;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return RawMaterialButton(
      onPressed: onPressed,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
        side: BorderSide(color: colorScheme.outline),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Text.rich(
              TextSpan(
                text: '$code ',
                style: textTheme.titleMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: name,
                    style: textTheme.titleMedium,
                  ),
                ],
              ),
            ),
            const Spacer(),
            Icon(
              Icons.expand_more,
              color: colorScheme.outline,
            )
          ],
        ),
      ),
    );
  }
}
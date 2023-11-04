import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../common.dart';
import '../collections/collections.dart' show Income;
import '../isar_services.dart' show addIncome;

class AddIncomePage extends ConsumerStatefulWidget {
  static const routeName = '/add-income';

  const AddIncomePage({super.key});

  @override
  ConsumerState<AddIncomePage> createState() => _AddIncomePageState();
}

class _AddIncomePageState extends ConsumerState<AddIncomePage> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    const p = EdgeInsets.symmetric(horizontal: 16.0);
    const hintText = 'e.g., Freelance work, Salary';

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addIncome),
      ),
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                Padding(
                  padding: p,
                  child: TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      counterText: '',
                      hintText: '99999',
                      labelText: l10n.amount,
                    ),
                    maxLength: 16,
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Invalid amount';

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8.0),
                Padding(
                  padding: p,
                  child: TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: hintText,
                      labelText: l10n.title,
                    ),
                    keyboardType: TextInputType.name,
                    onChanged: (value) {
                      setState(() {});
                    },
                    validator: (value) {
                      if (value!.isEmpty) return 'Income title is required';

                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16.0),
                FilledButton(
                  onPressed: _formKey.currentState != null &&
                          _formKey.currentState!.validate()
                      ? () => _onAddIncome()
                      : null,
                  child: Text(l10n.addIncome),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  void _onAddIncome() async {
    final nav = Navigator.of(context);
    final now = DateTime.now();

    var income = Income()
      ..amount = double.parse(_amountController.text)
      ..title = _titleController.text.trim()
      ..createdAt = now;

    await addIncome(income: income)
        .then((_) => nav.pushNamedAndRemoveUntil('/', (route) => false));
  }
}

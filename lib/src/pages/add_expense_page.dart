import 'package:boros_app/src/shared/info_text_box.dart';

import '../common.dart';
import '../collections/collections.dart' show Expense;
import '../constants.dart' show kCategorySuggestions;
import '../isar_services.dart' show addExpense;
import '../utils.dart';

class AddExpensePage extends StatefulWidget {
  static const routeName = '/add-expense';

  const AddExpensePage({super.key});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  String _selectedCategory = 'essential-and-utilities';
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    var locale = '${Localizations.localeOf(context)}';
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.addExpense),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8.0),
            child: Text(l10n.selectCategory, style: textTheme.titleMedium),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Wrap(
              spacing: 8.0,
              children: kCategorySuggestions
                  .map((e) => ChoiceChip(
                      onSelected: (_) {
                        if ('${e['title']}' == _selectedCategory) {
                          setState(() => _selectedCategory = 'n/a');
                          return;
                        }
                        setState(() => _selectedCategory = '${e['title']}');
                      },
                      label: Text(t(context, '${e['title']}')),
                      selected: _selectedCategory == '${e['title']}'))
                  .toList(),
            ),
          ),
          const SizedBox(height: 8.0),
          InfoTextBox(text: findDesc(_selectedCategory, locale)),
          const SizedBox(height: 8.0),
          Form(
            key: _formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: l10n.amount,
                      counterText: '',
                      hintText: '99999',
                    ),
                    maxLength: 16,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Invalid amount';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _titleController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      labelText: l10n.title,
                      hintText: _selectedCategory == 'n/a'
                          ? 'e.g., Internet bill, Dinner out'
                          : findHintText(_selectedCategory, locale),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'Expense title is required';
                      }

                      return null;
                    },
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 8.0),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      hintText: 'Bought groceries for the week',
                      labelText: l10n.notes,
                    ),
                    keyboardType: TextInputType.multiline,
                    onChanged: (value) {
                      setState(() {});
                    },
                  ),
                  const SizedBox(height: 16.0),
                  FilledButton(
                    onPressed: _formKey.currentState != null &&
                            _formKey.currentState!.validate() &&
                            _selectedCategory != 'n/a'
                        ? () => _onAddExpense()
                        : null,
                    child: Text(l10n.addExpense),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onAddExpense() async {
    final nav = Navigator.of(context);
    final now = DateTime.now();

    var expense = Expense()
      ..category = _selectedCategory
      ..amount = double.parse(_amountController.text)
      ..title = _titleController.text.trim()
      ..notes =
          _notesController.text.isEmpty ? 'n/a' : _notesController.text.trim()
      ..createdAt = now;

    await addExpense(expense: expense)
        .then((_) => nav.pushNamedAndRemoveUntil('/', (route) => false));
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../collections/collections.dart';
import '../isar_services.dart';

class AddDebtPage extends ConsumerStatefulWidget {
  static const routeName = '/add-debt';

  const AddDebtPage({super.key, this.restorationId});

  final String? restorationId;

  @override
  ConsumerState<AddDebtPage> createState() => _AddDebtPageState();
}

class _AddDebtPageState extends ConsumerState<AddDebtPage>
    with RestorationMixin {
  @override
  String? get restorationId => widget.restorationId;
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _titleController = TextEditingController();
  final _notesController = TextEditingController();
  final _dateController = TextEditingController();
  final _selectedDate = RestorableDateTime(DateTime.now());
  late final RestorableRouteFuture<DateTime?> _restorableDatePickerRouteFuture =
      RestorableRouteFuture<DateTime?>(
    onComplete: _selectDate,
    onPresent: (NavigatorState navigator, Object? arguments) {
      return navigator.restorablePush(
        _datePickerRoute,
        arguments: _selectedDate.value.millisecondsSinceEpoch,
      );
    },
  );

  @override
  void dispose() {
    _dateController.dispose();
    _amountController.dispose();
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add debt'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: [
          Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: 'Due date',
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Due date is required';
                    }

                    return null;
                  },
                  onTap: () => _restorableDatePickerRouteFuture.present(),
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    counterText: '',
                    hintText: '99999',
                    labelText: 'Amount',
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
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    hintText: 'e.g., Personal loan',
                    labelText: 'Title',
                  ),
                  keyboardType: TextInputType.name,
                  onChanged: (value) {
                    setState(() {});
                  },
                  validator: (value) {
                    if (value!.isEmpty) return 'Debt title is required';

                    return null;
                  },
                ),
                const SizedBox(height: 8.0),
                TextFormField(
                  controller: _notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                  keyboardType: TextInputType.multiline,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16.0),
          FilledButton(
            onPressed: _formKey.currentState != null &&
                    _formKey.currentState!.validate()
                ? () => _onAddDebt()
                : null,
            child: const Text('Add debt'),
          ),
        ],
      ),
    );
  }

  void _onAddDebt() async {
    final nav = Navigator.of(context);

    var debt = Debt()
      ..amount = double.parse(_amountController.text)
      ..title = _titleController.text.trim()
      ..dueDate = _selectedDate.value
      ..notes = _notesController.text.isEmpty ? 'n/a' : _notesController.text
      ..createdAt = DateTime.now();

    await addDebt(debt: debt)
        .then((_) => nav.pushNamedAndRemoveUntil('/', (route) => false));
  }

  @pragma('vm:entry-point')
  static Route<DateTime> _datePickerRoute(
    BuildContext context,
    Object? arguments,
  ) {
    return DialogRoute<DateTime>(
      context: context,
      builder: (BuildContext context) {
        final now = DateTime.now();
        const aYear = Duration(days: 365);

        return DatePickerDialog(
          restorationId: 'date_picker_dialog',
          initialEntryMode: DatePickerEntryMode.calendarOnly,
          initialDate: DateTime.fromMillisecondsSinceEpoch(arguments! as int),
          firstDate: now.subtract(aYear),
          lastDate: now.add(aYear),
          helpText: 'Select a debt due date',
          cancelText: 'Cancel',
          confirmText: 'Ok',
        );
      },
    );
  }

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(_selectedDate, 'selected_date');
    registerForRestoration(
        _restorableDatePickerRouteFuture, 'date_picker_route_future');
  }

  void _selectDate(DateTime? newSelectedDate) {
    if (newSelectedDate != null) {
      _selectedDate.value = newSelectedDate;
      final d = _selectedDate.value.day;
      final m = _selectedDate.value.month;
      final y = _selectedDate.value.year;
      _dateController.text = '$d/$m/$y';
      final snackBar = SnackBar(content: Text('Selected $d/$m/$y'));
      setState(() {});
      final messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(snackBar);
    }
  }
}

class AddDebtArgs {
  const AddDebtArgs(this.restorationId);

  final String? restorationId;
}

import 'package:flutter/material.dart';

import 'pages/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const CheckStatesPage());
    case '/home':
      final args = settings.arguments as HomeArgs;
      return MaterialPageRoute(
          builder: (_) => HomePage(currencyCode: args.currencyCode));
    case '/currency':
      return MaterialPageRoute(builder: (_) => const CurrencyPage());
    case '/add-income':
      return MaterialPageRoute(builder: (_) => const AddIncomePage());
    case '/incomes':
      final args = settings.arguments as IncomesArgs;
      return MaterialPageRoute(
          builder: (_) => IncomesPage(currencyCode: args.currencyCode));
    case '/add-debt':
      return MaterialPageRoute(builder: (_) => const AddDebtPage());
    case '/add-expense':
      return MaterialPageRoute(builder: (_) => const AddExpensePage());
    case '/add-installment':
      final args = settings.arguments as AddInstallmentArgs;
      return MaterialPageRoute(
          builder: (_) =>
              AddInstallmentPage(restorationId: args.restorationId));
    case '/expenses':
      final args = settings.arguments as ExpensesArgs;
      return MaterialPageRoute(
          builder: (_) => ExpensesPage(currencyCode: args.currencyCode));
    case '/installments':
      final args = settings.arguments as InstallmentsArgs;
      return MaterialPageRoute(
          builder: (_) => InstallmentsPage(currencyCode: args.currencyCode));
    default:
      return MaterialPageRoute(
        builder: (_) => Scaffold(
          body: Center(
            child: Text('${settings.name} undifined'),
          ),
        ),
      );
  }
}

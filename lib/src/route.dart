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
      final args = settings.arguments as AddIncomeArgs;
      return MaterialPageRoute(
          builder: (_) => AddIncomePage(currencyCode: args.currencyCode));
    case '/incomes':
      final args = settings.arguments as IncomesArgs;
      return MaterialPageRoute(
          builder: (_) => IncomesPage(currencyCode: args.currencyCode));
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

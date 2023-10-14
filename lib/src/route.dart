import 'package:flutter/material.dart';

import 'pages/pages.dart';

Route<dynamic> onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => const CheckStatesPage());
    case '/home':
      return MaterialPageRoute(builder: (_) => const HomePage());
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

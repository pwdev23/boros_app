import 'common.dart';
import 'route.dart';
import 'theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Boros',
      onGenerateTitle: (context) => AppLocalizations.of(context)!.wasteful,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      theme: theme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      initialRoute: '/',
      onGenerateRoute: onGenerateRoute,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pesagens_de_gado/pages/main_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        MainPage.routeName: (context) => MainPage(),
        //WeighingPage.routeName: (context) => WeighingPage()
      }
    );
  }
}
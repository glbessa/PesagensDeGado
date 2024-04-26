import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:pesagens_de_gado/pages/analytics_page.dart';
import 'package:pesagens_de_gado/pages/summary_page.dart';
import 'package:pesagens_de_gado/pages/weighing_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  int _actualIndex = 0;

  final List<Widget> _pages = [
    SummaryPage(),
    WeighingPage(),
    AnalyticsPage()
  ];

  @override
  void initState() {
    super.initState();
  }

  void onTabTapped(int index) {
    setState(() {
      _actualIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.weighings)
      ),
      body: _pages[_actualIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _actualIndex,
        onTap: this.onTabTapped,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: AppLocalizations.of(context)!.summary
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.scale),
              label: AppLocalizations.of(context)!.toWeight
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.analytics),
              label: "Análises"
          )
        ],
      ),
    );
  }

  Widget createWeighingCardWidget() {
    return Center();
  }
}
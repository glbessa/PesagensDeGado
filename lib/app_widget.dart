import 'package:flutter/material.dart';
import 'package:pesagens_de_gado/main_page.dart';
import 'package:pesagens_de_gado/new_weighing_page.dart';
import 'package:pesagens_de_gado/weighing_details_page.dart';
import 'package:pesagens_de_gado/weighing_process_page.dart';

class AppWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        MainPage.routeName: (context) => MainPage(),
        NewWeighingPage.routeName: (context) => NewWeighingPage(),
        WeighingDetailsPage.routeName: (context) => WeighingDetailsPage(),
        WeighingProcessPage.routeName: (context) => WeighingProcessPage(),
          //'/multiWeighingProcess': (context) => MultiWeighingProcess()
      }
    );
  }
}
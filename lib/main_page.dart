import 'package:flutter/material.dart';
import 'package:pesagens_de_gado/new_weighing_page.dart';

class MainPage extends StatefulWidget {
  static const String routeName = '/';

  @override
  State<StatefulWidget> createState() {
    return MainPageState();
  }
}

class MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Pesagens')
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.pushNamed(context, NewWeighingPage.routeName);
        },
      )
    );
  }

  Widget createWeighingCardWidget() {
    return Center();
  }
}
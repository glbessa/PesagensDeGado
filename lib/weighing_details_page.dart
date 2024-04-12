import 'package:flutter/material.dart';

import 'package:pesagens_de_gado/weighing.dart';
import 'package:pesagens_de_gado/db.dart';
import 'package:pesagens_de_gado/weighing_controll.dart';

class WeighingDetailsPage extends StatefulWidget {
  //final int weighingId;
  //WeighingDetailsPage({ Key? key, required this.weighingId }) : super(key : key);
  static const String routeName = '/weighingDetails';

  @override
  State<StatefulWidget> createState() {
    return WeighingDetailsState();
  }
}

class WeighingDetailsState extends State<WeighingDetailsPage> {
  late WeighingControll wc;
  late List<Weighing> weighings;
  late double totalWeight;
  late int totalAnimals;
  late double avgWeight;
  late double minWeight;
  late double maxWeight;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)!.settings.arguments as List;
    wc = args[0];
    loadValues();

    return Scaffold(
      appBar: AppBar(
        title: Text('Pesagem'),
        actions: [],
      ),
      body: Column(
        children: [
          ListView(
            children: [buildAllWeighingCards(context), [buildGeneralStats()]].expand((x) => x).toList(),
          )
        ],
      )
    );
  }

  loadValues() async {
    weighings = await DB.instance.listWeighingByControllId(wc.idControle!);
    totalWeight = await DB.instance.sumOfWeight(wc.idControle!);
    totalAnimals = await DB.instance.quantOfAnimals(wc.idControle!);
    minWeight = await DB.instance.minOfWeight(wc.idControle!);
    maxWeight = await DB.instance.maxOfWeight(wc.idControle!);

    avgWeight = totalWeight / totalAnimals;

    setState(() {});
  }

  Widget buildInfoWidget() {
    return Center();
  }

  List<Widget> buildAllWeighingCards(BuildContext context) {
    List<Widget> cards = [];
    
    weighings.forEach((e) {
      cards.add(buildWeighingCardWidget(context, e));
    });

    return cards;
  }

  Widget buildWeighingCardWidget(BuildContext context, Weighing w) {
    return SizedBox(
      height: 100,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          Text(w.identAnimais),
          Text(w.quantAnimais.toString()),
          Text(w.pesoAnimais.toString()),
          buildStats(w),
          ElevatedButton(onPressed: () {
            DB.instance.deleteWeighing(w.idPesagem!);
            loadValues();
          }, child: Icon(Icons.clear))
        ],
      )
    );
  }

  Widget buildStats(Weighing w) {
    return Center();
  }

  Widget buildGeneralStats() {
    return Center();
  }
}
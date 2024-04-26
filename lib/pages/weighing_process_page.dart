/*import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:pesagens_de_gado/models/weighing.dart';
import 'package:pesagens_de_gado/weighing_controll.dart';
import 'package:pesagens_de_gado/pages/weighing_details_page.dart';
import 'package:pesagens_de_gado/utils/db.dart';

class WeighingProcessPage extends StatefulWidget {
  static const String routeName = "/weighingProcess";

  @override
  State<StatefulWidget> createState() {
    return WeighingProcessState();
  }
}

class WeighingProcessState extends State<WeighingProcessPage> {
  late WeighingControll wc;
  late double totalWeight;
  late int totalAnimals;
  late double minWeight;
  late double maxWeight;
  late double avgWeight;
  late String weighingStatus;

  TextEditingController quantAnimalController = TextEditingController();
  TextEditingController animalIdController = TextEditingController();
  TextEditingController weightController = TextEditingController();

  @override
  void initState() {
    weighingStatus = 'Pesando...';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final List args = ModalRoute.of(context)!.settings.arguments as List;
    wc = args[0];
    totalWeight = args[1];
    totalAnimals = args[2];
    minWeight = args[3];
    maxWeight = args[4];
    avgWeight = totalWeight / totalAnimals;

    quantAnimalController.text = "1";

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(weighingStatus),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: quantAnimalController,
              decoration: const InputDecoration(labelText: 'Quantidade', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly
              ],
            ),
            TextField(
              controller: animalIdController,
              decoration: const InputDecoration(labelText: 'Identificação', border: OutlineInputBorder())
            ),
            TextField(
              controller: weightController,
              decoration: const InputDecoration(labelText: 'Peso', border: OutlineInputBorder()),
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'\d+(?:\.?\d+)?'))
              ],
            ),
            buildWeighingStatsWidget(),
            buildButtonsWidget()
          ]
        )
      )
    );
  }

  Widget buildWeighingStatsWidget() {
    return Center();
  }

  Widget buildButtonsWidget() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ElevatedButton(onPressed: () {
          final status = checkValues();
          if (status) {
            saveWeight();
            Navigator.pushNamed(
                context,
                WeighingDetailsPage.routeName,
                arguments: [
                  wc
                ]
              );
            }
          },
          child: const Text('Finalizar')
        ),

        ElevatedButton(onPressed: () {
          final status = checkValues();
          if (status) {
            saveWeight();
            Navigator.pushNamed(
                context,
                WeighingProcessPage.routeName,
                arguments: [
                  wc,
                  totalWeight,
                  totalAnimals,
                  minWeight,
                  maxWeight
                ]
              );
            }
          },
          child: const Text('Próxima pesagem')
        )
      ]
    );
  }

  Future<void> _showAlertDialog(String alertText) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Atenção'),
          content: SingleChildScrollView(
            child: Text(alertText)
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Ok")
            )
          ]
        );
      }
    );
  }

  updateValues(double newWeight) {
    weightController.text = newWeight.toString();
    totalWeight += newWeight;
    totalAnimals += 1;
    if (minWeight > newWeight || minWeight == 0.0)
      minWeight = newWeight;
    if (maxWeight < newWeight)
      maxWeight = newWeight;

    avgWeight = totalWeight / totalWeight;
  }

  bool checkValues() {
    if (quantAnimalController.text == "") {
      _showAlertDialog("Quantidade de animais não preenchida!");
      return false;
    }
    else if (weightController.text == "") {
      _showAlertDialog("Peso não preenchido!");
      return false;
    }
    return true;
  }

  saveWeight() {
    int nAnimals = int.parse(quantAnimalController.text);
    String animalId = animalIdController.text;
    double weight = double.parse(weightController.text);

    Weighing w = Weighing(
      idControle: wc.idControle!,
      identAnimais: animalId,
      quantAnimais: nAnimals,
      pesoAnimais: weight
    );

    DB.instance.insertWeighing(w);

    Navigator.pushNamed(
      context,
      WeighingProcessPage.routeName,
      arguments: [
        //weighingId
        wc,
        //totalweight
        totalWeight,
        //totalanimals
        totalAnimals,
        //minweight
        minWeight,
        //maxweight
        maxWeight
      ]
    );
  }
}*/
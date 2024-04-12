import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:pesagens_de_gado/weighing_controll.dart';
import 'package:pesagens_de_gado/db.dart';
import 'package:pesagens_de_gado/weighing_process_page.dart';

//https://pub.dev/documentation/flutter_blue/latest/
//https://medium.com/flutter-community/flutter-for-bluetooth-devices-5594f105b146

class NewWeighingPage extends StatefulWidget {
  static const String routeName = '/newWeighing';

  const NewWeighingPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return NewWeighingState();
  }
}

class NewWeighingState extends State<NewWeighingPage> {
  TextEditingController loteController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  late DateTime selectedDate;

  FlutterBlue btInstance = FlutterBlue.instance;
  List<ScanResult> bluetoothScanResults = [];
  late BluetoothDevice btDevice;
  late BluetoothState btState;
  late BluetoothDeviceState deviceState;
  late List<BluetoothService> services;

  String? dropdownValue = "";

  String btnConectarText = "Conectar";

  @override
  void initState() {
    super.initState();

    btInstance.state.listen((state) {
        if (state == BluetoothState.off) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ligue o bluetooth!")));
        }
        else if (state == BluetoothState.on) {
          scanForDevices();
        }
      }
    );

    selectedDate = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nova pesagem')
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                controller: loteController,
                decoration: const InputDecoration(labelText: 'Lote', border: OutlineInputBorder())
              ),
              TextField(
                keyboardType: TextInputType.none,
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Data', border: OutlineInputBorder()),
                onTap: () => _showDateDialog()
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Descrição', border: OutlineInputBorder()),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  DropdownButton(
                    value: dropdownValue,
                    icon: const Icon(Icons.keyboard_arrow_down),
                    items: bluetoothScanResults.toSet().map((ScanResult r) {
                      return DropdownMenuItem(
                        value: deviceMacAddress(r),
                        child: Text(deviceMacAddress(r))
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    }
                  ),
                  ElevatedButton(
                    onPressed: () {
                      scanForDevices();
                    },
                    child: const Text('Escanear')
                  ),
                  ElevatedButton(
                    onPressed: () {
                      for(ScanResult r in bluetoothScanResults) {
                        if (deviceMacAddress(r) == dropdownValue) {
                          btDevice = r.device;
                          btDevice.connect();

                        }
                      }
                    },
                    child: Text(btnConectarText)
                  )
                ],
              ),
              ElevatedButton(
                child: Text('Começar pesagem!'),
                  onPressed: () {
                    if (checkValues()) {
                      // cria pesagem no banco de dados
                      WeighingControll wc = WeighingControll(
                          lote: loteController.text,
                          data: selectedDate,
                          detalhes: descriptionController.text
                      );

                      DB.instance.insertWeighingControll(wc).then((value) { wc = value; });

                      // ir para a pagina de pesagem
                      Navigator.pushNamed(
                          context,
                          WeighingProcessPage.routeName,
                          arguments: [
                            //weighingId
                            wc,
                            //totalweight
                            0.0,
                            //totalanimals
                            0,
                            //minweight
                            0.0,
                            //maxweight
                            0.0
                          ]
                      );
                    }
                  },
              ),
            ]
          )
      )
    );
  }

  _showDateDialog() {
    showDatePicker(context: context, initialDate: selectedDate, firstDate: DateTime(2000), lastDate: DateTime(2032)).then((value) {
      if (value == null) {
        setState(() {
          selectedDate = DateTime.now();
          dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }
      else {
        setState(() {
          selectedDate = value;
          dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
        });
      }
    });
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

  bool checkValues() {
    if (loteController.text == "") {
      _showAlertDialog("Lote não preenchido!");
      return false;
    }
    return true;
  }

  scanForDevices() async {
    bluetoothScanResults.clear();

    btInstance.startScan(timeout: const Duration(seconds:4));

    btInstance.scanResults.listen((results) {
      bluetoothScanResults = results;
    });
    
    btInstance.stopScan();
  }

  String deviceSignal(ScanResult sr) {
    return sr.rssi.toString();
  }

  String deviceMacAddress(ScanResult sr) {
    return sr.device.id.id;
  }

  String deviceName(ScanResult sr) {
    String name = '';

    if (sr.device.name.isNotEmpty) {
      name = sr.device.name;
    }
    else if (sr.advertisementData.localName.isNotEmpty) {
      name = sr.advertisementData.localName;
    }
    else {
      name = 'Desconhecido';
    }

    return name;
  }
/*
  discoverServices() async {
    services = await device.discoverServices();
  }

 */
}
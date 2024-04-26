import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_blue/flutter_blue.dart';

import 'package:pesagens_de_gado/utils/db.dart';

class WeighingPage extends StatefulWidget {
  const WeighingPage({Key? key}) : super(key: key);

  @override
  State<WeighingPage> createState() => _WeighingPageState();
}

class _WeighingPageState extends State<WeighingPage> {
  TextEditingController batchController = TextEditingController();
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

  List<String> batches = [];

  @override
  void initState() {
    super.initState();

    btInstance.state.listen((state) {
      if (state == BluetoothState.off) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Ligue o bluetooth!")));
      }
      else if (state == BluetoothState.on) {
        _scanForDevices();
      }
    }
    );

    selectedDate = DateTime.now();
    dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
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

  bool _checkValues() {
    if (batchController.text == "") {
      _showAlertDialog("Lote não preenchido!");
      return false;
    }
    return true;
  }

  void _scanForDevices() async {
    bluetoothScanResults.clear();

    btInstance.startScan(timeout: const Duration(seconds:4));

    btInstance.scanResults.listen((results) {
      bluetoothScanResults = results;
    });

    btInstance.stopScan();
  }

  String _deviceSignal(ScanResult sr) {
    return sr.rssi.toString();
  }

  String _deviceMacAddress(ScanResult sr) {
    return sr.device.id.id;
  }

  String _deviceName(ScanResult sr) {
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

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 10.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextField(
                  keyboardType: TextInputType.none,
                  controller: dateController,
                  decoration: const InputDecoration(labelText: 'Data', border: OutlineInputBorder()),
                  onTap: () => _showDateDialog()
              ),
              DropdownButton(
                  items: [],
                  onTap: () {

                  },
                  onChanged: (newValue) {
                    setState(() {

                    });
                  }
              ),
              TextField(
                controller: batchController,
                decoration: const InputDecoration(labelText: 'Lote', border: OutlineInputBorder())
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
                        value: _deviceMacAddress(r),
                        child: Text(_deviceMacAddress(r))
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
                      _scanForDevices();
                      },
                      child: const Text('Escanear')
                    ),
                    ElevatedButton(
                      onPressed: () {
                        for(ScanResult r in bluetoothScanResults) {
                          if (_deviceMacAddress(r) == dropdownValue) {
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
                    if (_checkValues()) {
                      // cria pesagem no banco de dados

                    }
                  },
                ),
              ]
        )
    );
  }
}

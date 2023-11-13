import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_simple_bluetooth_printer/flutter_simple_bluetooth_printer.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/providers/printer_provider.dart';
import 'package:provider/provider.dart';



class PrinterPage extends StatefulWidget {
  Order? orderBill;

  PrinterPage({Key? key, this.orderBill}) : super(key: key);
  static const String id = "/Printer-screen";

  @override
  State<PrinterPage> createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {
  var bluetoothManager = FlutterSimpleBluetoothPrinter.instance;
  // final printerProvider = Provider.of<PrinterProvider>(listen: false);
  late PrinterProvider printerProvider;
  var _isScanning = false;
  var _isBle = true;
  var _isConnected = false;
  var devices = <BluetoothDevice>[];
  StreamSubscription<BTConnectState>? _subscriptionBtStatus;
  BTConnectState _currentStatus = BTConnectState.disconnect;

  BluetoothDevice? selectedPrinter;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    printerProvider = Provider.of<PrinterProvider>(context, listen: false);

    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    _discovery();

    // subscription to listen change status of bluetooth connection
    _subscriptionBtStatus = bluetoothManager.connectState.listen((status) {
      print(' ----------------- status bt $status ------------------ ');
      _currentStatus = status;
      if (status == BTConnectState.connected) {
        setState(() {
          _isConnected = true;
        });
      }
      if (status == BTConnectState.disconnect ||
          status == BTConnectState.fail) {
        setState(() {
          _isConnected = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _subscriptionBtStatus?.cancel();
    super.dispose();
  }

  void _scan() async {
    devices.clear();
    try {
      setState(() {
        _isScanning = true;
      });
      if (_isBle) {
        final results =
        await bluetoothManager.scan(timeout: const Duration(seconds: 10));
        devices.addAll(results);
        setState(() {});
      } else {
        final bondedDevices = await bluetoothManager.getAndroidPairedDevices();
        devices.addAll(bondedDevices);
        setState(() {});
      }
    } on BTException catch (e) {
      print(e);
    } finally {
      setState(() {
        _isScanning = false;
      });
    }
  }

  void _discovery() {
    devices.clear();
    try {
      bluetoothManager.discovery().listen((device) {
        devices.add(device);
        setState(() {});
      });
    } on BTException catch (e) {
      print(e);
    }
  }

  void selectDevice(BluetoothDevice device) async {
    if (selectedPrinter != null) {
      if (device.address != selectedPrinter!.address) {
        await bluetoothManager.disconnect();
      }
    }

    selectedPrinter = device;
    setState(() {});
  }

  void _print2X1() async {
    if (selectedPrinter == null) return;
    const codes =
        "^XA\r\n^MMT\r\n^PW384\r\n^LL0253\r\n^LS0\r\n^BY2,3,81^FT375,92^BCI,,N,N\r\n^FDILP-107661^FS\r\n^FT375,191^A0I,45,45^FH\\^FDILP-107661^FS\r\n^FT374,27^A0I,23,24^FH\\^FD^FS\r\n^FT372,59^A0I,23,24^FH\\^FD^FS\r\n^PQ1,0,1,Y^PQ1^XZ\r\n";

    try {
      await _connectDevice();
      if (!_isConnected) return;
      final isSuccess = await bluetoothManager.writeText(codes);
      if (isSuccess) {
        await bluetoothManager.disconnect();
      }
    } on BTException catch (e) {
      print(e);
    }
  }

  void _pdffile() async {
    if (selectedPrinter == null) return;

    try {
      await _connectDevice();
      if (!_isConnected) return;
      final file = printerProvider.getFile;
      debugPrint(file.toString());
      final isSuccess =
      await bluetoothManager.writeRawData(file!.buffer.asUint8List());
      if (isSuccess) {
        await bluetoothManager.disconnect();
      }
    } on BTException catch (e) {
      print(e);
    }
  }

  _connectDevice() async {
    if (selectedPrinter == null) return;
    try {
      _isConnected = await bluetoothManager.connect(
          address: selectedPrinter!.address, isBLE: selectedPrinter!.isLE);
    } on BTException catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter Simple Bluetooth Printer example app'),
        ),
        body: Center(
          child: Container(
            height: double.infinity,
            constraints: const BoxConstraints(maxWidth: 400),
            child: SingleChildScrollView(
              padding: EdgeInsets.zero,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedPrinter == null || _isConnected
                                ? null
                                : () {
                              _connectDevice();
                            },
                            child: const Text("Connect",
                                textAlign: TextAlign.center),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: selectedPrinter == null || !_isConnected
                                ? null
                                : () {
                              if (selectedPrinter != null) {
                                bluetoothManager.disconnect();
                              }
                              setState(() {
                                _isConnected = false;
                              });
                            },
                            child: const Text("Disconnect",
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: Platform.isAndroid,
                    child: SwitchListTile.adaptive(
                      contentPadding:
                      const EdgeInsets.only(bottom: 20.0, left: 20),
                      title: const Text(
                        "BLE (low energy)",
                        textAlign: TextAlign.start,
                        style: TextStyle(fontSize: 19.0),
                      ),
                      value: _isBle,
                      onChanged: (bool? value) {
                        setState(() {
                          _isBle = value ?? false;
                          _isConnected = false;
                          selectedPrinter = null;
                          _scan();
                        });
                      },
                    ),
                  ),
                  OutlinedButton(
                    onPressed: () {
                      _scan();
                    },
                    child: const Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 2, horizontal: 20),
                      child: Text("Rescan", textAlign: TextAlign.center),
                    ),
                  ),
                  _isScanning
                      ? const CircularProgressIndicator()
                      : Column(
                      children: devices
                          .map(
                            (device) => ListTile(
                          title: Text(device.name),
                          subtitle: Text(device.address),
                          onTap: () {
                            // do something
                            selectDevice(device);
                          },
                          trailing: OutlinedButton(
                            onPressed: selectedPrinter == null ||
                                device.name != selectedPrinter?.name
                                ? null
                                : () async {
                              _print2X1();
                              _pdffile();
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 20),
                              child: Text("Print test",
                                  textAlign: TextAlign.center),
                            ),
                          ),
                        ),
                      )
                          .toList()),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

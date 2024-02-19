import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/localhost_services/client.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';

class ClientProvider extends ChangeNotifier {
  Pack samplePack = Pack()
    ..type = PackType.respond.value
    ..device = "client side device"
    ..packId = "145"
    ..date = DateTime.now();
  Client? _client;
  Client? get client => _client;
  set client(Client? newClient) => client = newClient;
  bool _isConnected = false;
  bool get isConnected => _isConnected;
  //(_client !=null?(client!.isConnected?true:false):false);
  List<Pack> logs = [];
  StreamSubscription<NetworkAddress>? streamListener;
  NetworkAddress? _address;
  NetworkAddress? get address => _address;
  bool _searching = false;
  bool get searching => _searching;
  bool _connecting = false;
  bool get connecting => _connecting;

  getIpAddress({String subnet="192.168.1.3",int port=4000,bool cancel = false}) async {
    if(cancel) {
      streamListener?.cancel();
      _searching=false;
      notifyListeners();
    }else {
      streamListener?.cancel();
      _searching = true;
      notifyListeners();
      final stream = NetworkAnalyzer.i.discover(subnet, port);

      streamListener = stream.listen((NetworkAddress netAddress) {
        if (netAddress.exists) {
          _address = netAddress;
          _searching = false;
          notifyListeners();
        }
      });
      streamListener?.onDone(() {
        _searching = false;
        notifyListeners();
      });
    }
  }

  connectOrDisconnectClient(String ip,int port1) async {
    if (client == null || !client!.isConnected) {
      Client clientModel = Client(
          hostName: ip,
          port: port1,
          onData: onData,
          onError: onError);
      _client = clientModel;
    }
      if (client!.isConnected) {
        client!.disconnect(samplePack);
        _client=null;
        _isConnected = false;
        notifyListeners();
      } else {
        _connecting=true;
        notifyListeners();
        await client!.connect(samplePack);
        _connecting=false;
        _isConnected = client!.isConnected ? true : false;
        notifyListeners();
      }

  }

  bool sendPack(Pack pack) {
    if (_client != null) {
      _client!.write(pack.toJson());
      logs.add(pack);
      return true;
    } else {
      return false;
    }
  }


  List<int> fullData=[];
  onData(Uint8List data) async{
    fullData.addAll(data);
    await Future.delayed(const Duration(milliseconds: 500));
    String rawData=utf8.decode(Uint8List.fromList(fullData));
    fullData.clear();
      Pack pack = Pack().fromJson(rawData);
      ///get sent item list from server
      if (pack.type == PackType.itemList.value && pack.object != null) {
        for (var itemJson in pack.object!) {
          Item item = await Item().fromJson(itemJson);
          HiveBoxes.getItem().put(item.itemId, item);
        }

        ///get sent ware list from server
      } else if (pack.type == PackType.wareList.value && pack.object != null) {
        for (String itemJson in pack.object!) {
          RawWare ware = await RawWare().fromJson(itemJson);
          HiveBoxes.getRawWare().put(ware.wareId, ware);
        }

        ///refund send order to sure it's send
      } else if (pack.type == PackType.order.value &&
          pack.object != null &&
          pack.object!.isNotEmpty) {
        if (HiveBoxes.getPack()
            .values
            .map((e) => e.packId)
            .contains(pack.packId)) {
          Order order = Order().fromJson(pack.object!.first);
          order.isChecked = true;
          pack.object = [order.toJson()];
          HiveBoxes.getPack().put(pack.packId, pack);
          notifyListeners();
        }
      }
      logs.add(pack);
      notifyListeners();

  }

  onError(dynamic error) {
    ErrorHandler.errorManger(null, error,
        title: "**** onError in the ClientProvider ****");
  }



  clearLogs() {
    logs = [];
    notifyListeners();
  }
}

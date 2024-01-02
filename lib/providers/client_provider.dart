

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/item.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/models/raw_ware.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/localhost_services/client.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:ping_discover_network_plus/ping_discover_network_plus.dart';


class ClientProvider extends ChangeNotifier{
  Pack pack=Pack()..type= "order"..device="client side device"..packId= "145"..date=DateTime.now();

  Client? client;
  List<Pack> logs=[];
  int _port=4000;
  int get port=>_port;
  String _subnet="192.168.1";
  String get subnet=>_subnet;
  Stream<NetworkAddress>? stream;
  NetworkAddress? _address;
  NetworkAddress? get address=>_address;
  bool ipRunning=false;
  bool _searching=false;
  bool get searching=>_searching;

getIpAddress()async{
  _searching=true;
  final networkInfo = NetworkInfo();
  print(await networkInfo.getWifiBroadcast());
  notifyListeners();
  stream=NetworkAnalyzer.i.discover(_subnet, port);
  stream!.listen((NetworkAddress netAddress) {
    if (netAddress.exists) {
      _address = netAddress;
      Client clientModel = Client(hostName: netAddress.ip,
          port: _port,
          onData: onData,
          onError: onError);
      client = clientModel;
      _searching=false;
      notifyListeners();
    }
    // else {
    //   _address = null;
    // }
  });


  }


  void sendPack(Pack pack){
    Uint8List.fromList(utf8.encode(pack.toJson()));
    client!.write(pack.toJson());
    logs.add(pack);

  }

  onData(Uint8List data){
    Pack pack=Pack().fromJson(utf8.decode(data));
    if(pack.type=="itemList" && pack.object.isNotEmpty){
      for (var itemMap in pack.object) {
        Item item=Item().fromMap(itemMap!);
        HiveBoxes.getItem().put(item.itemId, item);
      }
    }
    if(pack.type=="wareList" && pack.object.isNotEmpty){
      for (var itemMap in pack.object) {
        RawWare ware=RawWare.fromMap(itemMap!);
        HiveBoxes.getRawWare().put(ware.wareId, ware);
      }
    }
    logs.add(pack);
    notifyListeners();
  }

  onError(dynamic error){
    debugPrint("onError in the ClientProvider ${error.toString()}");
  }

  setSubnetAndPort(String sub,int setPort){
   _port=setPort;
   _subnet=sub;
   notifyListeners();
  }
}
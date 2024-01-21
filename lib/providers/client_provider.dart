

import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
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

  Client? _client;
  Client? get client=>_client;
  set client(Client? newClient)=>client=newClient;
  bool _isConnected=false;
  bool get isConnected=>_isConnected;
      //(_client !=null?(client!.isConnected?true:false):false);
  List<Pack> logs=[];
  int _port=4000;
  int get port=>_port;
  String _subnet="192.168.1";
  String get subnet=>_subnet;
  Stream<NetworkAddress>? stream;
  NetworkAddress? _address;
  NetworkAddress? get address=>_address;
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
      _client = clientModel;
      notifyListeners();
      _searching=false;
      notifyListeners();
    }
    // else {
    //   _address = null;
    // }
  });


  }

  connectOrDisconnectClient()async{
  if(client !=null) {
      if (client!.isConnected) {
         client!.disconnect(pack);
        _isConnected=false;
        notifyListeners();
      } else {
       await client!.connect(pack);
        _isConnected=client!.isConnected?true:false;
        notifyListeners();
      }
    }
  }


  bool sendPack(Pack pack){
    Uint8List.fromList(utf8.encode(pack.toJson()));
    if(_client !=null) {
      _client!.write(pack.toJson());
      logs.add(pack);
      return true;
    }else{
      return false;
    }
  }

  onData(Uint8List data){
    Pack pack=Pack().fromJson(utf8.decode(data));
    if(pack.type=="itemList" && pack.object!=null){
      for (var itemJson in pack.object!) {
        Item item=Item().fromJson(itemJson);
        HiveBoxes.getItem().put(item.itemId, item);
      }
    }
    else if(pack.type=="wareList" && pack.object!=null){
      for (String itemJson in pack.object!) {
        RawWare ware=RawWare().fromJson(itemJson);
        HiveBoxes.getRawWare().put(ware.wareId, ware);
      }
    }else if(pack.type == "order" &&
        pack.object != null &&
        pack.object!.isNotEmpty) {
      if(HiveBoxes.getPack().values.map((e) => e.packId).contains(pack.packId)) {
        Order order = Order().fromJson(pack.object!.first);
        order.isChecked = true;
        pack.object = [order.toJson()];
        HiveBoxes.getPack().put(pack.packId, pack);
       // notifyListeners();
      }
    }
    logs.add(pack);
   // notifyListeners();
  }

  onError(dynamic error){
    ErrorHandler.errorManger(null, error,
        title: "**** onError in the ClientProvider ****");
  }

  setSubnetAndPort(String sub,int setPort){
   _port=setPort;
   _subnet=sub;
   notifyListeners();
  }

  clearLogs(){
    logs=[];
    notifyListeners();
  }
}
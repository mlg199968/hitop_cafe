import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/localhost_services/server.dart';


class ServerProvider extends ChangeNotifier {
  Pack pack=Pack()..type= "order"..device="Server side device"..packId= "145"..date=DateTime.now();
  ServerServices? server;
  List<Pack> serverLogs = [];
  String _ip="192.168.1.4";
  String get ip=>_ip;
  int _port=4000;
  int get port=>_port;

  initServer() {
    server ??= ServerServices(onData, onError);
  }

  Future<void> startOrCloseServer() async {
    if (server!.running) {
      await server!.close(pack);
      serverLogs.clear();
    } else {
      await server!.start(pack,ip: _ip,port: _port);
    }
    notifyListeners();
  }

  void handleMessage(String data){
    pack.message=data;
    server!.broadcast(pack.toJson());
    notifyListeners();
  }

  void onData(Uint8List? data) {
    if(data!=null) {
      Pack? pack = Pack().fromJson(utf8.decode(data));
      if(pack.type=="order" && pack.object!=null && pack.object!.isNotEmpty){

        Order order=Order().fromJson(pack.object!.first);
        HiveBoxes.getOrders().put(order.orderId, order);
      }
     // Order order = Order().fromJson(utf8.decode(data));
     // HiveBoxes.getOrders().put(order.orderId, order);

        serverLogs.add(pack);
    }
    notifyListeners();
  }

  void onError(dynamic error) {
    debugPrint("**** server provider onError ****");
    debugPrint(error.toString());
  }

  setIpAndPort(String ipAddress,int port1){
    _ip=ipAddress;
    _port=port1;
    notifyListeners();
  }
  setServer(ServerServices? newSever){
    server=newSever;
    notifyListeners();
  }
}

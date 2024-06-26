import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/enums.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/order.dart';
import 'package:hitop_cafe/models/pack.dart';
import 'package:hitop_cafe/screens/orders_screen/services/order_tools.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:hitop_cafe/services/localhost_services/server.dart';

class ServerProvider extends ChangeNotifier {
  Pack samplePack = Pack()
    ..type = PackType.respond.value
    ..device = "Server"
    ..packId = "145"
    ..date = DateTime.now();
  ServerServices? server;
  List<Pack> serverLogs = [];
  String _ip = "192.168.1.4";
  String get ip => _ip;
  int _port = 4000;
  int get port => _port;
  bool get isRunning => server != null
      ? server!.running
          ? true
          : false
      : false;
  //bool get isRunning=>_isRunning;

  initServer() {
    server ??= ServerServices(onData, onError);
  }

  Future<void> startOrCloseServer() async {
    if (server != null) {
      if (server!.running) {
        await server!.close(samplePack);
        serverLogs.clear();
      } else {
        await server!.start(samplePack, ip: _ip, port: _port).onError((error, stackTrace) {
        } );
      }
      notifyListeners();
    }
  }

  void handleMessage(Pack nPack) async {
    await server!.broadcast(nPack.toJson());
    notifyListeners();
  }
  List<int> fullData=[];
  void onData(Uint8List? data) async{
    if (data != null) {
      fullData.addAll(data);
      await Future.delayed(const Duration(milliseconds: 500));
      String rawData=utf8.decode(Uint8List.fromList(fullData));
      fullData.clear();
      //log(rawData);
        Pack? pack = Pack().fromJson(rawData);
        if (pack.type == PackType.order.value &&
            pack.object != null &&
            pack.object!.isNotEmpty) {
          Order order = Order().fromJson(pack.object!.single);
          notifyListeners();
          //after the user client send the order we compare the user auth data with database user
          bool isAuth = false;
          HiveBoxes
              .getUsers()
              .values
              .forEach((dbUser) {
            (dbUser.password == order.user?.password &&
                dbUser.userName == order.user?.userName)
                ? isAuth = true
                : false;
          });
          if (isAuth) {
            Order? oldOrder = HiveBoxes.getOrders().get(order.orderId);
            if (oldOrder != null) {
              order.billNumber = oldOrder.billNumber;
            } else {
              order.billNumber = OrderTools.getOrderNumber();
            }
            OrderTools.subtractFromWareStorage(order.items, oldOrder: oldOrder);
            HiveBoxes.getOrders().put(order.orderId, order);
            pack.object = [order.toJson()];
            pack.type = PackType.order.value;
            pack.message = "سفارش ${order.billNumber}دریافت شد";
            handleMessage(pack);
            notifyListeners();
          } else {
            samplePack.type = PackType.respond.value;
            samplePack.message = "کاربر احراز نشد";
            handleMessage(samplePack);
          }
        }
        serverLogs.add(pack);
        notifyListeners();
    }
  }

  void onError(Object error,StackTrace trace) {
    ErrorHandler.errorManger(null, error,
        title: "**** server provider onError ****",
    route: trace.toString());
  }

  setIpAndPort(String ipAddress, int port1) {
    _ip = ipAddress;
    _port = port1;
    notifyListeners();
  }

  closeServer() {
    if(server!=null) {
      server!.close(samplePack);
      server = null;
      notifyListeners();
    }
  }

  clearLogs() {
    serverLogs = [];
    notifyListeners();
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/error_handler.dart';
import 'package:hitop_cafe/models/pack.dart';

typedef Unit8ListCallback = Function(Uint8List data);
typedef DynamicCallback = Function(dynamic data);
final deviceIfo = DeviceInfoPlugin();

class Client {
  String hostName;
  int port;
  Unit8ListCallback? onData;
  DynamicCallback? onError;

  Client({
    required this.hostName,
    required this.port,
    required this.onData,
    this.onError,
  });
  bool isConnected = false;
  late Socket socket;
  Future<void> connect(Pack pack) async {
    try {
      socket = await Socket.connect(hostName, port);
      socket.listen(onData, onError: onError, onDone: () async {

        disconnect(pack);
        isConnected = false;
      });
      isConnected = true;
        const String message = "user got connected";
        pack.message=message;
         write(pack.toJson());
    } catch (e) {
      ErrorHandler.errorManger(null, e,title:"********* error on connect client to server *********");
    }
  }

  void write(String packJson) {
    socket.write(packJson);
  }

  void disconnect(Pack pack) {
    const String message = "user got disconnected";
    pack.message=message;
    write(pack.toJson());
    socket.destroy();
    isConnected = false;
  }
  ///get device id
  Future<String> getDeviceInfo()async{
    String info = "windows device";
    if (Platform.isAndroid) {
      final androidInfo = await deviceIfo.androidInfo;
      info = androidInfo.host + androidInfo.device;
    }
    else if(Platform.isWindows){
      final win = await deviceIfo.windowsInfo;
      info = win.computerName + win.deviceId;
    }
    return info;
  }

}

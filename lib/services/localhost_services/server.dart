
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/models/pack.dart';
typedef Unit8ListCallback=Function(Uint8List data);
typedef DynamicCallback=Function(Object data,StackTrace trace);

class ServerServices{
  Unit8ListCallback? onData;
  DynamicCallback? onError;
  ServerServices(this.onData,this.onError);

  ServerSocket? serverSocket;
  bool running=false;
  List<Socket> sockets=[];
  
  Future<void> start(Pack pack,{required String ip,required int port}) async{
      runZonedGuarded (()async{
      serverSocket = await ServerSocket.bind(ip, port);
      running = true;
      //serverSocket!.asBroadcastStream();
      serverSocket!.listen(onRequest,
          onError:(e){
        close(pack);
        debugPrint("start function serverSocket error*****\n$e");
      },
      onDone: (){
        close(pack);
      });
        pack.message = "serverSocket is listening in port $port";
        onData!(utf8.encode(pack.toJson()));

      },onError!, );
    }
  void onRequest(Socket socket){

    if(!sockets.contains(socket)){

      sockets.add(socket);
    }
    socket.listen((Uint8List event) {
      onData!(event);
    });
  }



  Future<void> broadcast(String data)async{
   // onData!(utf8.encode(data));
    for(final socket in sockets){
      socket.write(data);
    }
  }

  Future<void> close(Pack pack)async{
    pack.message="server closed";
    await broadcast(pack.toJson());
    if(serverSocket!=null) {
      await Future.delayed(const Duration(milliseconds: 1000));
      await serverSocket!.close();
    }
   // serverSocket=null;
    running=false;
  }
}
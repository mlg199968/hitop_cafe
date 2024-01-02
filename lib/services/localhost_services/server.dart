
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:hitop_cafe/models/pack.dart';
typedef Unit8ListCallback=Function(Uint8List data);
typedef DynamicCallback=Function(dynamic data);

class ServerServices{
  Unit8ListCallback? onData;
  DynamicCallback? onError;
  ServerServices(this.onData,this.onError);

  ServerSocket? serverSocket;
  bool running=false;
  List<Socket> sockets=[];
  
  Future<void> start(Pack pack,{required String ip,required int port}) async{
      runZoned (()async{
      serverSocket = await ServerSocket.bind(ip, port);
      running = true;
      serverSocket!.asBroadcastStream();
      serverSocket!.listen(onRequest).onError((e){
        close(pack);
        print("start function serverSocket error*****\n$e");
      });
        pack.message = "serverSocket is listening in port 4000";
        onData!(utf8.encode(pack.toJson()));

      },onError:onError );
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
    onData!(utf8.encode(data));
    for(final socket in sockets){
      socket.write(data);
    }
  }

  Future<void> close(Pack pack)async{
    pack.message="user closed";
    await broadcast(pack.toJson());
    await serverSocket!.close();
    serverSocket=null;
    running=false;
  }
}
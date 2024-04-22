// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

enum Allow{
  storage,
  externalStorage,
  camera,
}
Future<void> storagePermission(BuildContext context,Enum permission) async {

  // stock in status var the result of request
  PermissionStatus status = await Permission.storage.request();
  switch(permission){

    case(Allow.storage):
      status = await Permission.storage.request();
     break;
    case(Allow.externalStorage):
      status = await Permission.manageExternalStorage.request();
      break;
    case(Allow.camera):
      status = await Permission.camera.request();
      break;
  }


  if (status == PermissionStatus.denied) {
    // if the user deny, so we cancel the function

    return;
  } else if (status == PermissionStatus.permanentlyDenied) {
    // if the user permanently deny (it's the case if user deny two times)

    // we display a popup for say "Hey, you absolutely need this access for use this functionality, do you want allow it in parameters ?"
    showDialog<String>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Allow app to access your storage ?'),
        content: const Text(
            "You need to allow storage access in parameters for use photo in the app"),
        actions: <Widget>[

          // if user deny again, we do nothing
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Don\'t allow'),
          ),

          // if user is agree, you can redirect him to the app parameters :)
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
            child: const Text('Allow'),
          ),

        ],
      ),
    );
    return;
  }

  // code to execute if access is granted
}

bool userPermission(context){

  return true;
}
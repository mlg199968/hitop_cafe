import 'package:flutter/material.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/bug.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:uuid/uuid.dart';

class ErrorHandler {
 static errorManger(BuildContext context, var errorObject,
      {String? title, String? errorText, String? route,bool showSnackbar=false}) {
    String? routeDir=ModalRoute.of(context)?.settings.name;
    debugPrint("title: $title");
    debugPrint("error route :${route ?? routeDir }");
    debugPrint("error content :${errorText ?? errorObject.toString()}");

    Bug bug = Bug()
      ..title = title
      ..errorText = errorText ?? errorObject.toString()
      ..directory = routeDir
      ..bugDate=DateTime.now()
      ..bugId = const Uuid().v1();
    HiveBoxes.getBugs().put(bug.bugId, bug);
    if(showSnackbar && title!=null) {
      showSnackBar(context, title);
    }
  }
}

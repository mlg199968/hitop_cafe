
import 'package:flutter/cupertino.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';

class WareProvider extends ChangeNotifier{

  List rawWareCategories=["default",];
  String selectedRawWareCategory="default";

 List itemCategories=["default",];
  String selectedItemCategory="default";





  void addRawCategory(String groupName){
    rawWareCategories.insert(0,groupName);
    notifyListeners();
  }
  // void loadRawCategories(){
  //   List groups= HiveBoxes.getRawWareCategories();
  //   rawWareCategories.addAll(groups);
  //   rawWareCategories=rawWareCategories.toSet().toList();
  // }
  void updateSelectedRawCategory(String newSelect){
    selectedRawWareCategory=newSelect;
    notifyListeners();
  }

  ///item category functions
 void addItemCategory(String groupName){
    itemCategories.insert(0,groupName);
    notifyListeners();
  }
  void updateSelectedItemCategory(String newSelect){
    selectedItemCategory=newSelect;
    notifyListeners();
  }

  void loadCategories(){
    List itemGroups= HiveBoxes.getItemCategories();
    itemCategories.addAll(itemGroups);
    itemCategories=itemCategories.toSet().toList();

    List rawGroups= HiveBoxes.getRawWareCategories();
    rawWareCategories.addAll(rawGroups);
    rawWareCategories=rawWareCategories.toSet().toList();
  }
}
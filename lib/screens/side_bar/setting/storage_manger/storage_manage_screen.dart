import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/date_range_picker.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/screens/side_bar/setting/storage_manger/services/storage_tools.dart';

class StorageManageScreen extends StatefulWidget {
  static const String id = "/storage-manage-screen";
  const StorageManageScreen({super.key});

  @override
  State<StorageManageScreen> createState() => _StorageManageScreenState();
}

class _StorageManageScreenState extends State<StorageManageScreen> {
  DateTime? startCreateDate;
  DateTime? endCreateDate;
  String selectedStorage = "سفارش ها";
  List storageList = [
    "کالا ها",
    "آیتم ها",
    "سفارش ها",
    "فاکتور ها",
  ];
  String selectedOperation = "حذف";
  List operationList = [
    "حذف",
  ];

  operationButtonFunc(){
    if(selectedOperation=="حذف"){
      switch(selectedStorage){
        case "کالا ها":
          StorageTools.deleteWares(begin: startCreateDate,end: endCreateDate);
          break;
        case "آیتم ها":
          StorageTools.deleteItems(begin: startCreateDate,end: endCreateDate);
          break;
        case "سفارش ها":
          StorageTools.deleteOrders(begin: startCreateDate,end: endCreateDate);
          break;
        case "فاکتور ها":
          StorageTools.deleteBills(begin: startCreateDate,end: endCreateDate);
          break;
      }

    }
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("مدیریت داده ها"),
      ),
      body: Container(
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          gradient: kMainGradiant
        ),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20,horizontal: 10).copyWith(top: 70),
          padding: const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
          width: 500,
          decoration: BoxDecoration(
              gradient: kBlackWhiteGradiant,
              borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ///storage drop list
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropListModel(
                          listItem: storageList,
                          selectedValue: selectedStorage,
                          onChanged: (val) {
                            selectedStorage = val;
                            setState(() {});
                          }),
                      const Text("انتخاب نوع داده"),
                    ],
                  ),
                  ///operation drop list
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropListModel(
                          listItem: operationList,
                          selectedValue: selectedOperation,
                          onChanged: (val) {
                            selectedOperation = val;
                            setState(() {});
                          }),
                      const Text("انتخاب عملیات"),
                    ],
                  ),
                  const Gap(20),
                  ///search by created date ,create date range
                  CustomDateRangePicker(
                      enable: true,
                      title: "انتخاب محدوده زمانی ",
                      startDate: startCreateDate,
                      endDate: endCreateDate,
                      onPress: (picked){
                        if(picked!=null) {
                          startCreateDate = picked.start.toDateTime();
                          endCreateDate = picked.end.toDateTime();
                        }
                        setState(() {});
                      }
                  ),
                ],
              ),
              ///button
              CustomButton(text: "اجرا عملیات", onPressed: (){operationButtonFunc();}),
            ],
          ),
        ),
      ),
    );
  }
}

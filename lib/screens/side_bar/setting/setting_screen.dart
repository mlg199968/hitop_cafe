import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/permission_handler.dart';
import 'package:hitop_cafe/constants/utils.dart';
import 'package:hitop_cafe/models/shop.dart';
import 'package:hitop_cafe/providers/printer_provider.dart';
import 'package:hitop_cafe/providers/user_provider.dart';
import 'package:hitop_cafe/screens/side_bar/setting/backup/backup_tools.dart';
import 'package:hitop_cafe/screens/side_bar/sidebar_panel.dart';
import 'package:hitop_cafe/services/hive_boxes.dart';
import 'package:printing/printing.dart';

import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingScreen extends StatefulWidget {
  static const String id = "/SettingScreen";

  const SettingScreen({Key? key}) : super(key: key);

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final TextEditingController taxController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  late String selectedCurrency;
  late UserProvider provider;



  ///printer
  Printer? selectedPrinter;

  ///save part
  void storeInfoShop() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    shopInfo??=Shop();
    shopInfo..currency = selectedCurrency
      ..preTax = stringToDouble(taxController.text)
      ..preBillNumber = stringToDouble(billNumberController.text).toInt()
      ..printer=selectedPrinter==null?null:selectedPrinter!.toMap();
    provider.getData(shopInfo);
    HiveBoxes.getShopInfo().put(0, shopInfo);
  }

  void getData() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    if (shopInfo != null) {
      selectedCurrency = shopInfo.currency;
      taxController.text = shopInfo.preTax.toString();
      billNumberController.text = shopInfo.preBillNumber.toString();
      selectedPrinter=shopInfo.printer!=null?Printer.fromMap(shopInfo.printer!):null;
    }
  }

  @override
  void initState() {
    selectedCurrency = kCurrencyList[0];
    getData();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    provider = Provider.of<UserProvider>(context, listen: false);
    super.didChangeDependencies();
  }

  @override
  void dispose() {

    storeInfoShop();
    print("dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(gradient: kMainGradiant),
        ),
        title: const Text("تنظیمات"),
      ),
      body: Consumer<PrinterProvider>(
        builder: (context,printerProvider,child) {
          return Stack(
            children: [
              Directionality(
                textDirection: TextDirection.rtl,
                child: Column(
                  children: [
                    Card(
                      child: Container(
                        padding: const EdgeInsets.all(15),
                        margin: const EdgeInsets.all(15),
                        decoration:
                            BoxDecoration(border: Border.all(color: Colors.blue)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            CustomButton(
                              text: "پشتیبان گیری",
                              color: Colors.red.withRed(250),
                              onPressed: () async {
                                await storagePermission(context, Allow.externalStorage);
                                // ignore: use_build_context_synchronously
                                await storagePermission(context, Allow.storage);
                                if(context.mounted) {
                                  await BackupTools.createBackup(context);
                                }
                              },
                            ),
                            CustomButton(
                              text: "بارگیری فایل پشتیبان",
                              color: Colors.green,
                              onPressed: () async {
                                await storagePermission(context, Allow.storage);
                                if(context.mounted) {
                                  await storagePermission(context, Allow.externalStorage);
                                }
                                if(context.mounted) {
                                 // await BackupTools.restoreBackup(context);
                                  await BackupTools.readZipFile(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ///currency unit
                    DropListItem(
                        title: "واحد پول",
                        selectedValue: selectedCurrency,
                        listItem: kCurrencyList,
                        onChange: (val) {
                          selectedCurrency = val;
                          setState(() {});
                        }),
                    /// preTax value
                    InputItem(
                      label: "مالیات پیشفرض :",
                      inputLabel: "درصد",
                      controller: taxController,
                      width: 100,
                      onChange: (val) {
                        if (val != "" && stringToDouble(val) > 100) {
                          taxController.text = 99.toString();
                          setState(() {});
                        }
                      },
                    ),
                    ///starter bill number
                    InputItem(
                      label: "شروع شماره فاکتور:",
                      inputLabel: "شماره",
                      controller: billNumberController,
                    ),
                    if(Platform.isWindows)
                    ButtonTile(onPress: () async {
                      // Show the native printer picker and get the selected printer
                      final printer = await Printing.pickPrinter(
                          context: context, title: "پرینتر را انتخاب کنید");
                      if(printer!=null) {
                        selectedPrinter=printer;
                      }
                      setState(() {});
                    }, label:"انتخاب پرینتر" , buttonLabel: selectedPrinter==null?"پرینتری یافت نشد":selectedPrinter!.name)
                  ],
                ),
              ),
              ///**************************************************************************************************
              ///condition for:if user not purchase the app,it will see purchase button to buy complete version
              Provider.of<UserProvider>(context,listen: false).userLevel!=0
                  ? const SizedBox()
                  : Container(
                padding: const EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height ,
                color: Colors.black87.withOpacity(.7),
                //height: MediaQuery.of(context).size.height,
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        "برای استفاده از این بخش نسخه کامل برنامه را فعال کنید.",
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white, fontSize: 18),

                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    PurchaseButton(),
                  ],
                ),
              ),
            ],
          );
        }
      ),
    );
  }
}





///switch field
class SwitchItem extends StatelessWidget {
  const SwitchItem({
    super.key,
    required this.title,
    required this.onChange,
  });

  final String title;
  final void Function(bool) onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            Switch(value: false, onChanged: onChange),
          ],
        ),
      ),
    );
  }
}
///drop list field
class DropListItem extends StatelessWidget {
  const DropListItem({
    super.key,
    required this.title,
    required this.selectedValue,
    required this.listItem,
    required this.onChange,
  });

  final String title;
  final String selectedValue;
  final List<String> listItem;
  final void Function(String) onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title),
            DropListModel(
                elevation: 0,
                width: 80,
                height: 30,
                listItem: listItem,
                selectedValue: selectedValue,
                onChanged: onChange),
          ],
        ),
      ),
    );
  }
}
///text field field
class InputItem extends StatelessWidget {
  const InputItem(
      {Key? key,
      required this.controller,
      this.onChange,
      this.width = 150, required this.label, required this.inputLabel})
      : super(key: key);

  final String label;
  final String inputLabel;
  final TextEditingController controller;
  final double width;
  final Function(String val)? onChange;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(label),
            CustomTextField(
                label: inputLabel,
                controller: controller,
                width: width,
                textFormat: TextFormatter.number,
                onChange: onChange)
          ],
        ),
      ),
    );
  }
}




///text field field
class ButtonTile extends StatelessWidget {
  const ButtonTile(
      {Key? key,
      required this.onPress,

      this.width = 150,
        required this.label,
        required this.buttonLabel,
      })
      : super(key: key);

  final String label;
  final String buttonLabel;
  final VoidCallback onPress;
  final double width;


  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
             Text(label),
            ElevatedButton(
              onPressed: onPress,
              child: Text(buttonLabel),
            ),
          ],
        ),
      ),
    );
  }
}

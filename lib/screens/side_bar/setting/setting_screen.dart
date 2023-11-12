import 'package:flutter/material.dart';
import 'package:hitop_cafe/common/widgets/custom_button.dart';
import 'package:hitop_cafe/common/widgets/custom_textfield.dart';
import 'package:hitop_cafe/common/widgets/drop_list_model.dart';
import 'package:hitop_cafe/constants/constants.dart';
import 'package:hitop_cafe/constants/extensions.dart';
import 'package:hitop_cafe/constants/global.dart';
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
  final Future<SharedPreferences> _prefs=SharedPreferences.getInstance();
  final TextEditingController taxController = TextEditingController();
  final TextEditingController billNumberController = TextEditingController();
  late String selectedCurrency;
  late UserProvider provider;



  ///printer
  // late PrinterProvider? printerProvider;
  late List<Printer> _printers; // A list of printers to display
  late String? selectedPrinter;
  String? namePrinter = Global.storageService.getnamePrinter();
  // Printer? newPrinter;
  String? defaultPrinter = Global.storageService.getdefaultPrinter();
  ///get default printer
  Future<void> getDefaultPrinter() async {
    Printing.listPrinters().then((printers) {
      // Map<dynamic, dynamic> map = jsonDecode(jsonSting);
      setState(() {
        // Create a list of printers from the map

// Find the printer that has isDefault: true
        Printer defaultPrinter = printers.firstWhere((p) => p.isDefault);
        namePrinter = defaultPrinter.name;
        Global.storageService.setString(printerName, namePrinter!);
        debugPrint(namePrinter);
// Print the default printer name and model
        print(defaultPrinter.name); // HP LaserJet 1018
        print(defaultPrinter.model); // HP LaserJet 1018

        _printers = printers;
        debugPrint(_printers.toString());
      });
    });
    // return defaultPrinter!.name;
  }

  ///save part
  void storeInfoShop() async{
    SharedPreferences pref=await _prefs;
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    if (shopInfo != null) {
      shopInfo.currency = selectedCurrency;
      shopInfo.preTax = stringToDouble(taxController.text);
      shopInfo.preBillNumber = stringToDouble(billNumberController.text).toInt();
      pref.setInt("billNumber", stringToDouble(billNumberController.text).toInt());
      provider.getData(shopInfo);
      HiveBoxes.getShopInfo().put(0, shopInfo);
    }
  }

  void getData() {
    Shop? shopInfo = HiveBoxes.getShopInfo().get(0);
    if (shopInfo != null) {
      selectedCurrency = shopInfo.currency;
      taxController.text = shopInfo.preTax.toString();
      billNumberController.text = shopInfo.preBillNumber.toString();
    }
  }

  @override
  void initState() {
    selectedCurrency = kCurrencyList[0];
    getData();
    getDefaultPrinter();
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

                    //SwitchItem(title: "title", onChange: (val) {}),
                    ElevatedButton(
                      onPressed: () async {
                        // Show the native printer picker and get the selected printer
                        final printer = await Printing.pickPrinter(
                            context: context, title: "پرینتر را انتخاب کنید");
                        Printer newPrinter = printer!.copyWith(
                          isDefault: printer.isDefault
                              ? printer.isDefault
                              : printer.isAvailable
                              ? true
                              : printer.isDefault,
                          // : true,
                        );
                        debugPrint(newPrinter.name);
                        debugPrint(newPrinter.isDefault.toString());
                        printerProvider.setPrinterName(newPrinter.name);
                        printerProvider.setPrinter(newPrinter);

                        // setState(() {
                        Global.storageService
                            .setString(printerDefault, newPrinter.name);
                        // defaultPrinter;
                        debugPrint(defaultPrinter);
                        // });
                      },
                      child: Text(printerProvider.getPrinterName.toString()),
                    ),
                  ],
                ),
              ),
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
